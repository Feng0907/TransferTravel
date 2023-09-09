//
//  BusSearchTableVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/4.
//

import UIKit

class BusSearchTableVC: UITableViewController, UISearchResultsUpdating {
	
//	@IBOutlet var searchController: UISearchBar!
	var filteredData = [BusRouteInfoResult]()
	var searchController = UISearchController(searchResultsController: nil)
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setSearchBar(searchController)
		self.navigationItem.searchController = self.searchController
		self.searchController.searchResultsUpdater = self
		
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	override func viewDidAppear(_ animated: Bool) {
		setPlaceholderLabelColor(searchController)
	}
	
	func setSearchBar(_ searchController : UISearchController){
		searchController.searchBar.placeholder = "目前僅能搜尋雙北公車"
		searchController.searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
		searchController.searchBar.searchTextField.textColor = .white
		searchController.searchBar.searchTextField.leftView?.tintColor = .white
		searchController.searchBar.searchTextField.rightView?.tintColor = .white
		searchController.searchBar.barStyle = .black
		searchController.searchBar.tintColor = .white
		if let clearButton = searchController.searchBar.searchTextField.value(forKey: "clearButton") as? UIButton {
				clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal) // 使用系统提供的白色清除按钮图标
				clearButton.tintColor = .white // 设置清除按钮颜色为白色
			}
	}
	func setPlaceholderLabelColor(_ searchController : UISearchController){
		if let placeholderLabel = searchController.searchBar.searchTextField.value(forKey: "placeholderLabel") as? UILabel {
				placeholderLabel.textColor = UIColor.white.withAlphaComponent(0.6)
			}
	}
	
	@IBAction func menuBtn(_ sender: Any) {
		sideMenuController?.toggleLeftView(animated: true)
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
	
	//MARK:searchResultsUpdater
	func updateSearchResults(for searchController: UISearchController) {
		guard let searchText = self.searchController.searchBar.text?.encodeUrl() else {
			print("請輸入想找的路線")
			return
		}
		if searchText.count > 1 && searchText.count <= 5 {
//			print(searchText)
			BusCommunicator.shared.getBusRouteInfo(searchText, city: "Taipei") { result, error in
				
				if let error = error {
					self.showAlert(message: "error: \(error)")
					self.searchController.searchBar.text? = ""
					return
				}
				
				guard let data = result else {
					self.showAlert(message: "查無所搜尋路線")
					self.searchController.searchBar.text? = ""
					return
				}
				self.filteredData = data
				self.tableView.reloadData()
			}
			
		}

	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.filteredData.count
    }
	

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "searchRusRoute", for: indexPath)
		let item = filteredData[indexPath.row]
		cell.textLabel?.text = item.routeName.zhTw
		cell.detailTextLabel?.text = item.departureStopNameZh + " - " + item.destinationStopNameZh
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "busRouteListSegue",
		   let BusRouteVC = segue.destination as? BusRouteTableVC,
		   let index = self.tableView.indexPathForSelectedRow {
			let item = self.filteredData[index.row]
			BusInfoSendHelper.shared.SendBusInfo = item
			BusRouteVC.busInfo = BusInfoSendHelper.shared.SendBusInfo
		}
	}


}
