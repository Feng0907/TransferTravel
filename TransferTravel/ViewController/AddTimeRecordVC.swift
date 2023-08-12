//
//  AddTimeRecordVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/8.
//

import UIKit
import CoreData

class AddTimeRecordVC: UIViewController {

//	@IBOutlet weak var typeBtns: Transportation!
	
	@IBOutlet weak var btnWalk: UIButton!
	@IBOutlet weak var btnBicycle: UIButton!
	@IBOutlet weak var btnMotorcycle: UIButton!
	@IBOutlet weak var btnCar: UIButton!
	
//	var recordInfo: TimeRecordItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		setBtn(btn: btnWalk, type: .walk)
		setBtn(btn: btnBicycle, type: .bicycle)
		setBtn(btn: btnMotorcycle, type: .motorcycle)
		setBtn(btn: btnCar, type: .car)
    }
	
	func setBtn(btn: UIButton, type: TransportationItem.type){
		var item = TransportationItem(type: type)
		switch type {
		case .walk:
			item.name = "步行"
			item.iconOn = UIImage.init(named: "walk_on_transBtnIcon.png")!
			item.iconOff = UIImage.init(named: "walk_off_transBtnIcon.png")!
			break
		case .bicycle:
			item.name = "自行車"
			item.iconOn = UIImage.init(named: "bicycle_on_transBtnIcon.png")!
			item.iconOff = UIImage.init(named: "bicycle_off_transBtnIcon.png")!
			break
		case .motorcycle:
			item.name = "機車"
			item.iconOn = UIImage.init(named: "motorcycle_on_transBtnIcon.png")!
			item.iconOff = UIImage.init(named: "motorcycle_off_transBtnIcon.png")!
			break
		case .car:
			item.name = "汽車"
			item.iconOn = UIImage.init(named: "car_on_transBtnIcon.png")!
			item.iconOff = UIImage.init(named: "car_off_transBtnIcon.png")!
			break
		}
		btn.imageView?.contentMode = .scaleAspectFit
		btn.setImage(item.iconOff, for: .normal)
		btn.setImage(item.iconOn, for: .selected)
		
		btn.imageView?.clipsToBounds = true
		btn.imageView?.frame.size = CGSize(width: 50, height: 50)
		
	}
	
	
	@IBAction func transTypeBtns(_ sender: UIButton) {
		switch sender {
		case btnWalk:
			btnWalk.isSelected = true
			btnBicycle.isSelected = false
			btnMotorcycle.isSelected = false
			btnCar.isSelected = false
			break
		case btnBicycle:
			btnWalk.isSelected = false
			btnBicycle.isSelected = true
			btnMotorcycle.isSelected = false
			btnCar.isSelected = false
			break
		case btnMotorcycle:
			btnWalk.isSelected = false
			btnBicycle.isSelected = false
			btnMotorcycle.isSelected = true
			btnCar.isSelected = false
			break
		case btnCar:
			btnWalk.isSelected = false
			btnBicycle.isSelected = false
			btnMotorcycle.isSelected = false
			btnCar.isSelected = true
			break
		default:
			return
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
