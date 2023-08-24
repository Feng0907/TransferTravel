//
//  RouteTableVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/8.
//

import UIKit
import CoreData

class RouteTableVC: UITableViewController, UINavigationControllerDelegate, AddTimeRecordVCDelegate {
	
	//綜合清單列表
	//需要有三種不同的物件
	//1)自定義計時物件
	//2)公車站牌物件
	//3)捷運站物件
	
	//自定義排序要怎麼達成？
	
	@IBOutlet weak var routeName: UITextField!
	
	var routeItem: RouteItem?
	var selfitems = [TimeRecordItem]()
	var delegate: RouteTableVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
		queryFromCoreData()//讀出資料庫資料
		guard let item = routeItem,
			  let routeName = item.routeName else {
			return
		}
		self.routeName.text = routeName
		
//		NotificationCenter.default.addObserver(forName: .thisRouteID, object: self, queue: nil){
//			[weak self] thisID in
//			let ID = thisID.userInfo?["ID"]
//		}
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
//		self.tableView.reloadData()
	}
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return selfitems.count
    }
	
	func showBtnType(_ type: TimeRecordItem.FromType) -> UIImage{
		switch type {
		case .walk:
			let image = UIImage.init(named: "walk_on_transBtnIcon.png")!
			return image
		case .bicycle:
			let image = UIImage.init(named: "bicycle_on_transBtnIcon.png")!
			return image
		case .motorcycle:
			let image = UIImage.init(named: "motorcycle_on_transBtnIcon.png")!
			return image
		case .car:
			let image = UIImage.init(named: "car_on_transBtnIcon.png")!
			return image
		}
	}
	
	func timeConversion(millsecond: Int64) -> String{
		var millsec: Int64 = 0
		var sec: Int64 = 0
		var min: Int64 = 0
		var hour: Int64 = 0
		millsec = millsecond % 100
		sec = (millsecond / 100) % 60
		min = millsecond / 6000 % 60
		hour = millsecond / 360000  //累加
		let showmillsec = millsec > 9 ? "\(millsec)" : "0\(millsec)"
		let showsec = sec > 9 ? "\(sec)" : "0\(sec)"
		let showmin = min > 9 ? "\(min)" : "\(min)"
		let showhour = hour > 9 ? "\(hour)" : "\(hour)"
		if millsecond < 6000 {
//			let time = "1 min"
			let time = "AA\(showmin):\(showsec):"
			return time
		} else if millsecond < 360000 {
//			let time = "\(showmin) min"
			let time = "BB\(showmin):\(showsec):"
			return time
		} else {
			let time = "\(showhour):\(showmin)"
			return time
		}
		
	}
	
//	func timeToMin(_ timeText: Int) -> String {
//		let array = timeText.components(separatedBy: ":")
//		if array[0] != "00" {
//			let time = array[0] + "小時" + array[1] + "分"
//			return time
//		}else{
//			let time = array[1] + "分"
//			return time
//		}
		
//	}
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let selfcell = tableView.dequeueReusableCell(withIdentifier: "SelfRouteTVCell", for: indexPath) as? SelfRouteTVCell else{
		   fatalError("請確認storybord上有設定customcell")
	   }
		let item = selfitems[indexPath.row]
		selfcell.awakeFromNib()
		selfcell.selfIconImage.image = showBtnType(item.type)
		selfcell.startPointName.text = item.startName
		selfcell.endPointName.text = item.endName
		selfcell.timeLabel.layer.cornerRadius = 10
		selfcell.timeLabel.clipsToBounds = true
		let time = item.spendTime
		selfcell.timeLabel.text = timeConversion(millsecond: time)
//		selfcell.timeShow.titleLabel?.text = timeToMin(item.spendTime)
//		cell.MyLabel.text = note.text
//        let cell = tableView.dequeueReusableCell(withIdentifier: "selfRouteItem", for: indexPath)
		
		//預設cell上的物件
//		cell.textLabel?.text = item.startName
//		cell.imageView?.image = item.type
		
        return selfcell
    }
	
	@IBAction func saveBtnPressed(_ sender: Any) {
		let moc = CoreDataHelper.shared.managedObjectContext()
		let selfitem = self.routeItem ?? RouteItem(context: moc)
		selfitem.routeName = self.routeName.text
		saveToCoreData()
		self.delegate?.didFinishUpdate(item: selfitem)
		self.tableView.reloadData()
	}
	
	@IBAction func addNewBtn(_ sender: Any) {
		if let newRoute = self.storyboard?.instantiateViewController(withIdentifier: "TimeRouteVC") as? AddTimeRecordVC{
			//自己產生一個Navigationbar
//			let naviC = UINavigationController(rootViewController: newRoute)
			newRoute.delegate = self
			self.show(newRoute, sender: self)
//			self.present(naviC, animated: true)
			
			
		}
	}

	private func queryFromCoreData(){
		let moc = CoreDataHelper.shared.managedObjectContext()
//		moc.reset()
		let request = NSFetchRequest<TimeRecordItem>(entityName: "TimeRecordItem")//資料庫裡的table名稱
		let predicate = NSPredicate(format: " routeID = \(SendRouteHelper.shared.keepSendRouteID) " )
		let sort = NSSortDescriptor(key: "seq", ascending: true)
		request.predicate = predicate
		request.sortDescriptors = [sort]
		do{
			let result = try moc.fetch(request)
			self.selfitems = result
		}catch{
			self.selfitems = []
			print("query cora data error \(error)")
		}
		
	}
	
	func saveToCoreData() {
		CoreDataHelper.shared.saveContext()
	}
	func reloadTable() {
		self.tableView.reloadData()
	}
	func didFinishUpdate(item : TimeRecordItem){
//		self.saveToCoreData()
		self.tableView.reloadData()
	}
	//新增時被呼叫的方法
	func didFinishCreate(item : TimeRecordItem){
//		let moc = CoreDataHelper.shared.managedObjectContext()
		if self.selfitems.count == 0{
			item.seq = 10
		}else{
			let firstNote = self.selfitems[0]
			item.seq = firstNote.seq + 10
		}
		self.selfitems.insert(item, at: 0)
		CoreDataHelper.shared.saveContext()//儲存seq
		let indexPath = IndexPath(row: 0, section: 0)
		self.tableView.insertRows(at: [indexPath], with: .automatic)
		self.tableView.reloadData()
		
	}


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			let deletedData = self.selfitems.remove(at: indexPath.row)
			let moc = CoreDataHelper.shared.managedObjectContext()
			moc.performAndWait {
				moc.delete(deletedData)
			}
	//		self.writeToFile()
			self.saveToCoreData()
			//移除在data中的相同那一筆資料
			for index in 0 ..< self.selfitems.count{
				if self.selfitems[index].routeID == deletedData.routeID{
					self.selfitems.remove(at: index)
					break
				}
			}
			//呼叫tableView 刪除
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "RouteItemSegue" ,
		   let TimeRecordVC = segue.destination as? AddTimeRecordVC,
		   let index = self.tableView.indexPathForSelectedRow {
			let item = self.selfitems[index.row]
			TimeRecordVC.recordInfo = item
			TimeRecordVC.delegate = self
		}
    }
}
protocol RouteTableVCDelegate {
	func didFinishUpdate(item : RouteItem)
}

