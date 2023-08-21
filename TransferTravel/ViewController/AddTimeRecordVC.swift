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
	
	var routeID: Int64?
	var recordInfo: TimeRecordItem?
	var transType: TimeRecordItem.FromType? = nil
	weak var delegate: AddTimeRecordVCDelegate?
	
	var btnSelected = [false, false, false, false]
	
	var backgroundTask: UIBackgroundTaskIdentifier = .invalid
	var startTime: Date?
	var middleTime: Date?
	var elapsedTime: TimeInterval = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		setBtn(btn: btnWalk)
		setBtn(btn: btnBicycle)
		setBtn(btn: btnMotorcycle)
		setBtn(btn: btnCar)
		self.timingLabel.text = "00:00:00:00"
		self.startPoint.text = self.recordInfo?.startName
		self.endPoint.text = self.recordInfo?.endName
		self.routeID = self.recordInfo?.routeID
		showBtnType(item: self.recordInfo)
		NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
		if self.recordInfo == nil{
			self.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { action in
//				self.dismiss(animated: true)
				self.navigationController?.popViewController(animated: true)
			}))
//			self.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "MainBlue")
//			self.navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "MainBlue")
		}
    }
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
//	override func viewWillDisappear(_ animated: Bool) {
//		if startStatus == false {
//			timer.invalidate()
//			startStatus = true
//		}
//	}
	
	@objc
	func appDidEnterBackground() {
		if startStatus == false {
//			backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
//				UIApplication.shared.endBackgroundTask(self.backgroundTask)
//				self.backgroundTask = .invalid
//			})
			startTime = Date()
		}
	}
	@objc
	func appDidBecomeActive() {
		if let startTime = startTime {
			let sTime = Date().timeIntervalSince(startTime)
			elapsedTime = 0
			elapsedTime += Date().timeIntervalSince(startTime)
			print(elapsedTime)
			self.startTime = nil
			self.middleTime = nil
		}
		updateTimerDisplay()
	}

	func updateTimerDisplay() {
		// 更新計時器顯示，例如格式化時間
		millsecond += Int(elapsedTime) * 100
		elapsedTime = 0
	}
