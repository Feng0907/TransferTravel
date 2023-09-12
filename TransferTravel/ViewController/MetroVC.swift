//
//  MetroVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/12.
//

import UIKit

class MetroVC: UIViewController, UIScrollViewDelegate {
	
	@IBOutlet weak var mrtScrollView: UIScrollView!
	@IBOutlet weak var mrtImageView: UIImageView!
	@IBOutlet weak var tymetroImageView: UIImageView!
	
	var imageType = 0
	
	override func viewDidLoad() {
        super.viewDidLoad()
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			let mainWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
			let navBarHeight = navigationController?.navigationBar.frame.size.height{
			let statusBarHeight = mainWindow.windowScene?.statusBarManager?.statusBarFrame.height
			let screenWidth = UIScreen.main.bounds.width
			let screenHeight = UIScreen.main.bounds.height
			
			let totalHeight = navBarHeight + statusBarHeight!
			mrtScrollView.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenHeight)
		}
		self.mrtImageView.contentMode = .scaleAspectFit
		tymetroImageView.isHidden = true
		self.mrtScrollView.maximumZoomScale = 5
		self.mrtScrollView.minimumZoomScale = 1
		self.mrtScrollView.delegate = self

	}
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		if imageType == 0 {
			return mrtImageView
		} else {
			return tymetroImageView
		}
			
	}
		
	@IBAction func imageChanged(_ sender: Any) {
		switch (sender as AnyObject).selectedSegmentIndex {
		case 0:
			self.imageType = 0
			mrtImageView.isHidden = false
			tymetroImageView.isHidden = true
			break
		case 1:
			self.imageType = 1
			tymetroImageView.isHidden = false
			mrtImageView.isHidden = true
		
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
