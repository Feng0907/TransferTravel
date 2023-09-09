//
//  BusRouteVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/10.
//

import UIKit

class BusRouteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var busInfo: BusRouteInfoResult?
	var busStopsResult = [BusStopResult]()
	var busStopsResultTo: BusStopResult?
	var busStopsResultBack: BusStopResult?
	var busStopsTo = [BusStop]()
	var busStopsBack = [BusStop]()
	var busStopsShow = [BusStop]()
	var toEndStopName = ""
	var backEndStopName = ""
	
	@IBOutlet weak var navSegmenteView: UIView!
	@IBOutlet weak var segmentRouteChange: UISegmentedControl!
	
	@IBOutlet weak var busRouteStopsTable: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.busRouteStopsTable.dataSource = self
		self.busRouteStopsTable.delegate = self
		guard let busInfo = busInfo else {
			assertionFailure("busInfo find Fail!")
			return
		}
		self.toEndStopName = busInfo.departureStopNameZh
		self.backEndStopName = busInfo.destinationStopNameZh
		let normalTextAttributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.white
		]
		self.segmentRouteChange.setTitleTextAttributes(normalTextAttributes, for: .normal)
		let selectedTextAttributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.white
		]
		self.segmentRouteChange.setTitleTextAttributes(selectedTextAttributes, for: .selected)
		self.segmentRouteChange.setTitle("往\(toEndStopName)", forSegmentAt: 0)
		self.segmentRouteChange.setTitle("往\(backEndStopName)", forSegmentAt: 1)

		self.navigationItem.title = busInfo.routeName.zhTw
		guard let routeName = busInfo.routeName.zhTw.encodeUrl() else {
			assertionFailure("routeName find Fail!")
			return
		}
		let busCity = busInfo.city
		BusCommunicator.shared.getBusStopOfRoute(routeName, city: busCity) { result, error in
			
			if let error = error {
				self.showAlert(message: "error: \(error)")
				return
			}
			
			guard let data = result else {
				self.showAlert(message: "站牌連線異常")
				return
			}
			self.busStopsResult = data
			self.busStopsResultTo = data[0]
			self.busStopsResultBack = data[1]
			self.busStopsTo = data[0].stops
			self.busStopsBack = data[1].stops
//			print("busStopsTo: \(self.busStopsTo)")
//			print("busStopsBack: \(self.busStopsBack)")
			self.busStopsShow = self.busStopsTo
			self.busRouteStopsTable.reloadData()
		}
        // Do any additional setup after loading the view.
    }
	@IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			self.busStopsShow = self.busStopsTo
			self.busRouteStopsTable.reloadData()
			break
		case 1:
			self.busStopsShow = self.busStopsBack
			self.busRouteStopsTable.reloadData()
			break
		default:
			break
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.busStopsShow.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		print("busStopsTo: \(self.busStopsTo)")
		guard let selfcell = tableView.dequeueReusableCell(withIdentifier: "busStopsCell", for: indexPath) as? BusStopsTVCell else{
		   fatalError("請確認storybord上有設定customcell")
	   }
		let item = busStopsShow[indexPath.row]
		selfcell.busStopNameLabel?.text = item.stopName.zhTw
		selfcell.busStopTimeLabel?.text = "末班車駛離"
		selfcell.busStopTimeLabel.layer.cornerRadius = 5
		selfcell.busStopTimeLabel.clipsToBounds = true
		return selfcell
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
