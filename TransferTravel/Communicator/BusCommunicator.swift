//
//  BusCommunicator.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/27.
//

import Foundation
import Alamofire


//typealias DoneHandler = (_ result: SeverResult?, _ error: Error?) ->Void
//typealias DoneHandler<T> = Result<T, AFError>
typealias DoneHandler<T> = (_ result: T?, _ error: Error?) ->Void
typealias CityArrayCompletion = DoneHandler<[CityResult]>
typealias BusStopOfRouteCompletion = DoneHandler<[BusStopResult]>
typealias BusRouteInfoCompletion = DoneHandler<[BusRouteInfoResult]>
typealias BusTimeOfArrivalCompletion = DoneHandler<[StopOfTimeArrival]>
typealias BusTimeOfArrivalA1Completion = DoneHandler<[BusArrivalData]>

typealias TokenCompletion = DoneHandler<TokenResult>
class BusCommunicator {
	static let shared = BusCommunicator()
	private init(){}
	
	var masterKey: String {
		var result = "GHI"
		result += "$%"
		result += String(3 * 8 - 1)
		result += String(2 * 2)
		result += "dba".reversed()
		var total = 0
		for _ in 0..<63 {
			total += 1
		}
		result += String(total)
		result += "#@ed".reversed()
		result = result.replacingOccurrences(of: "GHI", with: "")
		return result
	}
	var payloadKey: String {
		return try! "AwG1kmiNQxMCe1B+7e0cy3QXgcQnAaGj416shUF3krIxTQ+2j7tigVy+0OBBKITsHE91/ZHwzjkf0/SuziwwIAzZgxhFYUsY/UrWMtpvtCI7+Q==".decryprBase64(key: masterKey)!
	}
	
	static let baseURL = "https://tdx.transportdata.tw/"
	let tokenURL = baseURL + "auth/realms/TDXConnect/protocol/openid-connect/token"
	
	let cityURL = baseURL + "api/basic/v2/Basic/City"
	//這個公車站牌顯示不夠多要換另一個撈
//	let busStopOfRouteURL = baseURL + "api/basic/v2/Bus/DisplayStopOfRoute/City/"
	let busStopOfRouteURL = baseURL + "api/basic/v2/Bus/StopOfRoute/City/"
	let busRouteInfoURL = baseURL + "api/basic/v2/Bus/Route/City/"
	let busTimeOfArrivalURL = baseURL + "api/basic/v2/Bus/EstimatedTimeOfArrival/City/"
	let busTimeOfArrivalA1URL = baseURL + "api/basic/v2/Bus/RealTimeNearStop/City/"

	let grantTypeKey = "grant_type"
	let clientIDKey = "client_id"
	let clientSecretKey = "client_secret"
	let grantType = "client_credentials"
	
	let headersKey = "Content-Type"
	let headersValue = "application/x-www-form-urlencoded"
	
	let dataKey = "data"
	var token: String = ""
	let accessTokenKey = "accessToken"
	
	let cityKey = "City"
	let routeNameKey = "RouteName"
	
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
	
//	func getCity(completion: @escaping ([CityResult]?, Error?) -> Void) {
	func getCity(completion: @escaping CityArrayCompletion) {
		let headers: HTTPHeaders = [
			"authorization": "Bearer \(self.token)"
		]
		let parameters: [String: Any] = ["$format": "JSON"]

		doGet(cityURL, parameters: parameters, headers: headers, completion: completion)
//		AF.request(cityURL,
//				   method: .get,
//				   parameters: parameters,
//				   encoding: URLEncoding.default,
//				   headers: headers).responseDecodable(of: [CityResult].self){ response in
//			print(response)
//			switch response.result {
//			case .success(let result):
//				print("Success with: \(result)")
//
////				completion(result, nil) //成功就會把解出來的result傳出說
//			case .failure(let error):
//				print("Fail with: \(error)")
////				completion(nil, error) //失敗就讓他把回傳值變成nil並印出error
//			}
//		}
//		doGet(cityURL, parameters: parameters, headers: headers, completion: completion)
//		print("End of doGet()")
//		doGet(cityURL, parameters: parameters, headers: headers, completion: completion)
	}
	
	func getBusStopOfRoute(_ busNumber: String, city: String, completion: @escaping BusStopOfRouteCompletion) {
		let headers: HTTPHeaders = [
			"authorization": "Bearer \(self.token)"
		]
		let parameters: [String: Any] = ["$format": "JSON"]
//		[cityKey: city, routeNameKey: busNumber]

		doGet(busStopOfRouteURL + city + "/" + busNumber + "/", parameters: parameters, headers: headers, completion: completion)
		print("End of getBusStopOfRoute")
	}
	
