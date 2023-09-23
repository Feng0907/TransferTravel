//
//  BusSearchTableVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/4.
//

import UIKit
import KRProgressHUD

class BusSearchTableVC: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
	
//	@IBOutlet var searchController: UISearchBar!
	var filteredData = [BusRouteInfoResult]()
	var searchController = UISearchController(searchResultsController: nil)
	var citiesArr: [CityResult]?
	var cityName = ""
	var searchTimer: Timer?
	
	let queryQueue = DispatchQueue(label: "QueryQueue")
	
//	let activityIndicator = KRActivityIndicatorView()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		queryCity()
		setSearchBar(searchController)
		self.navigationItem.searchController = self.searchController
		self.searchController.searchResultsUpdater = self
		self.searchController.searchBar.delegate = self
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	override func viewDidAppear(_ animated: Bool) {
		setPlaceholderLabelColor(searchController)
	}
	
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		if viewController == self && navigationController.viewControllers.count > 1 {
			print("返回按鈕被點擊了")
		}
	}
	
	func setSearchBar(_ searchController : UISearchController){
		searchController.searchBar.placeholder = "請輸入想搜尋的公車"
		searchController.searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
		searchController.searchBar.searchTextField.textColor = .white
		searchController.searchBar.searchTextField.leftView?.tintColor = .white
		searchController.searchBar.searchTextField.rightView?.tintColor = .white
		searchController.searchBar.barStyle = .black
		searchController.searchBar.tintColor = .white
		if let clearButton = searchController.searchBar.searchTextField.value(forKey: "clearButton") as? UIButton {
				clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
				clearButton.tintColor = .white // 设置清除按钮颜色为白色
			}
	}
	
	func setPlaceholderLabelColor(_ searchController : UISearchController){
		if let placeholderLabel = searchController.searchBar.searchTextField.value(forKey: "placeholderLabel") as? UILabel {
				placeholderLabel.textColor = UIColor.white.withAlphaComponent(0.6)
			}
	}
	
	@IBAction func menuBtn(_ sender: Any) {
		sideMenuController?.toggleLeftView(animated: true)
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
	
	func queryCity(){
		BusCommunicator.shared.getCity { (result, error) in
			if let result = result {
//				print("Success with cities: \(result)")
				self.citiesArr = result
			} else if let error = error {
				print("Fail with: \(error)")
			} else {
				print("No data received")
			}
		}
	}
	
	//MARK:searchResultsUpdater
	func updateSearchResults(for searchController: UISearchController) {
		
		guard let searchText = self.searchController.searchBar.text else {
			print("請輸入想找的路線")
			return
		}
		searchTimer?.invalidate()
		
		searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [self] _ in
			if searchText.count > 1 && searchText.count <= 6 {
//				view.addSubview(self.activityIndicator)
//				self.activityIndicator.startAnimating()
				KRProgressHUD.show()
				self.queryQueue.async {
					let searchTextEncode = searchText.encodeUrl() ?? ""
					self.performSearch(searchText: searchTextEncode)
					
				}
				
			} else {
//				self.activityIndicator.stopAnimating()
				KRProgressHUD.dismiss()
			}
		}
	}
	
	
	func performSearch(searchText: String) {

		guard let cities = self.citiesArr else {
			return
		}
		var resultCount = 0
		let busResultGroup = DispatchGroup() // 創建 DispatchGroup
//		defer{
//			print("222  \(resultCount)")
//			if resultCount == 0 {
//				print("123\(self.filteredData)")
//				DispatchQueue.main.async {
//					self.activityIndicator.stopAnimating()
//					self.showAlert(message: "查無所搜尋路線")
//				}
//			}
//		}
		for city in cities {
			cityName = city.city
			busResultGroup.enter()
			BusCommunicator.shared.getBusRouteInfo(searchText, city: cityName) { result, error in
				defer{
					DispatchQueue.main.async {
						KRProgressHUD.dismiss()
//						self.activityIndicator.stopAnimating()
//						self.activityIndicator.hidesWhenStopped = true
					}
					busResultGroup.leave()
				}
				
				if let error = error {
					print("getBusRouteInfo Error: \(error)")
//					self.showAlert(message: "查無所搜尋路線")
//						self.searchController.searchBar.text? = ""
					self.tableView.reloadData()
					return
				}
				
				guard let data = result else {
					print("result error")
//					self.showAlert(message: "查無所搜尋路線")
					self.searchController.searchBar.text? = ""
					return
				}

				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
				
				resultCount += data.count
				self.filteredData += data
			}
		}
		busResultGroup.notify(queue: DispatchQueue.main) {
			if resultCount == 0 {
				self.showAlert(message: "查無所搜尋路線")
			}
		}
	}
	
	func cityEnToZn(enCityName: String) -> String? {
		let selectCityArr = self.citiesArr?.filter{ $0.city == enCityName }
		let currectCity = selectCityArr?[0]
		return currectCity?.cityName
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		self.filteredData = []
		self.tableView.reloadData()
	}
	

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.filteredData.count != 0 {
			return self.filteredData.count
		} else {
			return 1
		}
    }
	

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if filteredData.count != 0 {
			tableView.separatorStyle = .singleLine
			let item = filteredData[indexPath.row]
			guard let selfcell = tableView.dequeueReusableCell(withIdentifier: "searchRusRoute", for: indexPath) as? searchRusRouteTVCell else{
			   fatalError("請確認storybord上有設定customcell")
			}
			selfcell.routeNumLabel?.text = item.routeName.zhTw
			selfcell.routeStartEndLabel?.text = item.departureStopNameZh != nil ? item.departureStopNameZh! + " - " + item.destinationStopNameZh : item.destinationStopNameZh + " - " + item.destinationStopNameZh
			let cityNameZn = cityEnToZn(enCityName: item.city)
			selfcell.routeCityLabel?.text = cityNameZn
			return selfcell
		} else {
			tableView.separatorStyle = .none
			let cell = tableView.dequeueReusableCell(withIdentifier: "searchNone", for: indexPath)
			return cell
		}
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "busRouteListSegue",
		   let BusRouteVC = segue.destination as? BusRouteVC,
		   let index = self.tableView.indexPathForSelectedRow {
			let item = self.filteredData[index.row]
//			print(item)
			BusInfoSendHelper.shared.SendBusInfo = item
			BusRouteVC.busInfo = BusInfoSendHelper.shared.SendBusInfo
		}
	}


}
