//
//  TymetroImageVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/10/9.
//

import UIKit

class TymetroImageVC: UIViewController, UIScrollViewDelegate {

	@IBOutlet weak var mrtScrollView: UIScrollView!
	@IBOutlet weak var mrtImageView: DownloadImageView!
	let tymetroURL = "https://www.tymetro.com.tw/tymetro-new/tw/_images/travel-guide/road_02-1_big.png"
	
	var originalContentOffset: CGPoint = .zero
	override func viewDidLoad() {
        super.viewDidLoad()
		scrollViewConfig()
		guard let url = URL(string: tymetroURL)
			else{
				print("Invalid URL!")
				return
		}
		self.mrtImageView.load(url: url)
		self.mrtImageView.contentMode = .scaleAspectFit
		self.mrtScrollView.maximumZoomScale = 5
		self.mrtScrollView.minimumZoomScale = 1
		self.mrtScrollView.contentOffset.y = .zero
		self.mrtScrollView.delegate = self
        // Do any additional setup after loading the view.
    }
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return mrtImageView
	}
	
	func scrollViewConfig(){
		guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
		   let mainWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
		   let navBarHeight = navigationController?.navigationBar.frame.size.height else{
			print("error for catch window Size")
			return
		}
		let statusBarHeight = mainWindow.windowScene?.statusBarManager?.statusBarFrame.height
		let screenWidth = UIScreen.main.bounds.width
//		let screenHeight = UIScreen.main.bounds.height
		let x = screenWidth / 2
		let totalHeight = navBarHeight + statusBarHeight!
		let scrollHeight = self.mrtScrollView.frame.height - statusBarHeight!
		self.mrtScrollView.frame = CGRect(x: x - mrtScrollView.frame.width / 2, y: totalHeight, width: screenWidth + 1, height: scrollHeight)
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
