//
//  HistoryItemModel.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/22.
//

import Foundation
import UIKit
import CoreData

class HistoryItem: NSManagedObject{
	
	@NSManaged var routeID: Int64
	@NSManaged var timerecordID: String
	@NSManaged var spendTime: String
	@NSManaged var recordTime : Date

}