	func getBusRouteInfo(_ busNumber: String, city: String, completion: @escaping BusRouteInfoCompletion) {
		let headers: HTTPHeaders = [
			"authorization": "Bearer \(self.token)"
		]
		let parameters: [String: Any] = ["$format": "JSON"]
		
		doGet(busRouteInfoURL + city + "/" + busNumber + "/", parameters: parameters, headers: headers, completion: completion)
//		print("End of getBusRouteInfo")
	}
	
	func getBusTimeOfArrival(_ busNumber: String, city: String, completion: @escaping BusTimeOfArrivalCompletion) {
		let headers: HTTPHeaders = [
			"authorization": "Bearer \(self.token)"
		]
		let parameters: [String: Any] = ["$format": "JSON"]
		
		doGet(busTimeOfArrivalURL + city + "/" + busNumber + "/", parameters: parameters, headers: headers, completion: completion)
		print("End of getBusTimeOfArrival")
	}
	func getBusTimeOfArrivalA1(_ busNumber: String, city: String, completion: @escaping BusTimeOfArrivalA1Completion) {
		let headers: HTTPHeaders = [
			"authorization": "Bearer \(self.token)"
		]
		let parameters: [String: Any] = ["$format": "JSON"]
		
		doGet(busTimeOfArrivalA1URL + city + "/" + busNumber + "/", parameters: parameters, headers: headers, completion: completion)
		print("End of getBusTimeOfArrivalA1")
	}
	
	private func doGet<type: Codable>(_ urlString: String,
					   parameters: [String: Any]?,
					   headers: HTTPHeaders?,
					   completion: @escaping DoneHandler<type>){
//		AF.request(urlString, method: .get, headers: headers).responseString { response in
//			print("response: \(response.value ?? "n/a")")
//
//		}
		AF.request(urlString,
					   method: .get,
					   parameters: parameters,
					   encoding: URLEncoding.default,
					   headers: headers)
				.validate()
				.responseDecodable(of: type.self) { (response: DataResponse<type, AFError>) in
					switch response.result {
					case .success(let result):
//						print("Success with: \(result)")
						completion(result, nil) //成功就會把解出來的result傳出說
					case .failure(let error):
						print("Fail with: \(error)")
						completion(nil, error) //失敗就讓他把回傳值變成nil並印出error
					}
				}
//		AF.request(urlString,
//				   method: .get,
//				   parameters: parameters,
//				   encoding: URLEncoding.default,
//				   headers: headers).responseDecodable{
//			(response: DataResponse<T, AFError>) in
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
//		print("End of doGet()")
	}
	
	private func doPost<type: Codable>(_ urlString: String, parameters: [String: Any], completion: DoneHandler<type>?){

		guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters),
		let jsonString = String(data: jsonData, encoding: .utf8) else{
			assertionFailure("Encode JSON Fail!")
			return
		}
		print("jsonString: \(jsonString)")
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
				   encoding: URLEncoding.default).responseDecodable(of: type.self)  { response in
			self.handleResponse(response: response, completion: completion)
		}
	}
	private func handleResponse<T>(response: DataResponse<T, AFError>, completion: DoneHandler<T>?) {
		switch response.result {
		case .success(let result):
//			print("Success with: \(result)")
			completion?(result, nil) //成功就會把解出來的result傳出來
		case .failure(let error):
//			print("Fail with: \(error)")
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
		case token = "access_token"
		case expires = "expires_in"
		case refreshExpires = "refresh_expires_in"
		case type = "token_type"
		case policy = "not-before-policy"
		case scope = "scope"
	}
}


struct CityResult: Codable {
	var cityID: String
	var cityName: String
	var cityCode: String
	var city: String
	var countyID: String
	var version: String
	enum CodingKeys: String, CodingKey {
		case cityID = "CityID"
		case cityName = "CityName"
		case cityCode = "CityCode"
		case city = "City"
		case countyID = "CountyID"
		case version = "Version"
		
	}
}

struct BusStopResult: Codable {
	let routeUID: String
	let routeID: String
	let routeName: RouteName
	let direction: Int
	let stops: [BusStop]
	let updateTime: String
	let versionID: Int

