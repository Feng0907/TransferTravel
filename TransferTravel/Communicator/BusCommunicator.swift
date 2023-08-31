//
//  BusCommunicator.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/27.
//

import Foundation
import Alamofire

typealias DoneHandler = (_ result: SeverResult?, _ error: Error?) ->Void
typealias TokenHandler = (Result<Data, Error>) ->Void
typealias completionHandler = (_ data: Data?, _ response: URLResponse?, _ error: Error?) ->Void


class BusCommunicator {
	static let shared = BusCommunicator()
	private init(){}
	
	static let baseURL = "https://tdx.transportdata.tw/"
	let tokenURL = baseURL + "auth/realms/TDXConnect/protocol/openid-connect/token"
	//測試用高鐵班次
	let THSRURL = baseURL + "api/basic/v2/Rail/THSR/DailyTimetable/Today?$format=JSON"
	
	let grantTypeKey = "grant_type"
	let clientIDKey = "client_id"
	let clientSecretKey = "client_secret"
	let grantType = "client_credentials"
	
	let headersKey = "Content-Type"
	let headersValue = "application/x-www-form-urlencoded"
	
	let dataKey = "data"
	var token: String = ""
	let accessTokenKey = "accessToken"
	
//	func setToken(_ content: String) {
//		let jsonDecoder = JSONDecoder()
//		guard let jsonCont = content.data(using: .utf8) else{
//			print("jsonCont error")
//			return
//		}
//		do{
//			let json = try jsonDecoder.decode(TokenResult.self, from: jsonCont)
//			token = json.token
//		} catch {
//			assertionFailure("Fail to : \(error)")
//			return
//		}
//	}

	func getToken(id clientId: String, key clientSecret: String) {
		let parameters: [String: Any] = [
			grantTypeKey: grantType,
			clientIDKey: clientId,
			clientSecretKey: clientSecret
		]

		AF.request(tokenURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: [headersKey: headersValue]).validate(statusCode: [200, 201])
			.responseDecodable { (response: DataResponse<TokenResult, AFError>) in
				switch response.result {
				case .success(let content):
//					print("Async operation completed")
					self.token = content.token
				case .failure(let error):
					print("Get Token fail: \(error)")
				}
			}
	}
//	func getToken(id clientId: String, key clientSecret: String) {
//		var request = URLRequest(url: URL(string: tokenURL)!)
//		request.httpMethod = "post"
//		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
//		let data = "\(grantTypeKey)=\(grantType)&\(clientIDKey)=\(clientId)&\(clientSecretKey)=\(clientSecret)".data(using: .utf8)
//		request.httpBody = data
//		let config = URLSessionConfiguration.default
//		let session = URLSession(configuration: config)
//		let task = session.dataTask(with: request){ data, response, error in
//			if let error = error{
//					print("Get Token fail: \(error)")
//					return
//			}
//			guard let data = data,
//			  let response = response as? HTTPURLResponse else {
//				assertionFailure("Invalid data or response.")
//			return
//			}
//			if response.statusCode == 200{
//				if let content = String(data: data, encoding: .utf8) {
////					print("content:\(content)")
//					DispatchQueue.main.async {
//						print("Async operation completed")
//						self.setToken(content)
//					}
//				}
//			}
//		}
//		task.resume()
//		session.finishTasksAndInvalidate()
//	}

