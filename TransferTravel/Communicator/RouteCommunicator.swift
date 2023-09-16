////
////  RouteCommunicator.swift
////  TransferTravel
////
////  Created by Feng on 2023/8/16.
////
//
//import Foundation
//import Alamofire
//
//let userName = "Feng"
//
//typealias DoneHandler = (_ result: SeverResult?, _ error: Error?) ->Void
//
//class RouteCommunicator {
//
//	static let baseURL = "https://api.selfeng.cc/api/api/"
//	let testURL = baseURL + "read.php"
////	let updateDeviceTokenURL = baseURL + "updateDeviceToken.php"
////	let sendTextURL = baseURL + "sendMessage.php"
////	let getMessageURL = baseURL + "retriveMessages2.php"
//
//	//PHP文件裡來的呼叫值
////	let userNameKey = "UserName"
////	let deviceTokenKey = "DeviceToken"
////	let groupNameKey = "GroupName"
////	let dataKey = "data"
////	let messageKey = "Message"
//
//	static let shared = RouteCommunicator()
//	private init(){}
//
//	func updateDeviceToken(token: String, completion: DoneHandler?){
////		let parameters = ["UserName": "Feng", "DeviceToken": token, "GroupName": "MAPD39"]
////		let parameters = [userNameKey: userName, deviceTokenKey: token, groupNameKey: groupName]
////		doPost(updateDeviceTokenURL, parameters: parameters, completion: completion)
//	}
//
////	func getMessageList(lastMessageID: Int, completion: @escaping DoneHandler){
////
//////		let parameters = [lastMessageIDKey: lastMessageID, groupNameKey: groupName] as [String : Any]
////		let parameters: [String : Any] = [lastMessageIDKey: lastMessageID, groupNameKey: groupName]
////		//completion會丟到下面的doGet裡面去做
////		doGet(testURL, parameters: parameters, completion: completion)
////
////	}
//
//	private func doGet(_ urlString: String, parameters: [String: Any], completion: @escaping DoneHandler){
//
//		// 泛型 - Generic Type
//		//<T, Decodable> T是一個物件 必須支援Decodable的物件
//		//T只是一個代名詞
//		//如果responseDecodable報錯JSON不合法可以改成responseString先去看看他吐了什麼給我們
//		//可能是api連結錯了或是Sever給的東西錯了
//		AF.request(urlString,
//				   method: .get,
//				   parameters: parameters,
//				   encoding: URLEncoding.default).responseDecodable {
//			//在closeure裡面指定型別(response: DataResponse<SeverResult, AFError>)
//			(response: DataResponse<SeverResult, AFError>) in
//			self.handleResponse(response: response, completion: completion)
////			switch response.result {
////			case .success(let result):
////				print("Success with: \(result)")
////				completion(result, nil) //成功就會把解出來的result傳出說
////			case .failure(let error):
////				print("Fail with: \(error)")
////				completion(nil, error) //失敗就讓他把回傳值變成nil並印出error
////			}
//
//		}
//		print("End of doGet()")
//	}
////	private func doGet(_ urlString: String, parameters: [String: Any]){
////
////		AF.request(urlString,
////				   method: .get,
////				   parameters: parameters,
////				   encoding: URLEncoding.default).responseJSON{ response in
////			//responseJSON把JSON解出來
////			//JSON的型別是dictionary
////			switch response.result {
////			case .success(let json):
////				print("JSON: \(json)")
////				if let json = json as? Dictionary<String, Any>{
////					let result = json["result"]
////				}
////			case .failure(let error):
////				print("error: \(error)")
////			}
////		}
////	}
//
//	// code重複使用最大化
//	// 把要post出去的資料用parameters包成一個[String: Any]型態的dictionary
//	private func doPost(_ urlString: String, parameters: [String: Any], completion: DoneHandler?){
//
//		// 把要的參數組合成JSON
//		// 官方提供的JSONSerialization
//		guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters),
//		let jsonString = String(data: jsonData, encoding: .utf8) else{
//			assertionFailure("Encode JSON Fail!")
//			return
//		}
//		//JSON印出來順序不重要
//		print("jsonString: \(jsonString)")
//
//		//轉成sever要的格式是data=...
//		//data={"UserName":"Tester","DeviceToken":"a1671413bd7d904842754fe2ed571d1b72f97973ffbef3802f452adccdcfe4a8","GroupName":"AP103"}
//		let finalParameters = [dataKey: jsonString]
//
//		//Alamofire
//		//request會回傳一個DataRequest 可以掌握他的狀況 有需要可以拿出來用
//		//用.response 可以拿到回傳值
//		//已知目前會回傳JSON格式（後端設定的回傳格式
//		//所以用responseJSON(舊
//		//closeurer基本上都是異步執行 比較晚才會執行（只有awake async才有辦法做到等他做完，但太新了第三方套件目前沒支援）
//		/*
//		//1)
//		AF.request(urlString,
//				   method: .post,
//				   parameters: finalParameters,
//				   encoding: URLEncoding.default).responseString { response in
//			//3)
//			//先用responseString觀察回傳的東西(平常不太用，debug比較常用)
//			print("response: \(response.value ?? "n/a")")
//		}
//		//2)
//		 */
//		//新的比較多使用responseDecodable
//		AF.request(urlString,
//				   method: .post,
//				   parameters: finalParameters,
//				   encoding: URLEncoding.default).responseDecodable {
//			(response: DataResponse<SeverResult, AFError>) in
//			self.handleResponse(response: response, completion: completion)
//		}
//		//因為舊的responseJSON還要把Dictionary型別轉換拆出很囉唆
////		AF.request(urlString,
////				   method: .post,
////				   parameters: finalParameters,
////				   encoding: URLEncoding.default).responseJSON{ response in
////			//responseJSON把JSON解出來
////			//JSON的型別是dictionary
////			switch response.result {
////			case .success(let json):
////				print("JSON: \(json)")
////				if let json = json as? Dictionary<String, Any>{
////					let result = json["result"]
////				}
////			case .failure(let error):
////				print("error: \(error)")
////			}
////		}
//	}
//}
//
////所有聊天記錄的資料結構物件
//struct SeverResult: Decodable {
//	//可能不是每次都會有資料的可以加?變成可選型別
//	//沒有帶來資料的話會出現nil
//	//(沒有回傳和回傳沒東西是兩回事）
//	var success: Bool
//	var errorCode: String?
////	var messages: [MessageItem]?
//	enum CodingKeys: String, CodingKey {
//		//如果沒有設定就會傳不回來 所以就算沒有要對應還是要寫出來（一對一）
//		case success = "result"
//		case errorCode
////		case messages = "Messages"
//
//	}
//
//
//}
