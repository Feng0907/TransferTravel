//
//  TabBarC.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/11.
//

import UIKit

class TabBarC: UITabBarController {

//	var upperLineView: UIView!
//	let spacing: CGFloat = 12

	 override func viewDidLoad() {
		 super.viewDidLoad()
		 self.delegate = self
//		 DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//			 self.addTabbarIndicatorView(index: 0, isFirstTime: true)
//
//		 }
	 }
	 ///Add tabbar item indicator uper line
//	 func addTabbarIndicatorView(index: Int, isFirstTime: Bool = false){
//		 guard let tabView = tabBar.items?[index].value(forKey: "view") as? UIView else {
//			 return
//		 }
//		 if !isFirstTime{
//			 upperLineView.removeFromSuperview()
//		 }
//		 upperLineView = UIView(frame: CGRect(x: tabView.frame.minX + spacing * 2, y: tabView.frame.minY + 0.1, width: tabView.frame.size.width - spacing * 4, height: 3))
//		 upperLineView.backgroundColor = UIColor.white
//		 tabBar.addSubview(upperLineView)
//	 }

}

@IBDesignable class TabBarWithCorners: UITabBar {
	@IBInspectable var color: UIColor?
	@IBInspectable var radii: CGFloat = 18
	
	private var shapeLayer: CALayer?
	
	override func draw(_ rect: CGRect) {
		addShape()
	}
	
	private func addShape() {
		let shapeLayer = CAShapeLayer()
			   
		shapeLayer.path = createPath()
		shapeLayer.strokeColor = UIColor(named: "MainLight")?.cgColor
		shapeLayer.fillColor =  color?.cgColor ?? UIColor(named: "mainDeepBlue2")?.cgColor
		shapeLayer.lineWidth = 1
		shapeLayer.shadowColor =  UIColor(named: "MainBlue")?.cgColor
		shapeLayer.shadowOffset = CGSize(width: 0, height: -2);
		shapeLayer.shadowOpacity = 0.21
//		shapeLayer.shadowRadius = 8
		shapeLayer.shadowPath =  UIBezierPath(roundedRect: bounds, cornerRadius: radii).cgPath

		if let oldShapeLayer = self.shapeLayer {
		   layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
		} else {
		   layer.insertSublayer(shapeLayer, at: 0)
		}

		self.shapeLayer = shapeLayer
	}
	
	private func createPath() -> CGPath {
		let path = UIBezierPath(
			roundedRect: bounds,
			byRoundingCorners: [.topLeft, .topRight],
			cornerRadii: CGSize(width: radii, height: 0.0))
		
		return path.cgPath
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.isTranslucent = true
		var tabFrame = self.frame

		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			let mainWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
			let statusBarHeight = mainWindow.windowScene?.statusBarManager?.statusBarFrame.height
			tabFrame.size.height = 45 + statusBarHeight!
			tabFrame.origin.y = self.frame.origin.y + self.frame.height - 43 - statusBarHeight!
		}
		
//		self.layer.cornerRadius = 18
		self.frame = tabFrame
		self.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -5.0) })
	}
	
}

extension TabBarC: UITabBarControllerDelegate {
//	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//		addTabbarIndicatorView(index: self.selectedIndex)
//	}
}
