//
//  TymetroVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/26.
//

import UIKit
import KRProgressHUD

class TymetroVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
	@IBOutlet weak var startTagLabel: UILabel!
	@IBOutlet weak var endTagLabel: UILabel!
	
	@IBOutlet weak var startSelectBtn: UIButton!
	@IBOutlet weak var endSelectBtn: UIButton!
	@IBOutlet weak var timeListTableView: UITableView!
	
	@IBOutlet weak var timeLabel: UILabel!
	
	@IBOutlet weak var sendBtn: UIButton!
	var selectMenu = [UIMenuElement]()
	var selectStartStationID = "A1"
	var selectEndStationID = "A1"
	var direction = 0
	
//	var commondayArr = [StationTravelTimeTable]()
//	var holidayArr = [StationTravelTimeTable]()
	var timeTableArr = [StationTravelTimeTable]()
	var directTimeTable = [Timetable]()//直達車
	var commonTimeTable = [Timetable]() //普通車
	var directTravelTime: TravelTime?//直達車
	var commonTravelTime: TravelTime? //普通車
	var directTimeItem = TymetroTimeItem() //直達車
	var commonTimeItem = TymetroTimeItem() //普通車
	var totalTimeItemArr = [Timetable]()
	var holidayTag = 0
	
//	@IBOutlet weak var StartMenu: UIMenu!

	// 1.需要來回的站點資料
	// 2.把他們變成起點終點的清單按鈕
	// 3.在更改起點終點時秀出時刻表（分直達車與普通車）
	// 4.抓取離現在最近時刻的班次並把在這之前的隱藏
	// 設定一個指定時間的時鐘（預設為目前時間）
	// 5.時刻表倒數定時重整資訊?

	override func viewDidLoad() {
        super.viewDidLoad()
		self.sendBtn.layer.cornerRadius = 5
		self.sendBtn.clipsToBounds = true
		startTagLabel.layer.cornerRadius = 5
		startTagLabel.clipsToBounds = true
		endTagLabel.layer.cornerRadius = 5
		endTagLabel.clipsToBounds = true
		let now = Date()
		let dateFormatter = DateFormatter()
		let dateFormatterWeek = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		dateFormatterWeek.dateFormat = "EEEE"
		let dayOfWeek = dateFormatterWeek.string(from: now)
		if dayOfWeek == "Sunday" || dayOfWeek == "Saturday" {
			self.holidayTag = 1
		} else {
			self.holidayTag = 0
		}
		let timeString = dateFormatter.string(from: now)
		self.timeLabel.text = timeString
		settingSelectMenu()
		startSelectBtn.showsMenuAsPrimaryAction = true
		startSelectBtn.changesSelectionAsPrimaryAction = true
		endSelectBtn.showsMenuAsPrimaryAction = true
		endSelectBtn.changesSelectionAsPrimaryAction = true
		self.timeListTableView.dataSource = self
		self.timeListTableView.delegate = self
        // Do any additional setup after loading the view.
    }
	
	func settingSelectMenu(){
		
		TymetroCommunicator.shared.getTymetroStation { result, error in
			if let error = error {
				print("getBusRouteInfo Error: \(error)")
				return
			}
			guard let data = result,
				let stationInfos = data.first?.stations else {
				print("Tymetro result error")
				return
			}
			for station in stationInfos{
				let selectItem = UIAction(title: station.stationID + " " + station.stationName.zhTw, subtitle: station.stationID, state: .off, handler: self.selectedAction)
				self.selectMenu.append(selectItem)
			}
			self.startSelectBtn.menu = UIMenu(children: self.selectMenu)
			self.endSelectBtn.menu = UIMenu(children: self.selectMenu)
		}
	}
	
	func selectedAction(action: UIAction){
		guard let presentItem = action.presentationSourceItem,
			  let presentItemBtn = presentItem as? UIButton,
		let subtitle = action.subtitle else {
			return
		}
		if presentItemBtn == self.startSelectBtn {
			selectStartStationID = subtitle
		} else if presentItemBtn == self.endSelectBtn {
			selectEndStationID = subtitle
		}
	}
	
	@IBAction func returnTimeLabel(_ sender: Any) {
		let now = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		let timeString = dateFormatter.string(from: now)
		self.timeLabel.text = timeString
	}
	
	@IBAction func checkBtnPressed(_ sender: Any) {
		let group = DispatchGroup()
		self.totalTimeItemArr = []
		if let startStationSeq = Int(selectStartStationID.dropFirst()), let endStationSeq = Int(selectEndStationID.dropFirst()) {
			if startStationSeq == endStationSeq{
				showAlert(message: "起點站和終點站需不同")
				return
			} else if startStationSeq < endStationSeq{
				direction = 0
			} else if startStationSeq > endStationSeq{
				direction = 1
			}
		}
		group.enter()
		TymetroCommunicator.shared.getStationTimeTable(from: selectStartStationID) { result, error in
			KRProgressHUD.show()
			if let error = error {
				print("getBusRouteInfo Error: \(error)")
				return
			}
			guard let data = result else {
				print("Tymetro TimeTable error")
				return
			}
			
			let directionData = data.filter { $0.direction == self.direction }
			if self.holidayTag == 0 {
				self.timeTableArr = directionData.filter { $0.serviceDay.serviceTag == "平日" }
//				print("平日：\(self.timeTableArr)")
			} else {
				self.timeTableArr = directionData.filter { $0.serviceDay.serviceTag == "假日" }
//				print("假日：\(self.timeTableArr)")
			}
			let directArr = self.timeTableArr.filter { $0.routeID == "A-2" }
			let commonArr = self.timeTableArr.filter { $0.routeID == "A-1" }
			self.directTimeTable = directArr.first?.timetables ?? []
			self.commonTimeTable = commonArr.first?.timetables ?? []
//			self.timeListTableView.reloadData()
//			print("普通時間表 \(self.commonTimeTable)")
//			print("直達時間表 \(self.directTimeTable)")
//			if self.selectEndStationID != "A1" || "A3"{
//				self.directTimeTable = []
//			}
			group.leave()
		}
		group.enter()
		TymetroCommunicator.shared.getS2STravelTime(from: selectStartStationID, to: selectEndStationID) { result, error in
			KRProgressHUD.show()
			if let error = error {
				print("getBusRouteInfo Error: \(error)")
				return
			}
			guard let data = result else {
				print("Tymetro TravelTime error")
				return
			}
			if data.count == 1 {
				self.directTimeTable = []
			}
			let commonTravelTimes = data.filter { $0.trainType == 1 }
			let directTravelTimes = data.filter { $0.trainType == 2 }
			let directTravelTimeArr = directTravelTimes.first?.travelTimes ?? []
			let commonTravelTimeArr = commonTravelTimes.first?.travelTimes ?? []
			let directTravelTimesfilter = directTravelTimeArr.filter { object in
				return object.fromStationID == self.selectStartStationID && object.toStationID == self.selectEndStationID }
			let commonTravelTimesfilter = commonTravelTimeArr.filter { object in
				return object.fromStationID == self.selectStartStationID && object.toStationID == self.selectEndStationID }
			self.directTravelTime = directTravelTimesfilter.first
			self.commonTravelTime = commonTravelTimesfilter.first
			group.leave()
		}
		
		
		group.notify(queue: DispatchQueue.global()) { [self] in
			if self.directTimeTable.count == 0 {
				self.totalTimeItemArr = self.commonTimeTable.filter { $0.trainType == 1 }
			} else {
				let combinedArray = self.commonTimeTable + self.directTimeTable
				self.totalTimeItemArr = combinedArray.sorted { (timetable1, timetable2) in
					return (timetable1.arrivalTime) < (timetable2.arrivalTime)
				}
			}
			DispatchQueue.main.async {
				KRProgressHUD.dismiss()
				self.timeListTableView.reloadData()
			}
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.totalTimeItemArr.count

	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		print("普通時間表 \(self.commonTimeTable)")
//		print("直達時間表 \(self.directTimeTable)")
		tableView.separatorStyle = .singleLine
		let commonItem = self.totalTimeItemArr[indexPath.row]
		guard let selfcell = tableView.dequeueReusableCell(withIdentifier: "TymetroTimeTableCell", for: indexPath) as? TymetroTimeTVCell else{
			fatalError("請確認storybord上有設定customcell")
		}
		
//		if self.directTimeTable.count == 0 {
//			totalTimeItemArr = self.commonTimeTable.filter { $0.trainType == 1 }
//		}else{
//			totalTimeItemArr = zipTimeArray(self.commonTimeTable, self.directTimeTable)
//		}
		
		selfcell.routeTypeLabel.layer.cornerRadius = 5
		selfcell.routeTypeLabel.clipsToBounds = true
		selfcell.cellTimeLabel.clipsToBounds = true
		selfcell.cellTimeLabel.layer.cornerRadius = 5
		selfcell.cellTimeLabel.backgroundColor = UIColor(named: "DarkGrayColor")
		var commonTimeString = ""
		var commonArrivalTime = ""
		if commonItem.trainType == 1 {
			selfcell.routeTypeLabel.text = "普通"
			selfcell.routeTypeLabel.backgroundColor = UIColor(named: "MainBlue")
			if let commonTime = self.commonTravelTime?.runTime{
				commonArrivalTime = arrTimeChange(departure: commonItem.departureTime, travelTime: commonTime) ?? ""
				commonTimeString = String(commonTime / 60) + "分鐘"
			}
			print(commonItem)
		} else if commonItem.trainType == 2 {
			selfcell.routeTypeLabel.text = "直達"
			selfcell.routeTypeLabel.backgroundColor = UIColor(named: "AirportMRTP1")
			if let directTime = self.directTravelTime?.runTime{
				commonArrivalTime = arrTimeChange(departure: commonItem.departureTime, travelTime: directTime) ?? ""
				commonTimeString = String(directTime / 60) + "分鐘"
			}
			print(commonItem)
		}
		
		let nowTimeString = self.timeLabel.text ?? "00:00"
		let nowTime = timeStringToSeconds(nowTimeString)
		let arrTime = timeStringToSeconds(commonItem.departureTime)
		if timeStringToSeconds("01:00") >= nowTime || timeStringToSeconds("05:00") < nowTime {
			if nowTime < arrTime {
				selfcell.cellTimeLabel.backgroundColor = UIColor(named: "AirportMRTB")
				selfcell.cellTimeLabel.text = timeIntervalToString(arrTime - nowTime)
				let timeLag = arrTime - nowTime
				if timeLag <= timeStringToSeconds("01:00") {
					selfcell.cellTimeLabel.backgroundColor = UIColor(named: "DarkGrayColor")
				}
			} else {
				selfcell.cellTimeLabel.backgroundColor = UIColor(named: "DarkGrayColor")
				selfcell.cellTimeLabel.text = "離站"
			}
		}
		
		selfcell.departureTimeLabel.text = commonItem.departureTime
		selfcell.arrivalTimeLabel.text = commonArrivalTime
		selfcell.travelTimeLabel.text = commonTimeString
		return selfcell
	}
	
	
	
	func arrTimeChange(departure timeString: String,travelTime secondsToAdd: Int) -> String?{
		let timeFormatter = DateFormatter()
			timeFormatter.dateFormat = "HH:mm"
		if let date = timeFormatter.date(from: timeString) {
			let newDate = date.addingTimeInterval(TimeInterval(secondsToAdd))
			return timeFormatter.string(from: newDate)
		}
		return nil
	}
	func timeStringToSeconds(_ timeString: String) -> TimeInterval {
		let timeFormatter = DateFormatter()
		timeFormatter.dateFormat = "HH:mm"
		if let date = timeFormatter.date(from: timeString) {
			return date.timeIntervalSinceReferenceDate
		}
		let timeComponents = timeString.components(separatedBy: ":")
		guard timeComponents.count == 2,
			  let hours = Int(timeComponents[0]),
			  let minutes = Int(timeComponents[1]) else {
			return 0.0
		}
		let totalHours = hours + 24
		let timeInterval = TimeInterval(totalHours * 3600 + minutes * 60)

		return timeInterval
	}
	
	
	func timeIntervalToString(_ interval: TimeInterval) -> String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = interval < 3600 ? [.minute] : [.hour, .minute]
		formatter.unitsStyle = .positional
		formatter.zeroFormattingBehavior = .pad
		var timeString = formatter.string(from: interval) ?? "00:00"
		if interval < 3600 {
			timeString.append("分")
		}
		return timeString
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
