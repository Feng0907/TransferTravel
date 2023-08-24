//
//  HistoryTableVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/22.
//

import UIKit
import CoreData

class HistoryTableVC: UITableViewController {
	
	var recordInfo: TimeRecordItem?
	var historyList = [HistoryItem]()
	weak var delegate: HistoryTableVCDelegate?
	
	let formatter = DateFormatter()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		queryFromCoreData()//讀出資料庫資料
		guard let recordInfo = recordInfo else {
			print("Query History Error.")
			return
		}
		navigationItem.title = "\(recordInfo.startName) - \(recordInfo.endName)"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		self.reAverageTimes()
		self.delegate?.reAverageTime()
		
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return historyList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
		let item = historyList[indexPath.row]
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		cell.textLabel?.text = timeConversion(millsecond: item.spendTime)
		cell.detailTextLabel?.text = formatter.string(from: item.recordTime)
//		String(format: "Last seen: %.1f seconds ago.", Date().timeIntervalSince(item.lastSeen))
        return cell
    }
	
	//把毫秒換回時間
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
		let showmin = min > 9 ? "\(min)" : "0\(min)"
		let showhour = hour > 9 ? "\(hour)" : "0\(hour)"
		let time = "\(showhour):\(showmin):\(showsec):\(showmillsec)"
		return time
	}
	
	private func queryFromCoreData(){
		let moc = CoreDataHelper.shared.managedObjectContext()
		let request = NSFetchRequest<HistoryItem>(entityName: "HistoryItem")//資料庫裡的table名稱
		guard let timeID = recordInfo?.timerecordID else {
			print("error timerecordID.")
			return
		}
		let predicate = NSPredicate(format: " timerecordID = %@ ", timeID )
		let sort = NSSortDescriptor(key: "recordTime", ascending: true)
		request.predicate = predicate
		request.sortDescriptors = [sort]
		do{
			let result = try moc.fetch(request)
			self.historyList = result
		}catch{
			self.historyList = []
			print("query cora data error \(error)")
		}
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
			let deletedData = self.historyList.remove(at: indexPath.row)
			let moc = CoreDataHelper.shared.managedObjectContext()
			moc.performAndWait {
				moc.delete(deletedData)
			}
			CoreDataHelper.shared.saveContext()
			self.reAverageTimes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
	
	private func HistoryAverage() -> Int64? {
		let data = self.historyList
		var dataSum: Int64 = 0
		for datum in data {
			dataSum += datum.spendTime
		}
		let averageTime: Int64 = dataSum / Int64(data.count)
		return averageTime
		
	}
	
	func reAverageTimes() {
		guard let time = HistoryAverage() else {
			print("平均顯示錯誤")
			return
		}
		let moc = CoreDataHelper.shared.managedObjectContext()
		let info = TimeRecordItem(context: moc)
		info.spendTime = time
		CoreDataHelper.shared.saveContext()
//		info.spendTime = queryFromHistoryAverage() ?? Int64(millsecond)
//		let info = TimeRecordItem(context: moc)
//		info.spendTime = time
//		CoreDataHelper.shared.saveContext()
//		self.delegate?.didFinishUpdate(item: info)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol HistoryTableVCDelegate : AnyObject {
	func reAverageTime()
}
