//
//  String+RNCryptor.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/17.
//

import Foundation
import RNCryptor

extension String {
	
	func decryprBase64(key: String) throws -> String? {
		guard let encryptedData = Data(base64Encoded: self) else {
			print("Fail to convert from base64.")
			return nil
		}
		let originalData = try RNCryptor.decrypt(data: encryptedData, withPassword: key)
		return String(data: originalData, encoding: .utf8)

	}

	func encryptBase64(key: String) -> String? {
		guard let data = self.data(using: .utf8) else {
			assertionFailure("Fail to convert to Utf8 data.")
			return nil
		}
		let encryptedData = RNCryptor.encrypt(data: data, withPassword: key)
		return encryptedData.base64EncodedString()
	}
}
