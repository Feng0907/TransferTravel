//
//  IndexVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/7/29.
//

import UIKit
import WeatherKit
import CoreLocation
import LGSideMenuController


class IndexVC: UIViewController {
//	let spacing: CGFloat = 12
//	var upperLineView: UIView!
//	var timer: Timer?
//	var s : CGFloat = 1
	
	@IBOutlet weak var listBtnPressed: UIButton!
	@IBOutlet weak var busBtnPressed: UIButton!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tabBarController?.delegate = self
		self.navigationController?.navigationBar.isHidden = true
//		timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
//		RunLoop.current.add(timer!, forMode: .common)
//		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//			self.tabBarController?.addTabbarIndicatorView(index: 0)
//		}
		// Do any additional setup after loading the view.
//		print(BusCommunicator.shared.completionHandler)
		
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
