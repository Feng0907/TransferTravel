//
//  TymetroCommunicator.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/28.
//

import Foundation
import Alamofire

typealias TymetroStationfCompletion = DoneHandler<[LineInfo]>
typealias TymetroTrainRouteCompletion = DoneHandler<[TrainRoute]>
typealias TymetroStationTravelTimeTableCompletion = DoneHandler<[StationTravelTimeTable]>
//typealias TymetroS2STravelTimeCompletion = DoneHandler<[TravelTime]>

class TymetroCommunicator {
	static let shared = TymetroCommunicator()
	private init(){}
	
	let token = BusCommunicator.shared.token
	
	static let baseURL = "https://tdx.transportdata.tw/"
	static let type = "TYMC"
	
	let stationOfLineUrl = baseURL + "api/basic/v2/Rail/Metro/StationOfLine/" + type
	//1.站到站行駛時間
	let travelTimeUrl = baseURL + "api/basic/v2/Rail/Metro/S2STravelTime/" + type
	//TravelTimes/any(tt: tt/FromStationID eq 'A3' and tt/ToStationID eq 'A1')
	//2.班距
	let frequencyUrl = baseURL + "api/basic/v2/Rail/Metro/Frequency/" + type
	//3.每站時刻表
	let stationTimeUrl = baseURL + "api/basic/v2/Rail/Metro/StationTimeTable/" + type
	//https://tdx.transportdata.tw/api/basic/v2/Rail/Metro/StationTimeTable/TYMC?%24filter=StationID%20eq%20%27A3%27&%24format=JSON
	//StationID eq 'A3'
	//StationID eq 'A1' and DestinationStaionID eq 'A5'
	
	//4.票價
	let fareUrl = baseURL + "api/basic/v2/Rail/Metro/ODFare/" + type

	//	_ StationID: String,
	func getTymetroStation(completion: @escaping TymetroStationfCompletion){
		let headers: HTTPHeaders = [
			"authorization": "Bearer \(self.token)"
		]
		let parameters: [String: Any] = ["$format": "JSON"]

		doGet(stationOfLineUrl, parameters: parameters, headers: headers, completion: completion)
	}
	
	func getS2STravelTime(from: String, to: String, completion: @escaping TymetroTrainRouteCompletion){
		let headers: HTTPHeaders = [
			"authorization": "Bearer \(self.token)"
		]
		let parameters: [String: Any] = ["$filter": "TravelTimes/any(tt: tt/FromStationID eq '\(from)' and tt/ToStationID eq '\(to)')","$format": "JSON"]

		doGet(travelTimeUrl, parameters: parameters, headers: headers, completion: completion)
	}
	
	func getStationTimeTable(from: String, completion: @escaping TymetroStationTravelTimeTableCompletion){
		let headers: HTTPHeaders = [
			"authorization": "Bearer \(self.token)"
		]
		let parameters: [String: Any] = ["$filter": "StationID eq '\(from)'","$format": "JSON"]

		doGet(stationTimeUrl, parameters: parameters, headers: headers, completion: completion)
	}
	
	private func doGet<type: Codable>(_ urlString: String,
					   parameters: [String: Any]?,
					   headers: HTTPHeaders?,
					   completion: @escaping DoneHandler<type>){
		AF.request(urlString,
			   method: .get,
			   parameters: parameters,
			   encoding: URLEncoding.default,
			   headers: headers)
		.validate()
		.responseDecodable(of: type.self) { (response: DataResponse<type, AFError>) in
			switch response.result {
			case .success(let result):
//				print("Success with: \(result)")
				completion(result, nil) //成功就會把解出來的result傳出說
			case .failure(let error):
				print("Fail with: \(error)")
				completion(nil, error) //失敗就讓他把回傳值變成nil並印出error
			}
		}
	}
}

struct LineInfo: Codable {
	let lineNo: String
	let lineID: String
	let stations: [TymetroStation]
	let srcUpdateTime: String
	let updateTime: String
	let versionID: Int
	
