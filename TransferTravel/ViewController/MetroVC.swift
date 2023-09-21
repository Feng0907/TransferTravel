//
//  MetroVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/12.
//

import UIKit

class MetroVC: UIViewController, UIScrollViewDelegate {
	
	@IBOutlet weak var mrtScrollView: UIScrollView!
	@IBOutlet weak var mrtImageView: DownloadImageView!
	@IBOutlet weak var navSegmenteView: UIView!
	@IBOutlet weak var segmentMRTChange: UISegmentedControl!
	
	var imageType = 0
	let taipeiMRTURL = "https://web.metro.taipei/pages/assets/images/routemap2023n.png"
	let tymetroURL = "https://www.tymetro.com.tw/tymetro-new/tw/_images/travel-guide/road_02-1_big.png"
	
	var originalContentOffset: CGPoint = .zero
	
	override func viewDidLoad() {
        super.viewDidLoad()
		segmentConfig()
		scrollViewConfig(caseNum: 0)
		guard let url = URL(string: taipeiMRTURL)
			else{
				print("Invalid URL!")
				return
		}
		self.mrtImageView.load(url: url)
		self.mrtImageView.contentMode = .scaleAspectFit
		self.mrtScrollView.maximumZoomScale = 5
		self.mrtScrollView.minimumZoomScale = 1
		self.mrtScrollView.delegate = self
	}
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return mrtImageView
	}
	
	func scrollViewConfig(caseNum: Int){
		guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
		   let mainWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
		   let navBarHeight = navigationController?.navigationBar.frame.size.height else{
			print("error for catch window Size")
			return
		}
		let statusBarHeight = mainWindow.windowScene?.statusBarManager?.statusBarFrame.height
		let screenWidth = UIScreen.main.bounds.width
		let screenHeight = UIScreen.main.bounds.height
		let x = screenWidth / 2
		let totalHeight = navBarHeight + statusBarHeight!
		let y = totalHeight + 50
		let scrollHeight = self.mrtScrollView.frame.height - statusBarHeight!
		switch caseNum {
		case 0 :
			self.navSegmenteView.frame = CGRect(x: x - mrtScrollView.frame.width / 2, y: totalHeight, width: screenWidth, height: 50)
			self.mrtScrollView.frame = CGRect(x: x - mrtScrollView.frame.width / 2, y: y, width: screenWidth, height: scrollHeight)
			break
		case 1 :
			self.mrtScrollView.frame = CGRect(x: x - mrtScrollView.frame.width / 2, y: y - 25, width: screenWidth, height: scrollHeight)

			break
		case 2 :
			self.mrtScrollView.frame = CGRect(x: x - mrtScrollView.frame.width / 2, y: y + self.navSegmenteView.frame.height, width: screenWidth, height: scrollHeight)
			break
		default:
			return
		}
		
	}
		
	@IBAction func imageChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:

			self.mrtImageView.contentMode = .scaleAspectFit
			mrtImageView.image = nil
			self.imageType = 0
			guard let url = URL(string: taipeiMRTURL)
				else{
					print("Invalid URL!")
					return
			}
			
			mrtImageView.load(url: url)
			self.mrtScrollView.contentOffset.y = .zero
			self.mrtScrollView.zoomScale = 1
			break
		case 1:
			self.mrtImageView.contentMode = .scaleAspectFit
			mrtImageView.image = nil
			self.imageType = 1
			guard let url = URL(string: tymetroURL)
				else{
					print("Invalid URL!")
					return
			}
			
			mrtImageView.load(url: url)
			self.mrtScrollView.contentOffset.y = .zero
			self.mrtScrollView.zoomScale = 1

			break
		default:
			break
		}
		
	}
	
	func segmentConfig(){
		
		let normalTextAttributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.white
		]
		self.segmentMRTChange.setTitleTextAttributes(normalTextAttributes, for: .normal)
		let selectedTextAttributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.white
		]
		self.segmentMRTChange.setTitleTextAttributes(selectedTextAttributes, for: .selected)
	}
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
