//
//  WeatherCommunicator.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/26.
//

import Foundation
import Alamofire

typealias StationCompletion = DoneHandler<StationData>
typealias WeatherCompletion = DoneHandler<WeatherData>

class WeatherCommunicator{
	static let shared = WeatherCommunicator()
	private init(){}
	
	static var weatherToken : String {
		return try! "AwEXcL7Vld/cKUnXutmd1ZLwfrPbVDVYHmb8ysUYEMLG7y5C+CDmPoZN4M7oRuHMAoIl8JkhhgrZRYnaFI2JZsSNT90J8KOj7u4WsVFkcDDqmJ6bHwozP0JiVSMnLK/vEcNQlAhFzr+WVFvaYTpp2vSZ".decryprBase64(key: masterKey)!
	}
	
	static let baseURL = "https://opendata.cwb.gov.tw/"
	
	let weatherStationURL = baseURL + "api/v1/rest/datastore/C-B0074-002"
	let weatherURL = baseURL + "api/v1/rest/datastore/O-A0001-001"

	func getStation(completion: @escaping StationCompletion) {
		let parameters: [String: Any] = ["Authorization": WeatherCommunicator.weatherToken, "$format": "JSON", "status": "現存測站"]
		doGet(weatherStationURL, parameters: parameters, completion: completion)
	}
	func getWeatherInfo(stationId: String, completion: @escaping WeatherCompletion) {
		let parameters: [String: Any] = ["Authorization": WeatherCommunicator.weatherToken, "$format": "JSON","stationId": stationId, "elementName": "", "parameterName": ""]
		doGet(weatherURL, parameters: parameters, completion: completion)
	}
	
	private func doGet<type: Codable>(_ urlString: String,
					   parameters: [String: Any]?,
					   completion: @escaping DoneHandler<type>){
		AF.request(urlString,
					   method: .get,
					   parameters: parameters,
					   encoding: URLEncoding.default)
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
//		print("End of doGet()")
	}
}

struct StationData: Codable {
	let success: String
	let result: Result
	let records: Records
}

struct Result: Codable {
	let resource_id: String
	let fields: [Field]
	enum CodingKeys: String, CodingKey {
		case resource_id, fields
	}
	struct Field: Codable {
		let id: String
		let type: String
	}
}

struct Records: Codable {
	let data: RecordsData
	enum CodingKeys: String, CodingKey {
		case data = "data"
	}

}
struct RecordsData: Codable {
	let stationStatus: StationStatus
	enum CodingKeys: String, CodingKey {
		case stationStatus = "stationStatus"
	}
}

struct StationStatus: Codable {
	let station: [Station]
	enum CodingKeys: String, CodingKey {
		case station
	}
}

struct Station: Codable {
	let status: String
	let stationID: String
	let stationName: String
	let stationNameEN: String?
	let stationAltitude: Float?
	let stationLongitude: Double
	let stationLatitude: Double
	let countyName: String?
	let location: String?
	let stationStartDate: String?
	let stationEndDate: String?
	let notes: String?
	let originalStationID: String?
	let newStationID: String?
	
	enum CodingKeys: String, CodingKey {
		case status
		case stationID = "StationID"
		case stationName = "StationName"
		case stationNameEN = "StationNameEN"
		case stationAltitude = "StationAltitude"
		case stationLongitude = "StationLongitude"
		case stationLatitude = "StationLatitude"
		case countyName = "CountyName"
		case location = "Location"
		case stationStartDate = "StationStartDate"
		case stationEndDate = "StationEndDate"
		case notes = "Notes"
		case originalStationID = "OriginalStationID"
		case newStationID = "NewStationID"
	}
}

struct WeatherData: Codable {
	let success: String
	let result: Result
	let records: Records

	struct Records: Codable {
		let location: [Location]
	}
	
	enum CodingKeys: String, CodingKey {
		case success, result, records
	}
}

struct Location: Codable {
	let lat: String
	let lon: String
	let locationName: String
	let stationId: String
	let time: Time
	let weatherElement: [WeatherElement]
	let parameter: [Parameter]

	enum CodingKeys: String, CodingKey {
		case lat, lon, locationName, stationId, time, weatherElement, parameter
	}
}

struct Time: Codable {
	let obsTime: String
	
	enum CodingKeys: String, CodingKey {
		case obsTime = "obsTime"
	}
}

struct WeatherElement: Codable {
	let elementName: String
	let elementValue: String
	
	enum CodingKeys: String, CodingKey {
		case elementName, elementValue
	}
}

struct Parameter: Codable {
	let parameterName: String
	let parameterValue: String
	
	enum CodingKeys: String, CodingKey {
		case parameterName, parameterValue
	}
}