//	func performBackgroundTask() {
//		// 背景任務的執行內容
//		self.millsecond += 1
//		// 結束背景任務
//		UIApplication.shared.endBackgroundTask(backgroundTask)
//		backgroundTask = .invalid
//	}
//
//	func startBackgroundTimer() {
//		timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
//			self.performBackgroundTask()
//		}
//		RunLoop.current.add(timer, forMode: .common)
//	}
	
	func showBtnType(item: TimeRecordItem?){
		let type = item?.type
		switch type {
		case .walk:
			btnWalk.isSelected = true
			break
		case .bicycle:
			btnBicycle.isSelected = true
			break
		case .motorcycle:
			btnMotorcycle.isSelected = true
			break
		case .car:
			btnCar.isSelected = true
			break
		case .none:
			return
		}
	}
	
	//把毫秒換回時間
	func timeConversion(millsecond: Int) -> String{
		millsec = millsecond % 100
		sec = (millsecond / 100) % 60
		min = millsecond / 6000 % 60
		hour = millsecond / 360000  //累加
		let showmillsec = millsec > 9 ? "\(millsec)" : "0\(millsec)"
		let showsec = sec > 9 ? "\(sec)" : "0\(sec)"
		let showmin = min > 9 ? "\(min)" : "0\(min)"
		let showhour = hour > 9 ? "\(hour)" : "0\(hour)"
		let time = "\(showhour):\(showmin):\(showsec):\(showmillsec)"
		return time
	}
	
	@objc
	func timerAction(){
		if startStatus == false {
			millsecond += 1
			self.timingLabel.text = timeConversion(millsecond: millsecond)
		}
	}
	
	func setBtn(btn: UIButton){
		var item = TransportationItem(name: "", iconOn: UIImage(named: "walk_on_transBtnIcon.png")!, iconOff: UIImage(named: "walk_off_transBtnIcon.png")!, state: false, type: .walk)
		switch btn {
		case btnWalk:
			item.type = .walk
			item.name = "步行"
			item.iconOn = UIImage.init(named: "walk_on_transBtnIcon.png")!
			item.iconOff = UIImage.init(named: "walk_off_transBtnIcon.png")!
			item.state = btn.isSelected
			break
		case btnBicycle:
			item.type = .bicycle
			item.name = "自行車"
			item.iconOn = UIImage.init(named: "bicycle_on_transBtnIcon.png")!
			item.iconOff = UIImage.init(named: "bicycle_off_transBtnIcon.png")!
			item.state = btn.isSelected
			break
		case btnMotorcycle:
			item.type = .motorcycle
			item.name = "機車"
			item.iconOn = UIImage.init(named: "motorcycle_on_transBtnIcon.png")!
			item.iconOff = UIImage.init(named: "motorcycle_off_transBtnIcon.png")!
			item.state = btn.isSelected
			break
		case btnCar:
			item.type = .car
			item.name = "汽車"
			item.iconOn = UIImage.init(named: "car_on_transBtnIcon.png")!
			item.iconOff = UIImage.init(named: "car_off_transBtnIcon.png")!
			item.state = btn.isSelected
			break
		default:
			return
		}
		btn.titleLabel?.text = String(item.type.rawValue)
		btn.imageView?.contentMode = .scaleAspectFit
		btn.setImage(item.iconOff, for: .normal)
		btn.setImage(item.iconOn, for: .selected)
	}
	
	
	func btnType(_ walk: Bool, _ bicycle: Bool, _ motorcycle: Bool, _ car: Bool){
		btnWalk.isSelected = walk
		btnBicycle.isSelected = bicycle
		btnMotorcycle.isSelected = motorcycle
		btnCar.isSelected = car
	}
	
	@IBAction func transTypeBtns(_ sender: UIButton) {
		switch sender {
		case btnWalk:
			btnType(true, false, false, false)
			transType = .walk
			break
		case btnBicycle:
			btnType(false, true, false, false)
			transType = .bicycle
			break
		case btnMotorcycle:
			btnType(false, false, true, false)
			transType = .motorcycle
			break
		case btnCar:
			btnType(false, false, false, true)
			transType = .car
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
		timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
		RunLoop.current.add(timer, forMode: .common)  //切換線程，避免滑動 TabelView 的時候， Timer 會停止運作
		let BackButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(alertBack))
		self.navigationItem.leftBarButtonItem = BackButton
	}
	
	@IBAction func pauseBtnPressed(_ sender: Any) {
		if startStatus == false {
			startStatus = true
			pauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
			timer.invalidate()
		}else{
			startStatus = false
			pauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
			timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
			RunLoop.current.add(timer, forMode: .common)
		}
	}
	
	@IBAction func stopBtnPressed(_ sender: Any) {
		startStatus = true
		timer.invalidate()
		alertSave()
	}
	
	@IBAction func saveBtnPressed(_ sender: Any) {
		var typeNum : Int16 = 0
		self.btnSelected = [btnWalk.isSelected, btnBicycle.isSelected, btnMotorcycle.isSelected, btnCar.isSelected]
		for i in 0...3 {
			if self.btnSelected[i] == true{
				typeNum = Int16(i)
			}
		}
		let moc = CoreDataHelper.shared.managedObjectContext()
		let routeID = SendRouteHelper.shared.keepSendRouteID
		guard let startText = self.startPoint.text else {
			print("startText資料不全！")
			return
		}
		guard let endText = self.endPoint.text else {
			print("endText資料不全！")
			return
		}
		guard let timeText = self.timingLabel.text else {
			print("timeText資料不全！")
			return
		}
		let info = self.recordInfo ?? TimeRecordItem(context: moc)
		info.routeID = routeID
		print(startText)
		info.startName = startText
		print(endText)
		info.endName = endText
		print(timeText)
		info.spendTime = timeText
		info.type = TimeRecordItem.FromType(rawValue: typeNum) ?? .walk
		CoreDataHelper.shared.saveContext()
		if self.recordInfo != nil{
			self.delegate?.didFinishUpdate(item: info)//編輯
			print("SAVE didFinishUpdate")
			self.navigationController?.popViewController(animated: true)
		}else{
			self.delegate?.didFinishCreate(item: info)
			print("SAVE didFinishCreate")
//			self.dismiss(animated: true)
			self.navigationController?.popViewController(animated: true)
		}
	}
	
	func alertSave(){
		let alert = UIAlertController(title: "儲存計時", message: "要儲存這次的計時嗎？", preferredStyle: .alert)
		let save = UIAlertAction(title: "Save", style:.default) {_ in
			self.saveBtnPressed(self)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) {_ in
			self.pauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
		}
		alert.addAction(save)
		alert.addAction(cancel)
		present(alert, animated: true)
	}
	@objc
	func alertBack(){
		let alert = UIAlertController(title: "確定要取消嗎？", message: "還有未儲存的計時，確定要放棄這次計時嗎？", preferredStyle: .alert)
		let yes = UIAlertAction(title: "yes", style:.default) {_ in
			self.navigationController?.popViewController(animated: true)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		alert.addAction(yes)
		alert.addAction(cancel)
		present(alert, animated: true)
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

protocol AddTimeRecordVCDelegate : AnyObject{
	func didFinishUpdate(item : TimeRecordItem)
	func didFinishCreate(item : TimeRecordItem)
}
