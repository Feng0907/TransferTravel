//
//  RouteModel.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/3.
//

import Foundation
import UIKit
import CoreData

class RouteItem: NSManagedObject{
	@NSManaged var routeName : String
	@NSManaged var routeID: Int
	
	
}

