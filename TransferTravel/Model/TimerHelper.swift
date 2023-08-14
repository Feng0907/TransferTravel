//
//  TimerHelper.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/13.
//
//
//import UIKit
//
//class TimerHelper{
//	
//	static let shared = TimerHelper()
//	private init(){}
//	
//	var timer : Timer?
//	var start_status : Bool = true
//	var millsecond = 0
//	var millsec = 0
//	var sec = 0
//	var min = 0
//	var hour = 0
//	var timing = "00:00:00:00"
//	
//	@objc
//	func timerAction(){
//		if start_status == false {
//			millsecond += 1
//			millsec = millsecond % 100
//			sec = (millsecond / 100) % 60
//			min = millsecond / 6000
//			hour = millsecond / 360000  //累加
//			let showmillsec = millsec > 9 ? "\(millsec)" : "0\(millsec)"
//			let showsec = sec > 9 ? "\(sec)" : "0\(sec)"
//			let showmin = min > 9 ? "\(min)" : "0\(min)"
//			let showhour = hour > 9 ? "\(hour)" : "0\(hour)"
//			timing = "\(showhour):\(showmin):\(showsec):\(showmillsec)"
//		}
//	}
//	
//	func startTimer(){
//		start_status = false  //這邊代表的是 ”Start“ Button 是不是還存在於畫面上，可以用它來將之後的其他功能做判斷依據
////		start_button.isHidden = true
////		stop_button.isHidden = false
////		loop_button.isHidden  = false
////		reset_button.isHidden = true
//		timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
//		
//		RunLoop.current.add(timer!, forMode: .common)  //切換線程，避免滑動 TabelView 的時候， Timer 會停止運作
//	}
//	
//	func stopTimer(){
//		start_status = true
////		start_button.isHidden = false
////		stop_button.isHidden = true
////		loop_button.isHidden  = true
////		reset_button.isHidden = false
//		timer?.invalidate()
//		
//	}
//	
//	
//}
