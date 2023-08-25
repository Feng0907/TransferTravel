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
	@IBOutlet weak var averageTimeLabel: UILabel!
	
	@IBOutlet weak var btnWalk: UIButton!
	@IBOutlet weak var btnBicycle: UIButton!
	@IBOutlet weak var btnMotorcycle: UIButton!
	@IBOutlet weak var btnCar: UIButton!
	
	@IBOutlet weak var startBtn: UIButton!
	@IBOutlet weak var pauseBtn: UIButton!
	@IBOutlet weak var stopBtn: UIButton!
	
	@IBOutlet weak var historyBtn: UIButton!
	
	var timer = Timer()
	var startStatus : Bool = true
	var millsecond: Int64 = 0
	var millsec: Int64 = 0
	var sec: Int64 = 0
	var min: Int64 = 0
	var hour: Int64 = 0
	
	var routeID: Int64?
	var recordInfo: TimeRecordItem?
	var transType: TimeRecordItem.FromType? = nil
	weak var delegate: AddTimeRecordVCDelegate?
	var  averageData = [HistoryItem]()
	
	var btnSelected = [false, false, false, false]
	
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
				self.delegate?.reloadTable()
				self.navigationController?.popViewController(animated: true)
			}))
			self.averageTimeLabel.isHidden = true
			self.historyBtn.isHidden = true
		} else {
			guard let time = queryFromHistoryAverage() else {
				print("平均顯示錯誤")
				return
			}
			print("平均顯示: \(time)")
			self.averageTimeLabel.text = "平均: \(timeConversion(millsecond: time))"
		}
    }
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	override func viewWillDisappear(_ animated: Bool) {
		self.delegate?.reloadTable()
//		if startStatus == false {
//			timer.invalidate()
//			startStatus = true
//		}
	}
	
	@objc
	func appDidEnterBackground() {
		if startStatus == false {
			startTime = Date()
		}
	}
	@objc
	func appDidBecomeActive() {
		if let startTime = startTime {
			elapsedTime = 0
			elapsedTime += Date().timeIntervalSince(startTime)
			self.startTime = nil
			self.middleTime = nil
		}
		updateTimerDisplay()
	}

	func updateTimerDisplay() {
		// 更新計時器顯示，例如格式化時間
		millsecond += Int64(elapsedTime * 100)
		elapsedTime = 0
	}
	
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
	func timeConversion(millsecond: Int64) -> String{
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
		let now = Date()
		self.btnSelected = [btnWalk.isSelected, btnBicycle.isSelected, btnMotorcycle.isSelected, btnCar.isSelected]
		for i in 0...3 {
			if self.btnSelected[i] == true{
				typeNum = Int16(i)
			}
		}
		let moc = CoreDataHelper.shared.managedObjectContext()
		let routeID = SendRouteHelper.shared.keepSendRouteID
		guard let startText = self.startPoint.text else {
			showAlert(message: "尚未填寫出發地點")
			print("startText資料不全！")
			return
		}
		guard let endText = self.endPoint.text else {
			showAlert(message: "尚未填寫抵達地點")
			print("endText資料不全！")
			return
		}
		let info = self.recordInfo ?? TimeRecordItem(context: moc)
		info.routeID = routeID
		info.startName = startText
		info.endName = endText
		info.spendTime = queryFromHistoryAverage() ?? Int64(millsecond)
		info.type = TimeRecordItem.FromType(rawValue: typeNum) ?? .walk
		let saveData = HistoryItem(context: moc)
		saveData.routeID = routeID
		saveData.timerecordID = info.timerecordID
		saveData.spendTime = Int64(millsecond)
		saveData.recordTime = now
		CoreDataHelper.shared.saveContext()
		info.spendTime = queryFromHistoryAverage() ?? Int64(millsecond)
		self.startStatus = true
		self.timer.invalidate()
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
			self.startStatus = true
			self.timer.invalidate()
			self.delegate?.reloadTable()
			self.navigationController?.popViewController(animated: true)
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		alert.addAction(yes)
		alert.addAction(cancel)
		present(alert, animated: true)
	}
	
	private func queryFromHistoryAverage() -> Int64? {
		guard let timeID = self.recordInfo?.timerecordID else {
			print("New Route no ID")
			return nil
		}
		let moc = CoreDataHelper.shared.managedObjectContext()
		let request = NSFetchRequest<HistoryItem>(entityName: "HistoryItem")//資料庫裡的table名稱
		let predicate = NSPredicate(format: " timerecordID = %@ ", timeID )
		let sort = NSSortDescriptor(key: "recordTime", ascending: true)
		request.predicate = predicate
		request.sortDescriptors = [sort]
		do{
			let result = try moc.fetch(request)
			self.averageData = result
		}catch{
			self.averageData = []
			print("query cora data error \(error)")
		}
		let data = self.averageData
		var dataSum: Int64 = 0
		for datum in data {
			dataSum += datum.spendTime
		}
		let averageTime: Int64 = dataSum / Int64(data.count)
		return averageTime
		
	}
	
    // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		 if segue.identifier == "HistorySegue" ,
			let HistoryVC = segue.destination as? HistoryTableVC,
			let info = self.recordInfo{
			 HistoryVC.recordInfo = info
			 HistoryVC.delegate = self
		 }
	 }

}

extension AddTimeRecordVC: HistoryTableVCDelegate {
	func reAverageTime() {
		guard let time = queryFromHistoryAverage() else {
			print("平均顯示錯誤")
			return
		}
		self.averageTimeLabel.text = "平均: \(timeConversion(millsecond: time))"
		let moc = CoreDataHelper.shared.managedObjectContext()
		let routeID = SendRouteHelper.shared.keepSendRouteID
		let info = self.recordInfo ?? TimeRecordItem(context: moc)
		info.spendTime = time
		self.delegate?.didFinishUpdate(item: info)
	}
	
	
}

protocol AddTimeRecordVCDelegate : AnyObject{
	func didFinishUpdate(item : TimeRecordItem)
	func didFinishCreate(item : TimeRecordItem)
	func reloadTable()
}