	enum CodingKeys: String, CodingKey {
		case lineNo = "LineNo"
		case lineID = "LineID"
		case stations = "Stations"
		case srcUpdateTime = "SrcUpdateTime"
		case updateTime = "UpdateTime"
		case versionID = "VersionID"
	}
}

struct TymetroStation: Codable {
	let sequence: Int
	let stationID: String
	let stationName: StationName
	let cumulativeDistance: Double?
	
	enum CodingKeys: String, CodingKey {
		case sequence = "Sequence"
		case stationID = "StationID"
		case stationName = "StationName"
		case cumulativeDistance = "CumulativeDistance"
	}
}

struct StationName: Codable {
	let zhTw: String
	let en: String
	
	enum CodingKeys: String, CodingKey {
		case zhTw = "Zh_tw"
		case en = "En"
	}
}

struct TrainRoute: Codable {
	let lineNo: String
	let lineID: String
	let routeID: String
	let trainType: Int
	let travelTimes: [TravelTime]
	let srcUpdateTime: String
	let updateTime: String
	let versionID: Int

	enum CodingKeys: String, CodingKey {
		case lineNo = "LineNo"
		case lineID = "LineID"
		case routeID = "RouteID"
		case trainType = "TrainType"
		case travelTimes = "TravelTimes"
		case srcUpdateTime = "SrcUpdateTime"
		case updateTime = "UpdateTime"
		case versionID = "VersionID"
	}
}

struct TravelTime: Codable {
	let sequence: Int
	let fromStationID: String
	let fromStationName: StationName
	let toStationID: String
	let toStationName: StationName
	let runTime: Int
	let stopTime: Int?

	enum CodingKeys: String, CodingKey {
		case sequence = "Sequence"
		case fromStationID = "FromStationID"
		case fromStationName = "FromStationName"
		case toStationID = "ToStationID"
		case toStationName = "ToStationName"
		case runTime = "RunTime"
		case stopTime = "StopTime"
	}
}

struct StationTravelTimeTable: Codable {
	let routeID: String
	let lineID: String
	let stationID: String
	let stationName: StationName
	let direction: Int
	let destinationStationID: String
	let destinationStationName: StationName
	let timetables: [Timetable]
	let serviceDay: ServiceDay
	let specialDays: [SpecialDay]?
	let srcUpdateTime: String
	let updateTime: String
	let versionID: Int

	enum CodingKeys: String, CodingKey {
		case routeID = "RouteID"
		case lineID = "LineID"
		case stationID = "StationID"
		case stationName = "StationName"
		case direction = "Direction"
		case destinationStationID = "DestinationStaionID"
		case destinationStationName = "DestinationStationName"
		case timetables = "Timetables"
		case serviceDay = "ServiceDay"
		case specialDays = "SpecialDays"
		case srcUpdateTime = "SrcUpdateTime"
		case updateTime = "UpdateTime"
		case versionID = "VersionID"
	}
}
struct Timetable: Codable {
	let sequence: Int
	let trainNo: String?
	let arrivalTime: String
	let departureTime: String
	let trainType: Int

	enum CodingKeys: String, CodingKey {
		case sequence = "Sequence"
		case trainNo = "TrainNo"
		case arrivalTime = "ArrivalTime"
		case departureTime = "DepartureTime"
		case trainType = "TrainType"
	}
}

struct ServiceDay: Codable {
	let serviceTag: String
	let monday: Bool
	let tuesday: Bool
	let wednesday: Bool
	let thursday: Bool
	let friday: Bool
	let saturday: Bool
	let sunday: Bool
	let nationalHolidays: Bool

	enum CodingKeys: String, CodingKey {
		case serviceTag = "ServiceTag"
		case monday = "Monday"
		case tuesday = "Tuesday"
		case wednesday = "Wednesday"
		case thursday = "Thursday"
		case friday = "Friday"
		case saturday = "Saturday"
		case sunday = "Sunday"
		case nationalHolidays = "NationalHolidays"
	}
}

struct SpecialDay: Codable {
	let saturdayDate: String
	let endDate: String
	let description: String

	enum CodingKeys: String, CodingKey {
		case saturdayDate = "SaterDate"
		case endDate = "EndDate"
		case description = "Description"
	}
}

