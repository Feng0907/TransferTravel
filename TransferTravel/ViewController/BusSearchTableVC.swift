//
//  BusSearchTableVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/4.
//

import UIKit

class BusSearchTableVC: UITableViewController, UISearchResultsUpdating {
	
//	@IBOutlet var searchController: UISearchBar!
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
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
	
	//MARK:searchResultsUpdater
	func updateSearchResults(for searchController: UISearchController) {
		//搜尋匡輸入後會呼叫的方法
		//根據使用者輸入的條件，將過濾的資料放到filtData中
		if let searchText = self.searchController.searchBar.text{
//			self.filteredData = self.data.filter{note in
//				//轉小寫在進行比對contains
//				return note.text.lowercased().contains(searchText.lowercased())
//			}
			/*
			//filter：block等同於下面方程式
			self.filteredData.removeAll()//先清空filteredData裡的資料
			for note in self.data{
				if note.text.lowercased().contains(searchText.lowercased()){
					self.filteredData.append(<#T##newElement: Note##Note#>)
				}
			}*/
		}
		self.tableView.reloadData()
	}
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
