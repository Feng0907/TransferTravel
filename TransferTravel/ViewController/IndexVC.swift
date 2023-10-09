//
//  IndexVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/7/29.
//

import UIKit
import CoreLocation

class IndexVC: UIViewController {
	let locationManager = CLLocationManager()
	var userLocation: CLLocation?
	var allStations = [Station]()
	var closesStation: Station? = nil
	var stationID = ""
//	let spacing: CGFloat = 12
//	var upperLineView: UIView!
	var timer: Timer?
//	var s : CGFloat = 1
	
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var weatherLabel: UILabel!
	@IBOutlet weak var humidityLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var weatherImageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tabBarController?.delegate = self
		self.navigationController?.navigationBar.isHidden = true
		//Request Permission要求授權取得使用者定位
		locationManager.requestWhenInUseAuthorization()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startUpdatingLocation()
//		guard let currentLocation = locationManager.location else{
//			return
//		}
//		print("Lat:\(currentLocation.coordinate.latitude), Lon: \(currentLocation.coordinate.longitude)")
		
//		timer?.invalidate()
//		timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(searchWeatherStation), userInfo: nil, repeats: true)
//		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//			self.tabBarController?.addTabbarIndicatorView(index: 0)
//		}
		// Do any additional setup after loading the view.
//		print(BusCommunicator.shared.completionHandler)
		
		self.searchWeatherStation()
		locationManager.stopUpdatingLocation()
		
	}
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.navigationBar.isHidden = true
	}
	
	
	@IBAction func listBtnPressed(_ sender: Any) {
		if let tabBarController = self.tabBarController{
			tabBarController.selectedIndex = 1
		}
//		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//			self.tabBarController?.addTabbarIndicatorView(index: 1)
//		}
	}
	@IBAction func busBtnPressed(_ sender: Any) {
		if let tabBarController = self.tabBarController{
			tabBarController.selectedIndex = 2
		}
	}
	@IBAction func mrtBtnPressed(_ sender: Any) {
		if let tabBarController = self.tabBarController{
			tabBarController.selectedIndex = 3
		}
	}
	
	@IBAction func TymetroBtnPressed(_ sender: Any) {
		if let tabBarController = self.tabBarController{
			tabBarController.selectedIndex = 4
		}
	}
	
	@IBAction func settingBtnPressed(_ sender: Any) {
		let storyboard = UIStoryboard(name: "Setting", bundle: nil)
		if let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as? SettingsVC {
			self.navigationController?.pushViewController(settingsVC, animated: true)
		}
		
	}
	
	func searchWeatherStation(){
		WeatherCommunicator.shared.getStation { result, error in
			if let error = error {
				print("Fail with: \(error)")
				return
			}
			
			guard let result = result else {
				print("result error")
				return
			}
			let data = result.records.data
			let stations = data.stationStatus.station
			self.allStations = stations
//			print(stations)
			guard let closesStation = self.findClosesStation() else {
//				assertionFailure("Error to find closesStation.")
				print("Error to find closesStation.")
				return
			}
			let stationID = closesStation.stationID
//			print(closesStation)
//			print(stationID)
			self.weatherShow(stationId: stationID)
		}
	}
	
	func findClosesStation() -> Station? {
		guard let userLocation = self.userLocation else {
			return nil
		}
		var closesDistance: CLLocationDistance = Double.infinity
		var closesStation: Station?
		
		for station in allStations {
			let stationCLLocation = CLLocation(latitude: station.stationLatitude, longitude: station.stationLongitude)
			let distance = userLocation.distance(from: stationCLLocation)
			if distance < closesDistance {
				closesDistance = distance
				closesStation = station
			}
		}
		return closesStation
	}
	
	func weatherShow(stationId: String){
		WeatherCommunicator.shared.getWeatherInfo(stationId: stationId) { result, error in
			if let error = error {
				print("Fail with: \(error)")
				return
			}
			
			guard let result = result else {
				print("result error")
				return
			}
			let data = result.records.location
//			print("data \(data)")
			guard let weatherElement = data.first?.weatherElement else {
				return
			}
//			print("weatherInfo \(weatherElement)")
//			print("weatherParameter \(weatherParameter)")
			let weatherString = self.getElementValue(for: "Weather", in: weatherElement)
			self.weatherLabel.text = weatherString
			if let humidity = Double(self.getElementValue(for: "HUMD", in: weatherElement)){
				let humidityPercent = Int(humidity * 100)
				self.humidityLabel.text = "降雨機率 \(humidityPercent)%"
			}
			if let temperatureStr = Double(self.getElementValue(for: "TEMP", in: weatherElement)) {
				let roundedNumber = round(temperatureStr)
				let temperature = Int(roundedNumber)
				self.temperatureLabel.text = String(temperature) + "°C"
			}
			
			self.weatherImageView.image = self.setWeatherImage(weather: weatherString)
		}
	}
	
	func getElementValue(for elementName: String, in weatherElements: [WeatherElement]) -> String {
		if let weatherElement = weatherElements.first(where: { $0.elementName == elementName }) {
			return weatherElement.elementValue != "-99" ? weatherElement.elementValue : "--"
		} else {
			return "--"
		}
	}
	
	func setWeatherImage(weather: String) -> UIImage{
		switch weather {
		case "晴":
			return UIImage(systemName: "sun.max")!
		case "多雲":
			return UIImage(systemName: "cloud.sun")!
		case "陰":
			return UIImage(systemName: "cloud")!
		default:
			return UIImage(systemName: "cloud.sun")!
		}
	}

	//	@objc
//	func timerAction(){
//		s += 1
//		print(s)
//		self.listBtnPressed.transform = CGAffineTransform(rotationAngle: .pi/5 * s)
//		timer.invalidate()
//	}
	

}

extension IndexVC: UITabBarControllerDelegate {
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//		self.tabBarController?.addTabbarIndicatorView(index: self.tabBarController!.selectedIndex)
	}
}

extension IndexVC: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
			switch status {
			case .authorizedWhenInUse:
				locationManager.startUpdatingLocation()
				self.searchWeatherStation()
				locationManager.stopUpdatingLocation()
			case .authorizedAlways:
				locationManager.startUpdatingLocation()
				self.searchWeatherStation()
				locationManager.stopUpdatingLocation()
			case .denied, .restricted: break
				// 用户拒绝或限制了位置访问权限，您可以在此处理相应的逻辑，例如向用户解释为何需要位置访问权限
			default:
				break
			}
		}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let currentLocation = locations.last else{
			return
		}
		self.userLocation = currentLocation
//		print("Lat:\(currentLocation.coordinate.latitude), Lon: \(currentLocation.coordinate.longitude)")
		
		let geocoder = CLGeocoder()
		let twLocal = Locale(identifier: "zh_Hant_TW")//設定指定語言
		geocoder.reverseGeocodeLocation(currentLocation, preferredLocale: twLocal) { placemarks, error in
			if let error = error{
				print("geocodeAddressString fail: \(error)")
				return
			}
			guard let placemarks = placemarks?.first else{
				assertionFailure("Invalid placemark")
				return
			}
			//可以印出的資料很多 包含郵遞區號 國碼等
//			let postCode = placemarks.postalCode ?? "n/a"
//			let countryCode = placemarks.isoCountryCode ?? "n/a"
//			let description = placemarks.description
			guard let area = placemarks.locality else {
				return
			}
//			print("\(postCode) \(countryCode) \(description) \(city)")
			self.cityLabel.text = "\(area)"
//			print("縣市名稱：\(city) \(area)")
		}
	}
	
}
