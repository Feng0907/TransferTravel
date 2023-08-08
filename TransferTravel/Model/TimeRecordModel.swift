//
//  TimeRecordModel.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/8.
//

import UIKit

struct TimeRecordItem {
	var startName: String?
	var endName: String?
	var timerecordID: String?
	var spendTime: String?
	var type: FromType
	
	enum FromType { //如果是只需要在這個struct裡面作用就放在裡面
		case walk
		case bicycle
		case motorcycle
		case car
	}
}


class TimeRecord {
	
	
}
