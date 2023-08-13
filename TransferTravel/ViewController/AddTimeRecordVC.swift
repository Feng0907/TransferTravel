//
//  AddTimeRecordVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/8.
//

import UIKit
import CoreData

class AddTimeRecordVC: UIViewController {

	@IBOutlet weak var startPoint: UITextField!
	@IBOutlet weak var endPoint: UITextField!
	
	@IBOutlet weak var timingLabel: UILabel!
	
	@IBOutlet weak var btnWalk: UIButton!
	@IBOutlet weak var btnBicycle: UIButton!
	@IBOutlet weak var btnMotorcycle: UIButton!
	@IBOutlet weak var btnCar: UIButton!
	
	@IBOutlet weak var startBtn: UIButton!
	@IBOutlet weak var pauseBtn: UIButton!
	@IBOutlet weak var stopBtn: UIButton!
	
	var timer = Timer()
	var startStatus : Bool = true
	var millsecond = 0
	var millsec = 0
	var sec = 0
	var min = 0
	var hour = 0
	
	//	var recordInfo: TimeRecordItem?
	
	@objc
	func timerAction(){
		if startStatus == false {
			millsecond += 1
			millsec = millsecond % 100
			sec = (millsecond / 100) % 60
			min = millsecond / 6000
			hour = millsecond / 360000  //累加
			let showmillsec = millsec > 9 ? "\(millsec)" : "0\(millsec)"
			let showsec = sec > 9 ? "\(sec)" : "0\(sec)"
			let showmin = min > 9 ? "\(min)" : "0\(min)"
			let showhour = hour > 9 ? "\(hour)" : "0\(hour)"
			self.timingLabel.text = "\(showhour):\(showmin):\(showsec):\(showmillsec)"
			print(self.timingLabel.text!)
		}
	}
	


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		setBtn(btn: btnWalk, type: .walk)
		setBtn(btn: btnBicycle, type: .bicycle)
		setBtn(btn: btnMotorcycle, type: .motorcycle)
		setBtn(btn: btnCar, type: .car)
		self.timingLabel.text = "00:00:00:00"
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		if startStatus == false{
			timer.invalidate()
			print("要離開畫面啦")
			startStatus = true
		}
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
//		btn.addTarget(self, action: #selector(doSomething), for: .touchDown)
//		btn.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
		func btnSetting(){
			
		}
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
	
	@IBAction func timerStartBtnPressed(_ sender: Any) {
		startStatus = false  //這邊代表的是 ”Start“ Button 是不是還存在於畫面上，可以用它來將之後的其他功能做判斷依據
		startBtn.isHidden = true
		pauseBtn.isHidden = false
		stopBtn.isHidden  = false
//		reset_button.isHidden = true
		timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
		RunLoop.current.add(timer, forMode: .common)  //切換線程，避免滑動 TabelView 的時候， Timer 會停止運作
	}
	
	@IBAction func pauseBtnPressed(_ sender: Any) {
		if startStatus == false {
			startStatus = true
			pauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
			timer.invalidate()
			print("暫停啦")
		}else{
			startStatus = false
			pauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
			timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
			RunLoop.current.add(timer, forMode: .common)
			print("繼續啦")
		}
	}
	
	@IBAction func stopBtnPressed(_ sender: Any) {
		

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
