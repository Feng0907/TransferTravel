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
class SendRecordTimeHelper {
	static let shared = SendRecordTimeHelper()
	private init(){}
	var spendTime: Int64 = 0
}
