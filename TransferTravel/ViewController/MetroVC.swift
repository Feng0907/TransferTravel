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
	
	var imageType = 0
	let taipeiMRTURL = "https://web.metro.taipei/pages/assets/images/routemap2023n.png"
	let tymetroURL = "https://www.tymetro.com.tw/tymetro-new/tw/_images/travel-guide/road_02-1_big.png"
	
	override func viewDidLoad() {
        super.viewDidLoad()
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			let mainWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
			let navBarHeight = navigationController?.navigationBar.frame.size.height{
			let statusBarHeight = mainWindow.windowScene?.statusBarManager?.statusBarFrame.height
			let screenWidth = UIScreen.main.bounds.width
			let screenHeight = UIScreen.main.bounds.height
			let x = screenWidth / 2
			
			let totalHeight = navBarHeight + statusBarHeight!
			mrtScrollView.frame = CGRect(x: x - mrtScrollView.frame.width/2, y: totalHeight, width: screenWidth, height: screenHeight)
		}
		
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
		
	@IBAction func imageChanged(_ sender: Any) {
		switch (sender as AnyObject).selectedSegmentIndex {
		case 0:
			mrtImageView.image = nil
			self.imageType = 0
			guard let url = URL(string: taipeiMRTURL)
				else{
					print("Invalid URL!")
					return
			}
			mrtImageView.load(url: url)
//			mrtImageView.isHidden = false
//			tymetroImageView.isHidden = true
//			self.mrtScrollView.contentOffset = .init(x: super.view.frame.width/2, y: super.view.frame.height/2)
			self.mrtScrollView.zoomScale = 1
			break
		case 1:
			mrtImageView.image = nil
			self.imageType = 1
			guard let url = URL(string: tymetroURL)
				else{
					print("Invalid URL!")
					return
			}
			mrtImageView.load(url: url)
//			self.mrtScrollView.contentOffset = .zero
//			self.mrtScrollView.contentOffset = .init(x: super.view.frame.width/2, y: super.view.frame.height/2)
			self.mrtScrollView.zoomScale = 1

			break
		default:
			break
		}
		
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
