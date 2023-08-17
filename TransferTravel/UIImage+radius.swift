//
//  UIImage+radius.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/17.
//

import UIKit

extension UIImage {
	func resize(maxEdge: CGFloat) -> UIImage? {
		
		// Check if it is necessary to resize?
		// 寬高都低於設定最大值的話就回傳原本的圖
		if self.size.width <= maxEdge && self.size.height <= maxEdge {
			return self
		}
		
		// 計算最終尺寸和比例
		// Calculate final size with aspect ratio.
		//維持比例是非常重要的
		let ratio = self.size.width / self.size.height
		let finalSize: CGSize
		if self.size.width > self.size.height {
			//橫的照片
			let finalHeight = maxEdge / ratio
			finalSize = CGSize(width: maxEdge, height: finalHeight)
			
		} else { //height >= width
			//直的或正方形照片
			let finalWidth = maxEdge * ratio
			finalSize = CGSize(width: finalWidth, height: maxEdge)
			
		}
		//匯出新的圖片
		// Export as UIImage.
		// 開始轉檔 指定一個Size
		// 形成一塊你指定尺寸的畫布(只是記憶體不是物件所以不會自動被回收)
		UIGraphicsBeginImageContext(finalSize) //C層次的api 需要小心記憶體管理的問題
		let rect = CGRect(origin: .zero, size: finalSize)
		// 把你要的圖在指定的畫布畫出來
		self.draw(in: rect) // 可以做疊圖效果 寫字效果
		let result = UIGraphicsGetImageFromCurrentImageContext()
		// 結束轉檔 要記得把畫布清掉
		UIGraphicsEndImageContext() // Important. 要把記憶體清掉不能存在這邊
		// 匯出結果
		return result
		
		
	}
	
//	func radius(rightRadiu: CGFloat, leftRadiu: CGFloat) -> {
//
//	}
}
