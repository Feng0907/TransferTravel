//
//  UIVC+Alert.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/23.
//


import UIKit

extension UIViewController {
	func showAlert(message: String) {
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: .default)
		alert.addAction(ok)
		present(alert, animated: true)
	}
}
