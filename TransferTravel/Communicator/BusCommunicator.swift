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
//typealias completionHandler = (_ data: Data?, _ response: URLResponse?, _ error: Error?) ->Void


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
	
	let dataKey = "data"
	var token: String = ""
	
	func setToken(_ content: String) {
		let jsonDecoder = JSONDecoder()
		guard let jsonCont = content.data(using: .utf8) else{
			print("jsonCont error")
			return
		}
		do{
			let json = try jsonDecoder.decode(TokenResult.self, from: jsonCont)
			self.token = json.token
		} catch {
			assertionFailure("Fail to : \(error)")
			return
		}
		print("token: \(self.token)")
	}
	
	func getToken() -> String? {
		return token
	}
	
	func getToken(id clientId: String, key clientSecret: String, completion: @escaping TokenHandler) {
		var request = URLRequest(url: URL(string: tokenURL)!)
		request.httpMethod = "post"
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
		let data = "\(grantTypeKey)=\(grantType)&\(clientIDKey)=\(clientId)&\(clientSecretKey)=\(clientSecret)".data(using: .utf8)
		request.httpBody = data
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config)
		let task = session.dataTask(with: request) { data, response, error in
			
			if let error = error{
				completion(.failure(error))
				print("Get Token fail: \(error)")
				return
			}
			guard let data = data,
				  let response = response as? HTTPURLResponse else {
				assertionFailure("Invalid data or response.")
				completion(.failure(NSError(domain: "Token Retrieval", code: -1, userInfo: nil)))
//				completion(nil, error)
				return
			}
			if response.statusCode == 200{
				completion(.success(data))
//				if let content = String(data: data, encoding: .utf8) {
//					completion(.success(content))
//				}
//				if let content = String(data: data, encoding: String.Encoding.utf8){
//
////					completion(data, nil)
//				} else {
////					completion(nil, error)
//					completion(.failure(NSError(domain: "Token Retrieval", code: -1, userInfo: nil)))
//
//				}
			}
		}
		task.resume()
		session.finishTasksAndInvalidate()
	}
	
		func getTest(completion: @escaping DoneHandler){
			let accessTokenKey = "accessToken"
			let parameters: [String : Any] = [accessTokenKey: token]
			doGet(THSRURL, parameters: parameters, completion: completion)
	
			let headers: HTTPHeaders = [
				"Authorization": "Basic VXNlcm5hbWU6UGFzc3dvcmQ=",
				"Accept": "application/json"
			]
	
			let url = URL(string: THSRURL)!
			var request = URLRequest(url: url)
	
	//		request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
	
		}
	
	// 进行 GET 请求的方法
		func performGETRequest(completion: @escaping (Result<Data, Error>) -> Void) {
			
			let headers: HTTPHeaders = [
				"Authorization": "Bearer \(token)"
			]
			
			AF.request("https://api.example.com/get_endpoint", headers: headers)
				.responseData { response in
					switch response.result {
					case .success(let data):
						completion(.success(data))
					case .failure(let error):
						completion(.failure(error))
					}
				}
		}
		
		// 进行 POST 请求的方法
		func performPOSTRequest(data: Data, completion: @escaping (Result<Data, Error>) -> Void) {
			
			let headers: HTTPHeaders = [
				"Authorization": "Bearer \(token)"
			]
			
			AF.upload(data, to: "https://api.example.com/post_endpoint", headers: headers)
				.responseData { response in
					switch response.result {
					case .success(let data):
						completion(.success(data))
					case .failure(let error):
						completion(.failure(error))
					}
				}
		}
	
	private func doGet(_ urlString: String,
					   //					   Header: HTTPHeaders,
					   parameters: [String: Any],
					   completion: @escaping DoneHandler){
		//如果responseDecodable報錯JSON不合法可以改成responseString先去看看他吐了什麼給我們
		//		AF.request(urlString, method: .get, parameters: parameters, headers: Header)
		AF.request(urlString,
				   method: .get,
				   parameters: parameters,
				   encoding: URLEncoding.default).responseDecodable {
			//在closeure裡面指定型別(response: DataResponse<SeverResult, AFError>)
			(response: DataResponse<SeverResult, AFError>) in
			//			response in
			//			self.handleResponse(response: response, completion: completion)
			switch response.result {
			case .success(let result):
				print("Success with: \(result)")
				completion(result, nil) //成功就會把解出來的result傳出說
			case .failure(let error):
				print("Fail with: \(error)")
				completion(nil, error) //失敗就讓他把回傳值變成nil並印出error
			}
			
		}
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
	var refresh_expires: Int
	var type: String
	var policy: Int
	var scope: String
	enum CodingKeys: String, CodingKey {
		//case Swift的變數 = "PHP名稱"
		case token = "access_token"
		case expires = "expires_in"
		case refresh_expires = "refresh_expires_in"
		case type = "token_type"
		case policy = "not-before-policy"
		case scope = "scope"
	}
}

//所有聊天記錄的資料結構物件
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