	private enum CodingKeys: String, CodingKey {
		case routeUID = "RouteUID"
		case routeID = "RouteID"
		case routeName = "RouteName"
		case direction = "Direction"
		case stops = "Stops"
		case updateTime = "UpdateTime"
		case versionID = "VersionID"
	}
}

struct RouteName: Codable {
	let zhTw: String
	let en: String?

	private enum CodingKeys: String, CodingKey {
		case zhTw = "Zh_tw"
		case en = "En"
	}
}

struct BusStop: Codable {
	let stopUID: String
	let stopID: String
	let stopName: StopName
	let stopBoarding: Int
	let stopSequence: Int
	let stopPosition: StopPosition
	let stationID: String

	private enum CodingKeys: String, CodingKey {
		case stopUID = "StopUID"
		case stopID = "StopID"
		case stopName = "StopName"
		case stopBoarding = "StopBoarding"
		case stopSequence = "StopSequence"
		case stopPosition = "StopPosition"
		case stationID = "StationID"
	}
}

struct StopName: Codable {
	let zhTw: String
	let en: String?

	private enum CodingKeys: String, CodingKey {
		case zhTw = "Zh_tw"
		case en = "En"
	}
}

struct StopPosition: Codable {
	let positionLon: Double
	let positionLat: Double
	let geoHash: String

	private enum CodingKeys: String, CodingKey {
		case positionLon = "PositionLon"
		case positionLat = "PositionLat"
		case geoHash = "GeoHash"
	}
}

//struct SeverResult: Decodable {
//	var success: Bool?
//	var errorCode: String?
//	var result: [BusRouteInfoResult]?
//	enum CodingKeys: String, CodingKey {
//		case success = "result"
//		case errorCode
//		case result = "City"
//	}
//}

struct BusRouteInfoResult: Codable {
	let routeUID: String
	let routeID: String
	let hasSubRoutes: Bool
	let operators: [BusOperator]
	let authorityID: String
	let providerID: String
	let subRoutes: [SubRoute]?
	let busRouteType: Int
	let routeName: RouteName
	let departureStopNameZh: String?
	let departureStopNameEn: String?
	let destinationStopNameZh: String
	let destinationStopNameEn: String?
	let ticketPriceDescriptionZh: String?
	let ticketPriceDescriptionEn: String?
	let fareBufferZoneDescriptionZh: String?
	let fareBufferZoneDescriptionEn: String?
	let routeMapImageUrl: String?
	let city: String
	let cityCode: String
	let updateTime: String
	let versionID: Int

	enum CodingKeys: String, CodingKey {
		case routeUID = "RouteUID"
		case routeID = "RouteID"
		case hasSubRoutes = "HasSubRoutes"
		case operators = "Operators"
		case authorityID = "AuthorityID"
		case providerID = "ProviderID"
		case subRoutes = "SubRoutes"
		case busRouteType = "BusRouteType"
		case routeName = "RouteName"
		case departureStopNameZh = "DepartureStopNameZh"
		case departureStopNameEn = "DepartureStopNameEn"
		case destinationStopNameZh = "DestinationStopNameZh"
		case destinationStopNameEn = "DestinationStopNameEn"
		case ticketPriceDescriptionZh = "TicketPriceDescriptionZh"
		case ticketPriceDescriptionEn = "TicketPriceDescriptionEn"
		case fareBufferZoneDescriptionZh = "FareBufferZoneDescriptionZh"
		case fareBufferZoneDescriptionEn = "FareBufferZoneDescriptionEn"
		case routeMapImageUrl = "RouteMapImageUrl"
		case city = "City"
		case cityCode = "CityCode"
		case updateTime = "UpdateTime"
		case versionID = "VersionID"
	}
}

struct BusOperator: Codable {
	let operatorID: String
	let operatorName: OperatorName
	let operatorCode: String?
	let operatorNo: String?

	enum CodingKeys: String, CodingKey {
		case operatorID = "OperatorID"
		case operatorName = "OperatorName"
		case operatorCode = "OperatorCode"
		case operatorNo = "OperatorNo"
	}
}

struct OperatorName: Codable {
	let zhTw: String
	let en: String?

	enum CodingKeys: String, CodingKey {
		case zhTw = "Zh_tw"
		case en = "En"
	}
}

struct SubRoute: Codable {
	let subRouteUID: String
	let subRouteID: String
	let operatorIDs: [String]
	let subRouteName: SubRouteName
	let direction: Int
	let firstBusTime: String?
	let lastBusTime: String?
	let holidayFirstBusTime: String?
	let holidayLastBusTime: String?

