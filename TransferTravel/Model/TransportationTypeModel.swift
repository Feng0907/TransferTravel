//
//  TransportationTypeModel.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/12.
//

import Foundation
import UIKit

struct TransportationItem {
	
	var name: String
	var iconOn: UIImage
	var iconOff: UIImage
	var state: Bool
	var type: type
	
	enum type: Int{
		case walk = 0
		case bicycle = 1
		case motorcycle = 2
		case car = 3
	}
	
}

//	func setBtn(btn: UIButton, type: TransportationItem.type){
//		var item = TransportationItem(type: type)
//		switch type {
//		case .walk:
//			item.name = "步行"
//			item.iconOn = UIImage.init(named: "walk_on_transBtnIcon.png")!
//			item.iconOff = UIImage.init(named: "walk_off_transBtnIcon.png")!
//			break
//		case .bicycle:
//			item.name = "自行車"
//			item.iconOn = UIImage.init(named: "bicycle_on_transBtnIcon.png")!
//			item.iconOff = UIImage.init(named: "bicycle_off_transBtnIcon.png")!
//			break
//		case .motorcycle:
//			item.name = "機車"
//			item.iconOn = UIImage.init(named: "motorcycle_on_transBtnIcon.png")!
//			item.iconOff = UIImage.init(named: "motorcycle_off_transBtnIcon.png")!
//			break
//		case .car:
//			item.name = "汽車"
//			item.iconOn = UIImage.init(named: "car_on_transBtnIcon.png")!
//			item.iconOff = UIImage.init(named: "car_off_transBtnIcon.png")!
//			break
//		}
//		btn.imageView?.contentMode = .scaleAspectFit
//		btn.setImage(item.iconOff, for: .normal)
//		btn.setImage(item.iconOn, for: .selected)
////		btn.addTarget(self, action: #selector(doSomething), for: .touchDown)
////		btn.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
////		func btnSetting(){
////
////		}
//	}

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

//class TransportationBtn: UIButton {
////	var item: TransportationItem
////	let icon: UIImage
////	let text: UILabel
//	let btn = UIButton()
//
////	let btnWalk: UIButton?
////	let btnBicycle: UIButton?
////	let btnMotorcycle: UIButton?
////	let btnCar: UIButton?
//
//
//	init(btn: UIButton){
//		self.btn = btn
////		self.item = item
////		self.icon = item.iconOn ?? item.iconOff!
////		self.text = UILabel()
//		super.init(frame: .zero)
//		setBtn(btn: btn)
//
//	}
//
//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//
//	func setBtn(btn: UIButton){
//		var item: TransportationItem?
//		switch btn {
//		case btnWalk:
//			item?.name = "步行"
//			item?.iconOn = UIImage.init(named: "walk_on_transBtnIcon.png")!
//			item?.iconOff = UIImage.init(named: "walk_off_transBtnIcon.png")!
//			item?.state = btn.isSelected
//			break
//		case btnBicycle:
//			item?.name = "自行車"
//			item?.iconOn = UIImage.init(named: "bicycle_on_transBtnIcon.png")!
//			item?.iconOff = UIImage.init(named: "bicycle_off_transBtnIcon.png")!
//			item?.state = btn.isSelected
//			break
//		case btnMotorcycle:
//			item?.name = "機車"
//			item?.iconOn = UIImage.init(named: "motorcycle_on_transBtnIcon.png")!
//			item?.iconOff = UIImage.init(named: "motorcycle_off_transBtnIcon.png")!
//			item?.state = btn.isSelected
//			break
//		case btnCar:
//			item?.name = "汽車"
//			item?.iconOn = UIImage.init(named: "car_on_transBtnIcon.png")!
//			item?.iconOff = UIImage.init(named: "car_off_transBtnIcon.png")!
//			item?.state = btn.isSelected
//			break
//		default:
//			return
//		}
////		btn.titleLabel?.text = item.name
//		btn.imageView?.contentMode = .scaleAspectFit
//		btn.setImage(item?.iconOff, for: .normal)
//		btn.setImage(item?.iconOn, for: .selected)
//		print(btn.titleLabel?.text)
//		print(btn.isSelected)
////		btn.addTarget(self, action: #selector(doSomething), for: .touchDown)
////		btn.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
////		func btnSetting(){
////
////		}
//	}
	
//	func setBtn(btn: UIButton, type: TransportationItem.type){
//		var item = TransportationItem(type: type)
//		item.state = btn.isSelected
//		switch type {
//		case .walk:
//			item.name = "步行"
//			item.iconOn = UIImage.init(named: "walk_on_transBtnIcon.png")!
//			item.iconOff = UIImage.init(named: "walk_off_transBtnIcon.png")!
//			break
//		case .bicycle:
//			item.name = "自行車"
//			item.iconOn = UIImage.init(named: "bicycle_on_transBtnIcon.png")!
//			item.iconOff = UIImage.init(named: "bicycle_off_transBtnIcon.png")!
//			break
//		case .motorcycle:
//			item.name = "機車"
//			item.iconOn = UIImage.init(named: "motorcycle_on_transBtnIcon.png")!
//			item.iconOff = UIImage.init(named: "motorcycle_off_transBtnIcon.png")!
//			break
//		case .car:
//			item.name = "汽車"
//			item.iconOn = UIImage.init(named: "car_on_transBtnIcon.png")!
//			item.iconOff = UIImage.init(named: "car_off_transBtnIcon.png")!
//			break
//		}
////		btn.titleLabel?.text = item.name
//		btn.imageView?.contentMode = .scaleAspectFit
//		btn.setImage(item.iconOff, for: .normal)
//		btn.setImage(item.iconOn, for: .selected)
//		print(btn.titleLabel?.text)
//		print(btn.isSelected)
////		btn.addTarget(self, action: #selector(doSomething), for: .touchDown)
////		btn.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
////		func btnSetting(){
////
////		}
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



//}
