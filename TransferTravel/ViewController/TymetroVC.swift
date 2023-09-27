//
//  TymetroVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/26.
//

import UIKit

class TymetroVC: UIViewController {

	@IBOutlet weak var startSelectBtn: UIButton!
//	@IBOutlet weak var StartMenu: UIMenu!
	
	//
	// 1.需要來回的站點資料
	// 2.把他們變成起點終點的清單按鈕
	// 3.在更改起點終點時秀出時刻表（分直達車與普通車）
	// 4.抓取離現在最近時刻的班次並把在這之前的隱藏
	// 設定一個指定時間的時鐘（預設為目前時間）
	// 5.時刻表倒數定時重整資訊
	
	//1.站到站行駛時間
	//https://tdx.transportdata.tw/api/basic/v2/Rail/Metro/S2STravelTime/TYMC
	
	//2.班距
	//https://tdx.transportdata.tw/api/basic/v2/Rail/Metro/Frequency/TYMC
	
	//3.每站時刻表
	//https://tdx.transportdata.tw/api/basic/v2/Rail/Metro/StationTimeTable/TYMC?%24filter=StationID%20eq%20%27A3%27&%24format=JSON
	//StationID eq 'A3'
	
	//4.票價
	//https://tdx.transportdata.tw/api/basic/v2/Rail/Metro/ODFare/TYMC

	override func viewDidLoad() {
        super.viewDidLoad()
//		let button = UIButton(type: .system)
//		button.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
//		view.addSubview(button)
		startSelectBtn.showsMenuAsPrimaryAction = true
		startSelectBtn.changesSelectionAsPrimaryAction = true
		startSelectBtn.menu = UIMenu(children: [
			UIAction(title: "統一7-ELEVEn獅隊", state: .on, handler: { action in
				print("統一7-ELEVEn獅隊")
			}),
			UIAction(title: "中信兄弟隊", handler: { action in
				print("中信兄弟隊")
			}),
			UIAction(title: "樂天桃猿隊", handler: { action in
				print("樂天桃猿隊")
			}),
			UIAction(title: "富邦悍將隊", handler: { action in
				print("富邦悍將隊")
			}),
			UIAction(title: "味全龍隊", handler: { action in
				print("味全龍隊")
			})
		])

        // Do any additional setup after loading the view.
    }
    
//	@IBAction func menuAction(_ sender: Any) {
//
//	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
