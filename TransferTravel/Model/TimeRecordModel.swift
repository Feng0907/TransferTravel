//
//  TimeRecordModel.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/8.
//

import UIKit
import CoreData

class TimeRecordItem: NSManagedObject{
	@NSManaged var startName: String
	@NSManaged var endName: String
	@NSManaged var timerecordID: String
	@NSManaged var seq: Double
	@NSManaged var spendTime: String
	@NSManaged var type: FromType
	@NSManaged var routeID: Int
	
	//coredata不能用enum string要做一些處理
	@objc
	enum FromType: Int16 {
		case walk = 0
		case bicycle = 1
		case motorcycle = 2
		case car = 3
	}
	
	override func awakeFromInsert() {
		timerecordID = UUID().uuidString
	}
}


//class TimeRecord {
//	//計時的時候畫面的樣式
//
//}


