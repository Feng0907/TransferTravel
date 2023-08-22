//
//  SendMessageHelper.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/15.
//

import Foundation

class SendRouteHelper {
	static let shared = SendRouteHelper()
	private init(){}
	var keepSendRouteID : Int64 = 0
}
class SendRecordHelper {
	static let shared = SendRecordHelper()
	private init(){}
	var timerecordID : String = ""
}
