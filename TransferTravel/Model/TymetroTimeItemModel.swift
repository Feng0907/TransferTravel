//
//  TymetroTimeItemModel.swift
//  TransferTravel
//
//  Created by Feng on 2023/10/8.
//

import Foundation

class TymetroTimeItem{
	var departureTime = ""
	var arrivalTime = ""
	var travelTime = ""
	
	var type: type = .direct
	
	enum type: Int{
		case direct = 0
		case common = 1
	}
}
