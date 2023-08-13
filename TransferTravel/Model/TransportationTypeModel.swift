//
//  TransportationTypeModel.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/12.
//

import Foundation
import UIKit

struct TransportationItem {
	
	var name: String?
	var iconOn: UIImage?
	var iconOff: UIImage?
	var state: Bool?
	var type: type
	
	enum type: Int{
		case walk = 0
		case bicycle = 1
		case motorcycle = 2
		case car = 3
	}
}

//class Transportation: UIStackView {
//
//	var btns = [TransportationItem]()
//	let paddingX: CGFloat = 20.0
//	var lastViewY: CGFloat = 0
//
//
//	init(){
//		super.init(frame: .zero)
//
//
//	}
//
//	required init(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//	for i in 0...3{
//		guard let type = TransportationItem.type(rawValue: i) else {
//			print("錯誤的按鈕")
//			return
//
//		}
//		let item = TransportationItem(type: type)
//		let newitem = TransportationBtn(item: item, itemType: type)
////			let btnInfo = newitem.setBtn(itemType: type)
////			let btn: UIButton
//		print("正確的按鈕？")
//		addSubview(newitem)
//		btns.append(item)
//	}
	
//}

//fileprivate class TransportationBtn: UIButton {
//	var item: TransportationItem
//	let startAtY: CGFloat
//	let fullWidth: CGFloat
////	var itemType: TransportationItem.type
//	let icon: UIImage
//	let text: UILabel
//
//	let sidePaddingRate: CGFloat = 0.02     // 2% 與邊界之間的距離
//	let contentMargin: CGFloat = 10.0 	// content圖和文  contentMargin 圖/文字與泡泡邊界的距離
//	let bubbleTailWidth: CGFloat = 10.0
//	let textFontSize: CGFloat = 16.0
//
//	init(item: TransportationItem, startAtY: CGFloat, fullWidth: CGFloat){
//		self.item = item
//		self.startAtY = startAtY
//		self.fullWidth = fullWidth
//		self.icon = item.iconOn ?? item.iconOff!
//		self.text = UILabel()
//		super.init(frame: .zero)
//		self.titleLabel?.text = item.name
//		self.frame = calculateTempFrame()
//		setBtn()
//		prepareBtn()
//
//	}
//
//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//
//	//計算一個暫時的XY寬高
//	private func calculateTempFrame() -> CGRect {
//		//先假設一個最大寬 在看內容物決定要縮多小
//		let sidePadding = fullWidth * sidePaddingRate
//		let maxWidth = fullWidth/4 - 10
//
//		return CGRect(x: 0, y: 0, width: maxWidth, height: 10)
//	}
//	private func setBtn(){
//		let itemType = item.type
//		switch itemType {
//		case .walk:
//			item.name = "步行"
//			item.iconOn = UIImage(named: "walk_ontransBtnIcon.png")!
//			item.iconOff = UIImage(named: "walk_offtransBtnIcon.png")!
//			break
//		case .bicycle:
//			item.name = "自行車"
//			item.iconOn = UIImage(named: "bicycle_ontransBtnIcon.png")!
//			item.iconOff = UIImage(named: "bicycle_offtransBtnIcon.png")!
//			break
//		case .motorcycle:
//			item.name = "機車"
//			item.iconOn = UIImage(named: "motorcycle_ontransBtnIcon.png")!
//			item.iconOff = UIImage(named: "motorcycle_offtransBtnIcon.png")!
//			break
//		case .car:
//			item.name = "汽車"
//			item.iconOn = UIImage(named: "car_ontransBtnIcon.png")!
//			item.iconOff = UIImage(named: "car_offtransBtnIcon.png")!
//			break
//		}
//
//	}
//	private func prepareBtn() -> UIButton{
//		let btn = UIButton(type: .custom)
//		btn.titleLabel?.text = self.item.name
//		btn.setImage(self.item.iconOff, for: .normal)
//		btn.setImage(self.item.iconOn, for: .selected)
//		self.addSubview(btn)
//		return btn
//	}
//
//
//
//}
