//
//  RouteCommunicator.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/16.
//

import Foundation
import Alamofire

let userName = "Feng"

typealias DoneHandler = (_ result: SeverResult?, _ error: Error?) ->Void

class RouteCommunicator {
	
	static let baseURL = "https://api.selfeng.cc/api/api/"
	let testURL = baseURL + "read.php"
//	let updateDeviceTokenURL = baseURL + "updateDeviceToken.php"
//	let sendTextURL = baseURL + "sendMessage.php"
//	let getMessageURL = baseURL + "retriveMessages2.php"
	
	//PHP文件裡來的呼叫值
//	let userNameKey = "UserName"
//	let deviceTokenKey = "DeviceToken"
//	let groupNameKey = "GroupName"
//	let dataKey = "data"
//	let messageKey = "Message"
	
	static let shared = RouteCommunicator()
	private init(){}
	
	func updateDeviceToken(token: String, completion: DoneHandler?){
		let parameters = ["UserName": "Feng", "DeviceToken": token, "GroupName": "MAPD39"]
		let parameters = [userNameKey: userName, deviceTokenKey: token, groupNameKey: groupName]
		doPost(updateDeviceTokenURL, parameters: parameters, completion: completion)
	}
	
	func getMessageList(lastMessageID: Int, completion: @escaping DoneHandler){
		
//		let parameters = [lastMessageIDKey: lastMessageID, groupNameKey: groupName] as [String : Any]
		let parameters: [String : Any] = [lastMessageIDKey: lastMessageID, groupNameKey: groupName]
		//completion會丟到下面的doGet裡面去做
		doGet(testURL, parameters: parameters, completion: completion)
		
	}
}

//所有聊天記錄的資料結構物件
struct SeverResult: Decodable {
	//可能不是每次都會有資料的可以加?變成可選型別
	//沒有帶來資料的話會出現nil
	//(沒有回傳和回傳沒東西是兩回事）
	var success: Bool
	var errorCode: String?
//	var messages: [MessageItem]?
	enum CodingKeys: String, CodingKey {
		//如果沒有設定就會傳不回來 所以就算沒有要對應還是要寫出來（一對一）
		case success = "result"
		case errorCode
//		case messages = "Messages"
		
	}
	
	
}
