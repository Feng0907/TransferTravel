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
//	var busStopsResultTo: BusStopResult?
//	var busStopsResultBack: BusStopResult?
	var busStopsTo = [BusStop]()
	var busStopsBack = [BusStop]()
	var busStopsShow = [BusStop]()
	var toEndStopName = ""
	var backEndStopName = ""
	var busStopsToTime = [StopOfTimeArrival]()
	var busStopsBackTime = [StopOfTimeArrival]()
	var busArrToTime = [BusArrivalData]()
	var busArrBackTime = [BusArrivalData]()
	var nowDirection = 0
	var timer = Timer()

	@IBOutlet weak var navSegmenteView: UIView!
	@IBOutlet weak var segmentRouteChange: UISegmentedControl!
	@IBOutlet weak var oneRouteLabel: UILabel!
	@IBOutlet weak var busRouteStopsTable: UITableView!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			let mainWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
			let statusBarHeight = mainWindow.windowScene?.statusBarManager?.statusBarFrame.height
			let screenWidth = UIScreen.main.bounds.width
			let totalHeight = 44 + statusBarHeight!
			self.navSegmenteView.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: 50)
		}
		self.busRouteStopsTable.dataSource = self
		self.busRouteStopsTable.delegate = self
		
		guard let busInfo = busInfo else {
			assertionFailure("busInfo find Fail!")
			return
		}
		guard let routeName = busInfo.routeName.zhTw.encodeUrl() else {
			assertionFailure("routeName find Fail!")
			return
		}
		self.toEndStopName = busInfo.departureStopNameZh ?? busInfo.destinationStopNameZh
		self.backEndStopName = busInfo.destinationStopNameZh
		segmentConfig()
		queryStops(of: routeName, at: busInfo.city)
		self.oneRouteLabel.isHidden = true
		self.navigationItem.title = busInfo.routeName.zhTw
		queryStopTimeOfArrival(of: routeName, at: busInfo.city)
		queryBusArrrivalTime(of: routeName, at: busInfo.city)
		self.timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
			self.queryStopTimeOfArrival(of: routeName, at: busInfo.city)
			self.queryBusArrrivalTime(of: routeName, at: busInfo.city)
			self.busRouteStopsTable.reloadData()
		}
		RunLoop.current.add(timer, forMode: .common)
    }
	override func viewWillDisappear(_ animated: Bool) {
		timer.invalidate()
	}
	
	func segmentConfig(){
		
		let normalTextAttributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.white
		]
		self.segmentRouteChange.setTitleTextAttributes(normalTextAttributes, for: .normal)
		let selectedTextAttributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.white
		]
		self.segmentRouteChange.setTitleTextAttributes(selectedTextAttributes, for: .selected)
		self.segmentRouteChange.setTitle("往\(backEndStopName)", forSegmentAt: 0)
		self.segmentRouteChange.setTitle("往\(toEndStopName)", forSegmentAt: 1)
	}
	
	@IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			self.busStopsShow = self.busStopsTo
			self.nowDirection = 0
			self.busRouteStopsTable.reloadData()
			break
		case 1:
			self.busStopsShow = self.busStopsBack
			self.nowDirection = 1
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
		guard let selfcell = tableView.dequeueReusableCell(withIdentifier: "busStopsCell", for: indexPath) as? BusStopsTVCell else{
		   fatalError("請確認storybord上有設定customcell")
	   }
		let item = busStopsShow[indexPath.row]
