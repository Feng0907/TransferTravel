//
//  DownloadImageView.swift
//  HelloHttpGet
//
//  Created by Feng on 2023/7/10.
//

import UIKit
import KRProgressHUD

//用繼承擴充UIImageView
class DownloadImageView: UIImageView {
	
	override init(frame: CGRect) {
		// override要先去呼叫爸爸(UIImageView)執行準備工作
		super.init(frame: frame) // 複寫
		
	}
	required init?(coder: NSCoder) {
		// 叫爸爸(UIImageView)完成自己底層的工作
		super.init(coder: coder)
	}
	
	func load(url: URL){
		let request = URLRequest(url: url)
		let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
			defer{
				DispatchQueue.main.async {
					KRProgressHUD.dismiss()
				}
			}
			if let error = error{
				print("Download Fail: \(error)")
			}
			guard let data = data else {
				return
			}
			let image = UIImage(data: data)
			DispatchQueue.main.async {
				self.image = image
			}
		}
		KRProgressHUD.show()
		task.resume()
	}

}
