//
//  HistoryTableVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/22.
//

import UIKit
import CoreData

class HistoryTableVC: UITableViewController {
	
	var recordInfo = TimeRecordItem()
	var historyList = [HistoryItem]()
	
	let formatter = DateFormatter()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.queryFromCoreData()//讀出資料庫資料
		print(recordInfo.routeID)
		print(recordInfo.timerecordID)
		
		print(historyList)
		navigationItem.title = "\(recordInfo.startName) - \(recordInfo.endName)"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return historyList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
		let item = historyList[indexPath.row]
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		cell.textLabel?.text = item.spendTime
		cell.detailTextLabel?.text = formatter.string(from: item.recordTime)
//		String(format: "Last seen: %.1f seconds ago.", Date().timeIntervalSince(item.lastSeen))
        return cell
    }
	
	private func queryFromCoreData(){
		let moc = CoreDataHelper.shared.managedObjectContext()
		let request = NSFetchRequest<HistoryItem>(entityName: "HistoryItem")//資料庫裡的table名稱
		print(recordInfo.timerecordID)
		let predicate = NSPredicate(format: " timerecordID = %@ ", recordInfo.timerecordID )
		let sort = NSSortDescriptor(key: "recordTime", ascending: true)
		request.predicate = predicate
		request.sortDescriptors = [sort]
		do{
			let result = try moc.fetch(request)
			self.historyList = result
		}catch{
			self.historyList = []
			print("query cora data error \(error)")
		}
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
			let deletedData = self.historyList.remove(at: indexPath.row)
			let moc = CoreDataHelper.shared.managedObjectContext()
			moc.performAndWait {
				moc.delete(deletedData)
			}
			CoreDataHelper.shared.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
			
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
