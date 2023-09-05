//
//  SidebarVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/11.
//

import UIKit
import LGSideMenuController

class SidebarVC: LGSideMenuController {
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		leftViewPresentationStyle = .slideAboveBlurred
		rightViewPresentationStyle = .slideBelowShifted
	}
}


