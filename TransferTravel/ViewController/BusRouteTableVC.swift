//
//  BusRouteTableVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/7.
//

import UIKit

class BusRouteTableVC: UITableViewController {
	
	var busInfo: BusRouteInfoResult?
	var busStopsResult = [BusStopResult]()
	var busStopsResultTo: BusStopResult?
	var busStopsResultBack: BusStopResult?
	var busStopsTo = [BusStop]()
	var busStopsBack = [BusStop]()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		let segmentedControl = UISegmentedControl(items: ["1", "2"])
		segmentedControl.selectedSegmentIndex = 0 // 设置默认选中的分段
		segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
		let titleLabel = UILabel()
		titleLabel.text = busInfo?.routeName.zhTw
		titleLabel.sizeToFit()
		let navtitleView = UIView()
		navtitleView.addSubview(titleLabel)
		navtitleView.addSubview(segmentedControl)
		titleLabel.frame.origin = CGPoint(x: 0, y: 0)
		segmentedControl.frame.origin = CGPoint(x: 0, y: titleLabel.frame.maxY + 8)
		navigationItem.titleView = navtitleView
		
		guard let routeName = busInfo?.routeName.zhTw.encodeUrl() else {
			assertionFailure("routeName find Fail!")
			return
		}
		guard let busCity = busInfo?.city else {
			assertionFailure("busCity find Fail!")
			return
		}
		
		BusCommunicator.shared.getBusStopOfRoute(routeName, city: busCity) { result, error in
			
			if let error = error {
				self.showAlert(message: "error: \(error)")
				return
			}
			
			guard let data = result else {
				self.showAlert(message: "站牌連線異常")
				return
			}
//			print("data[0]: \(data[0])")
//			print("data[1]: \(data[1])")
			self.busStopsResult = data
			self.busStopsResultTo = data[0]
			self.busStopsResultBack = data[1]
			self.busStopsTo = data[0].stops
			self.busStopsBack = data[1].stops
//			print("busStopsTo: \(self.busStopsTo)")
//			print("busStopsBack: \(self.busStopsBack)")
			self.tableView.reloadData()
		}
    }
	
	@objc
	func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			// 执行选项1的操作
			break
		case 1:
			// 执行选项2的操作
			break
		default:
			break
		}
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return self.busStopsTo.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		print("busStopsTo: \(self.busStopsTo)")
		guard let selfcell = tableView.dequeueReusableCell(withIdentifier: "busStopsCell", for: indexPath) as? BusStopsTVCell else{
		   fatalError("請確認storybord上有設定customcell")
	   }
		let item = busStopsTo[indexPath.row]
		selfcell.busStopNameLabel?.text = item.stopName.zhTw
		selfcell.busStopTimeLabel?.text = "末班車駛離"
		selfcell.busStopTimeLabel.layer.cornerRadius = 5
		selfcell.busStopTimeLabel.clipsToBounds = true
        return selfcell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