//		let direction = self.nowDirection
		let timeItem = stopArrivalTime(stopID: item.stopID)
		let busItemArr = busArrivalData(stopID: item.stopID)
		let busActionArr = busItemArr.filter { $0.dutyStatus != 2 }
		selfcell.busStopNameLabel?.text = item.stopName.zhTw
		let arrTime = timeItem?.estimateTime
		var arrTimeStr = ""
		if timeItem != nil {
			if arrTime != nil {
				arrTimeStr = secToMin(arrTime!)
			} else {
				arrTimeStr = "交管不停"
			}
			if timeItem?.stopStatus == 0 {
				if arrTime! < 60 {
					selfcell.busStopTimeLabel.backgroundColor = UIColor(named: "MainRed")
					selfcell.busStopTimeLabel?.text = "即將進站"
				} else {
					selfcell.busStopTimeLabel.backgroundColor = UIColor(named: "MainBlue")
					selfcell.busStopTimeLabel?.text = "\(arrTimeStr) 分"
					
				}
			} else if timeItem?.stopStatus == 2 {
				selfcell.busStopTimeLabel.backgroundColor = .lightGray
				selfcell.busStopTimeLabel?.text = "交管不停"
			} else {
				selfcell.busStopTimeLabel.backgroundColor = .lightGray
				if arrTime != nil {
					selfcell.busStopTimeLabel?.text = "\(arrTimeStr)分後發車"
				}
				selfcell.busStopTimeLabel?.text = "尚未發車"
			}
		} else {
			selfcell.busStopTimeLabel.backgroundColor = .lightGray
			selfcell.busStopTimeLabel?.text = "尚未發車"
		}
		selfcell.busStopTimeLabel.layer.cornerRadius = 5
		selfcell.busStopTimeLabel.clipsToBounds = true
		selfcell.busNumLabel?.text = ""
		
		if busActionArr.count == 1 {
			let busItem = busActionArr.first
			if busItem?.dutyStatus != 2{
				selfcell.busNumLabel?.text! += "\(busItem?.plateNumb ?? "")"
			}
		} else if busActionArr.count > 1 {
			for (index, busItem) in busActionArr.enumerated() {
				selfcell.busNumLabel?.text! += "\(busItem.plateNumb)"
				if index != busActionArr.count - 1 {
					selfcell.busNumLabel?.text! += "\n"
				}
			}
		}
		return selfcell
	}
	
	func queryStops(of busNum: String, at city: String){
		BusCommunicator.shared.getBusStopOfRoute(busNum, city: city) { result, error in
			if let error = error {
				self.showAlert(message: "error: \(error)")
				return
			}
			
			guard let data = result else {
				self.showAlert(message: "站牌連線異常")
				return
			}
			self.busStopsResult = data
			let direction0Routes = data.filter { $0.direction == 0 }
			let direction1Routes = data.filter { $0.direction == 1 }
//			self.busStopsResultTo = data[0]
//			self.busStopsResultBack = data[1]
			self.busStopsTo = direction0Routes.count != 0 ? direction0Routes[0].stops : []
			//有可能只有單程要對這邊做處理
			self.busStopsBack = direction1Routes.count != 0 ? direction1Routes[0].stops : []
			self.busStopsShow = self.busStopsTo
			self.nowDirection = 0
			if self.busStopsBack.count == 0 {
				self.segmentRouteChange.isHidden = true
				self.oneRouteLabel.isHidden = false
				self.oneRouteLabel.text = "\(self.toEndStopName) - \(self.backEndStopName)"
			}
			self.busRouteStopsTable.reloadData()
			
		}
	}
	
	func queryStopTimeOfArrival(of busNum: String, at city: String){
		BusCommunicator.shared.getBusTimeOfArrival(busNum, city: city) { result, error in
			if let error = error {
				self.showAlert(message: "error: \(error)")
				return
			}
			guard let data = result else {
				self.showAlert(message: "站牌連線異常")
				return
			}
//			print("N2: \(data)")
			self.busStopsToTime = data.filter { $0.direction == 0 }
			self.busStopsBackTime = data.filter { $0.direction == 1 }
//			print("busStopsToTime: \(self.busStopsToTime)")
//			print("busStopsBackTime: \(self.busStopsBackTime)")
			self.busRouteStopsTable.reloadData()
		}
	}
	
	func stopArrivalTime(stopID: String) -> StopOfTimeArrival? {
//		var arrivalTime: Int?
		var findArray = [StopOfTimeArrival]()
		var resultStop: StopOfTimeArrival?
		let direction = self.nowDirection
		switch direction {
		case 0:
			findArray = self.busStopsToTime
			break
		case 1:
			findArray = self.busStopsBackTime
			break
		default: break
		}
		let filteredObjects = findArray.filter { $0.stopID	 == stopID }
		resultStop = filteredObjects.first
		return resultStop
	}
	
	func queryBusArrrivalTime(of busNum: String, at city: String){
		BusCommunicator.shared.getBusTimeOfArrivalA1(busNum, city: city) { result, error in
			if let error = error {
				self.showAlert(message: "error: \(error)")
				return
			}
			guard let data = result else {
				self.showAlert(message: "站牌連線異常")
				return
			}
//			print("A1: \(data)")
			self.busArrToTime = data.filter { $0.direction == 0 }
			self.busArrBackTime = data.filter { $0.direction == 1 }
//			print("busArrToTime: \(self.busArrToTime)")
//			print("busArrBackTime: \(self.busArrBackTime)")
			self.busRouteStopsTable.reloadData()
		}
	}
	
	func busArrivalData(stopID: String) -> [BusArrivalData] {
//		var arrivalTime: Int?
		var findArray = [BusArrivalData]()
//		var resultBus: BusArrivalData?
		let direction = self.nowDirection
		switch direction {
		case 0:
			findArray = self.busArrToTime
			break
		case 1:
			findArray = self.busArrBackTime
			break
		default: break
		}
		let filteredObjects = findArray.filter { $0.stopID	 == stopID }
//		print("filteredObjects \(filteredObjects)")
//		resultBus = filteredObjects.first
//		print("resultBus \(resultBus)")
		return filteredObjects
	}
	
	func secToMin(_ sec: Int) -> String{
		var min = 0
		min = sec / 60
		return "\(min)"
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
