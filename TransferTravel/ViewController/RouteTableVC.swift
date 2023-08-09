//
//  RouteTableVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/8.
//

import UIKit
import CoreData

class RouteTableVC: UITableViewController {
	//綜合清單列表
	//需要有三種不同的物件
	//1)自定義計時物件
	//2)公車站牌物件
	//3)捷運站物件
	
	//自定義排序要怎麼達成？
	
	@IBOutlet weak var routeName: UITextField!
	
	var RouteItem: RouteItem?
	var selfitems = [TimeRecordItem]()
	
	required init?(coder: NSCoder) {
		super .init(coder: coder)
		//core data
//		queryFromCoreData()//讀出資料庫資料
		// 產生10筆假資料(Note),Array再一起
//		let item = RouteItem()
//		item.routeID = ""
//		item.routeName = "回家路線"
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		guard let item = RouteItem,
			  let routeName = item.routeName else {
			return
		}
		self.routeName.text = routeName

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		
		return selfitems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selfRouteItem", for: indexPath)
		

		
        // Configure the cell...

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
	/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
	 */


}
