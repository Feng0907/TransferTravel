//
//  String+codeUrl.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/6.
//

import Foundation

extension String {
	func encodeUrl() -> String? {
		return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
	}
	func decodeUrl() -> String? {
		return self.removingPercentEncoding
	}
}