	func getTest(completion: @escaping DoneHandler){
		let headers: HTTPHeaders = [
			"authorization": "Bearer \(self.token)"
		]
		let parameters: [String : Any] = [:]
		doGet(THSRURL, parameters: parameters, headers: headers, completion: completion)
	}
	
//	// 进行 GET 请求的方法
//	func performGETRequest(completion: @escaping (Result<Data, Error>) -> Void) {
//
//		let headers: HTTPHeaders = [
//			"Authorization": "Bearer \(token)"
//		]
//
//		AF.request("https://api.example.com/get_endpoint", headers: headers)
//			.responseData { response in
//				switch response.result {
//				case .success(let data):
//					completion(.success(data))
//				case .failure(let error):
//					completion(.failure(error))
//				}
//			}
//	}
//
//	// 进行 POST 请求的方法
//	func performPOSTRequest(data: Data, completion: @escaping (Result<Data, Error>) -> Void) {
//
//		let headers: HTTPHeaders = [
//			"authorization": "Bearer \(token)"
//		]
////		request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
////
//		AF.upload(data, to: "https://api.example.com/post_endpoint", headers: headers)
//			.responseData { response in
//				switch response.result {
//				case .success(let data):
//					completion(.success(data))
//				case .failure(let error):
//					completion(.failure(error))
//				}
//			}
//	}
//
	private func doGet(_ urlString: String,
					   parameters: [String: Any]?,
					   headers: HTTPHeaders?,
					   completion: @escaping DoneHandler){
		//如果responseDecodable報錯JSON不合法可以改成responseString先去看看他吐了什麼給我們
		AF.request(urlString, method: .get, headers: headers).responseString { response in
			print("response: \(response.value ?? "n/a")")

		}
//		AF.request(urlString,
//				   method: .get,
//				   parameters: parameters,
//				   encoding: URLEncoding.default,
//				   headers: headers).responseDecodable {
//			//在closeure裡面指定型別(response: DataResponse<SeverResult, AFError>)
//			(response: DataResponse<SeverResult, AFError>) in
//			//			response in
//			//			self.handleResponse(response: response, completion: completion)
//			switch response.result {
//			case .success(let result):
//				print("Success with: \(result)")
//				completion(result, nil) //成功就會把解出來的result傳出說
//			case .failure(let error):
//				print("Fail with: \(error)")
//				completion(nil, error) //失敗就讓他把回傳值變成nil並印出error
//			}
//
//		}
		print("End of doGet()")
	}

	
	private func doPost(_ urlString: String, parameters: [String: Any], completion: DoneHandler?){
		
		guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters),
		let jsonString = String(data: jsonData, encoding: .utf8) else{
			assertionFailure("Encode JSON Fail!")
			return
		}
		print("jsonString: \(jsonString)")
		//轉成sever要的格式是data=...
		//data={"UserName":"Tester","DeviceToken":"a1671413bd7d904842754fe2ed571d1b72f97973ffbef3802f452adccdcfe4a8","GroupName":"AP103"}
		let finalParameters = [dataKey: jsonString]

		/*
		//1)
		AF.request(urlString,
				   method: .post,
				   parameters: finalParameters,
				   encoding: URLEncoding.default).responseString { response in
			//3)
			//先用responseString觀察回傳的東西(平常不太用，debug比較常用)
			print("response: \(response.value ?? "n/a")")
		}
		//2)
		 */

		AF.request(urlString,
				   method: .post,
				   parameters: finalParameters,
				   encoding: URLEncoding.default).responseDecodable {
			(response: DataResponse<SeverResult, AFError>) in
			self.handleResponse(response: response, completion: completion)
		}
	}
	private func handleResponse(response: DataResponse<SeverResult, AFError>, completion: DoneHandler?) {
		switch response.result {
		case .success(let result):
			print("Success with: \(result)")
			completion?(result, nil) //成功就會把解出來的result傳出來
		case .failure(let error):
			print("Fail with: \(error)")
			completion?(nil, error) //失敗就讓他把回傳值變成nil並印出error
		}
	}
}

struct TokenResult: Codable {
	var token: String
	var expires: Int
	var refreshExpires: Int
	var type: String
	var policy: Int
	var scope: String
	enum CodingKeys: String, CodingKey {
		//case Swift的變數 = "PHP名稱"
		case token = "access_token"
		case expires = "expires_in"
		case refreshExpires = "refresh_expires_in"
		case type = "token_type"
		case policy = "not-before-policy"
		case scope = "scope"
	}
}

struct SeverResult: Decodable {
	var success: Bool
	var errorCode: String?
	var tokenJSON: [TokenResult]?
	enum CodingKeys: String, CodingKey {
		case success = "result"
		case errorCode
		case tokenJSON = "content"
	}
}

