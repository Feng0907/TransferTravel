//
//  TymetroVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/26.
//

import UIKit

class TymetroVC: UIViewController {

	@IBOutlet weak var startSelectBtn: UIButton!
	@IBOutlet weak var endSelectBtn: UIButton!
	@IBOutlet weak var timeListTableView: UITableView!
	
	@IBOutlet weak var timeLabel: UILabel!
	
	var selectMenu = [UIMenuElement]()
	var selectStartStationID = "A1"
	var selectEndStationID = "A1"
	
	
//	@IBOutlet weak var StartMenu: UIMenu!

	// 1.需要來回的站點資料
	// 2.把他們變成起點終點的清單按鈕
	// 3.在更改起點終點時秀出時刻表（分直達車與普通車）
	// 4.抓取離現在最近時刻的班次並把在這之前的隱藏
	// 設定一個指定時間的時鐘（預設為目前時間）
	// 5.時刻表倒數定時重整資訊?

	override func viewDidLoad() {
        super.viewDidLoad()
		let now = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		let timeString = dateFormatter.string(from: now)
		self.timeLabel.text = timeString
		settingSelectMenu()
		startSelectBtn.showsMenuAsPrimaryAction = true
		startSelectBtn.changesSelectionAsPrimaryAction = true
		endSelectBtn.showsMenuAsPrimaryAction = true
		endSelectBtn.changesSelectionAsPrimaryAction = true
		

        // Do any additional setup after loading the view.
    }
    
//	@IBAction
//	func menuAction(_ sender: Any) {
//
//	}
	
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
	
	@IBAction func checkBtnPressed(_ sender: Any) {
		if selectStartStationID == selectEndStationID {
			showAlert(message: "起點站和終點站需不同")
			return
		}
		TymetroCommunicator.shared.getStationTimeTable(from: selectStartStationID) { result, error in
			if let error = error {
				print("getBusRouteInfo Error: \(error)")
				return
			}
			guard let data = result else {
				print("Tymetro result error")
				return
			}
			
			print(data)
		}
		TymetroCommunicator.shared.getS2STravelTime(from: selectStartStationID, to: selectEndStationID) { result, error in
			if let error = error {
				print("getBusRouteInfo Error: \(error)")
				return
			}
			guard let data = result else {
				print("Tymetro result error")
				return
			}
			
			print(data.count)
		}
		
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