	enum CodingKeys: String, CodingKey {
		case subRouteUID = "SubRouteUID"
		case subRouteID = "SubRouteID"
		case operatorIDs = "OperatorIDs"
		case subRouteName = "SubRouteName"
		case direction = "Direction"
		case firstBusTime = "FirstBusTime"
		case lastBusTime = "LastBusTime"
		case holidayFirstBusTime = "HolidayFirstBusTime"
		case holidayLastBusTime = "HolidayLastBusTime"
	}
}

struct SubRouteName: Codable {
	let zhTw: String?
	let en: String?

	enum CodingKeys: String, CodingKey {
		case zhTw = "Zh_tw"
		case en = "En"
	}
}


struct StopOfTimeArrival: Codable {
	let stopUID: String
	let stopID: String
	let stopName: StopName
	let routeUID: String
	let routeID: String
	let routeName: RouteName
	let direction: Int
	let estimateTime: Int?
	let stopStatus: Int
	let nextBusTime: String?
	let isLastBus: Bool?
	let srcUpdateTime: String?
	let updateTime: String

	enum CodingKeys: String, CodingKey {
		case stopUID = "StopUID"
		case stopID = "StopID"
		case stopName = "StopName"
		case routeUID = "RouteUID"
		case routeID = "RouteID"
		case routeName = "RouteName"
		case direction = "Direction"
		case estimateTime = "EstimateTime"
		case stopStatus = "StopStatus"
		case nextBusTime = "NextBusTime"
		case isLastBus = "IsLastBus"
		case srcUpdateTime = "SrcUpdateTime"
		case updateTime = "UpdateTime"
	}
}
//
//struct BusArrivalData: Codable {
//	let plateNumb: String
//	let operatorID: String
//	let operatorNo: String
//	let routeUID: String
//	let routeID: String
//	let routeName: RouteName
//	let subRouteUID: String
//	let subRouteID: String
//	let subRouteName: RouteName
//	let direction: Int
//	let stopUID: String?
//	let stopID: String?
//	let stopName: StopName?
//	let stopSequence: Int?
//	let dutyStatus: Int
//	let busStatus: Int
//	let a2EventType: Int?
//	let GPSTime: String
//	let srcUpdateTime: String
//	let updateTime: String
//
//	enum CodingKeys: String, CodingKey {
//		case plateNumb = "PlateNumb"
//		case operatorID = "OperatorID"
//		case operatorNo = "OperatorNo"
//		case routeUID = "RouteUID"
//		case routeID = "RouteID"
//		case routeName = "RouteName"
//		case subRouteUID = "SubRouteUID"
//		case subRouteID = "SubRouteID"
//		case subRouteName = "SubRouteName"
//		case direction = "Direction"
//		case stopUID = "StopUID"
//		case stopID = "StopID"
//		case stopName = "StopName"
//		case stopSequence = "StopSequence"
//		case dutyStatus = "DutyStatus"
//		case busStatus = "BusStatus"
//		case a2EventType = "A2EventType"
//		case GPSTime = "GPSTime"
//		case srcUpdateTime = "SrcUpdateTime"
//		case updateTime = "UpdateTime"
//	}
//}
struct BusArrivalData: Codable {
	let plateNumb: String
	let operatorID: String
	let operatorNo: String
	let routeUID: String
	let routeID: String
	let routeName: RouteName
	let subRouteUID: String
	let subRouteID: String
	let subRouteName: RouteName
	let direction: Int
	let stopUID: String
	let stopID: String
	let stopName: StopName
	let stopSequence: Int
	let dutyStatus: Int
	let busStatus: Int?
	let a2EventType: Int
	let GPSTime: String
	let srcUpdateTime: String?
	let updateTime: String?

	enum CodingKeys: String, CodingKey {
		case plateNumb = "PlateNumb"
		case operatorID = "OperatorID"
		case operatorNo = "OperatorNo"
		case routeUID = "RouteUID"
		case routeID = "RouteID"
		case routeName = "RouteName"
		case subRouteUID = "SubRouteUID"
		case subRouteID = "SubRouteID"
		case subRouteName = "SubRouteName"
		case direction = "Direction"
		case stopUID = "StopUID"
		case stopID = "StopID"
		case stopName = "StopName"
		case stopSequence = "StopSequence"
		case dutyStatus = "DutyStatus"
		case busStatus = "BusStatus"
		case a2EventType = "A2EventType"
		case GPSTime = "GPSTime"
		case srcUpdateTime = "SrcUpdateTime"
		case updateTime = "UpdateTime"
	}
}
