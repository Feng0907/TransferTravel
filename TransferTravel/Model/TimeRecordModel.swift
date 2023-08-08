//
//  TimeRecordModel.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/8.
//

import UIKit

struct TimeRecordItem {
	//先定義一筆紀錄時間的物件需要什麼內容物
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
	//計時的時候畫面的樣式
	
}


