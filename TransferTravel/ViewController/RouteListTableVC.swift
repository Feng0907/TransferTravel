//
//  RouteListTableVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/3.
//

import UIKit
import CoreData
import LGSideMenuController

class RouteListTableVC: UITableViewController, RouteTableVCDelegate {
	
	var RouteList = [RouteItem]()
	required init?(coder: NSCoder) {
		super .init(coder: coder)
		self.queryFromCoreData()//讀出資料庫資料
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.reloadData()
//		BusCommunicator.shared.getCity { (result, error) in
//			if let result = result {
//				print("Success with cities: \(result)")
//
//			} else if let error = error {
//				print("Fail with: \(error)")
//			} else {
//				print("No data received")
//			}
//		}
//		BusCommunicator.shared.getCity { result, error in
//			guard let messages = result, messages.count > 0 else {
//				print("No new message.")
//				return
//			}
//			print(messages)
//		}
		
//		self.queryFromCoreData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	@IBAction func menuBtn(_ sender: Any) {
		sideMenuController?.toggleLeftView(animated: true)
	}
	
	@IBAction func addBtnPressed(_ sender: Any) {
		let alert = UIAlertController(title: "新增路線", message: "新增一個路線群組", preferredStyle: .alert)
//		alert.addTextField { (textField) in
//			textField.placeholder = "請輸入路線名稱"
//		}
		alert.addTextField {
				(textField: UITextField!) -> Void in
				textField.placeholder = "請輸入路線名稱"
			}
		let save = UIAlertAction(title: "Save", style:.default) { [weak alert] _ in
			guard let textFields = alert?.textFields else{
				return
			}
			let newName = textFields[0].text!
			let moc = CoreDataHelper.shared.managedObjectContext()
			let item = RouteItem(context: moc)
			item.routeName = newName
			let dataCount = self.RouteList.count
			if dataCount == 0{
				item.routeID = 1
			}else{
				let preNote = self.RouteList[dataCount-1]
				item.routeID = preNote.routeID + 1
			}
			self.RouteList.append(item)
			self.saveToCoreData()//存到資料庫

			let index = IndexPath(row: self.RouteList.count - 1, section: 0)
			self.tableView.insertRows(at: [index], with: .automatic)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		alert.addAction(save)
		alert.addAction(cancel)
		present(alert, animated: true)
	}
	
	func didFinishUpdate(item: RouteItem) {
		self.saveToCoreData()
		self.tableView.reloadData()//reload tableView
	}
	
	// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return RouteList.count
    }
	
	

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteListCell", for: indexPath)
		let item = RouteList[indexPath.row]
		//預設cell上的物件
		cell.textLabel?.text = item.routeName
		cell.detailTextLabel?.text = String(item.routeID)

        return cell
    }
	
	private func queryFromCoreData(){
		let moc = CoreDataHelper.shared.managedObjectContext()
		let request = NSFetchRequest<RouteItem>(entityName: "RouteItem")//資料庫裡的table名稱
		let sort = NSSortDescriptor(key: "routeID", ascending: true)
		request.sortDescriptors = [sort]
		do{
			let result = try moc.fetch(request)
			self.RouteList = result
		}catch{
			self.RouteList = []
			print("query cora data error \(error)")
		}
	}
	func saveToCoreData(){
		CoreDataHelper.shared.saveContext()
	}
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			//記得補做做刪除的動作
			let deletedData = self.RouteList.remove(at: indexPath.row)
			let moc = CoreDataHelper.shared.managedObjectContext()
			moc.performAndWait {
				moc.delete(deletedData)
			}
			self.saveToCoreData()
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
//             Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)//取消選取
		SendRouteHelper.shared.keepSendRouteID = RouteList[indexPath.row].routeID
	}

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "RouteTableSegue" {
			if let targetVC = segue.destination as? RouteTableVC,
			   //所指定的那一列
			let indexPath = tableView.indexPathForSelectedRow {
				let item = RouteList[indexPath.row]
				targetVC.routeItem = item
				targetVC.delegate = self
			}
		}

    }


}
