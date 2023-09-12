//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

//enum SideViewCellItem: Equatable {
//	case pushVC(title: String)
//
//	var description: String {
//		switch self {
//		case let .pushVC(title):
//			return title
//		}
//	}
//}

class SideViewCellItem{
	var title: String = ""
	var pageID: String = ""
	var VC: UINavigationController = UINavigationController()
}

private let cellIdentifier = "cell"
private let tableViewInset: CGFloat = 44.0 * 2.0
private let cellHeight: CGFloat = 50.0

class LeftViewController: UITableViewController {
	private var sections = [SideViewCellItem]()
//    private let sections: [SideViewCellItem] = [
//		.pushVC(title: "我的路線"),
//         .pushVC(title: "公車路線"),
//         .pushVC(title: "台北捷運"),
//         .pushVC(title: "設定"),
//         .pushVC(title: "聯繫我們")
//    ]
	func addMenu(pageTitle newtitle: String, pageID newPage: String, VC ViewController: UINavigationController) {
		let item = SideViewCellItem()
		item.title = newtitle
		item.pageID = newPage
		item.VC = ViewController
		sections.append(item)
	}
    required init?(coder: NSCoder) {
        super.init(coder: coder)
		addMenu(pageTitle: "我的路線", pageID: "ListNaviC", VC: RouteListNaviVC())
		addMenu(pageTitle: "公車路線", pageID: "BusRouteNaviC", VC: BusNaviVC())
		addMenu(pageTitle: "台北捷運", pageID: "taipeiMRT", VC: BusNaviVC())
		addMenu(pageTitle: "設定", pageID: "setting", VC: BusNaviVC())
		addMenu(pageTitle: "聯繫我們", pageID: "contUS", VC: BusNaviVC())
    }
	

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(LeftViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: tableViewInset, left: 0.0, bottom: tableViewInset, right: 0.0)
        tableView.showsVerticalScrollIndicator = false
		tableView.backgroundColor = UIColor(named: "MainBlue")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentOffset = CGPoint(x: 0.0, y: -tableViewInset)
		
    }

    // MARK: - UITableViewDataSource -

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LeftViewCell
        let item = sections[indexPath.row]
		cell.textLabel!.text = item.title
        cell.isFirst = (indexPath.row == 0)
        cell.isLast = (indexPath.row == sections.count - 1)
        cell.isFillColorInverted = sideMenuController?.leftViewPresentationStyle == .slideAboveBlurred

        return cell
    }
	
	func push(VC: UINavigationController){
		
//		let storyboard = UIStoryboard(name: "Main", bundle: nil)
//		let controller = storyboard.instantiateViewController.(withIdentifier: String)
//		else {
//			print("error storyboard id.")
//			return
//		}
		navigationController?.pushViewController(VC, animated: true)
//		navigationController?.pushViewController(controller, animated: true)
	}
	
	func pageGO(id: String, VC: UINavigationController){
		guard let sideMenuController = sideMenuController else { return }
		let alert = UIAlertController(title: "功能施工中", message: "菜鳥努力中請稍等", preferredStyle: .alert)
		let cancel = UIAlertAction(title: "OK", style: .cancel){_ in sideMenuController.hideLeftView(animated: true)}
		alert.addAction(cancel)
		if id != "ListNaviC" && id != "BusRouteNaviC"{
			present(alert, animated: true)
			return
		}
//		guard let tabBar = storyboard?.instantiateViewController(withIdentifier: "tabBar") else { return }
//		guard let page = storyboard?.instantiateViewController(withIdentifier: id) else {
//			present(alert, animated: true)
//			assertionFailure("Invalid pageID.")
//			return
//		}
		guard let page = storyboard?.instantiateViewController(withIdentifier: id) else {
			present(alert, animated: true)
			assertionFailure("Invalid pageID.")
			return
		}
		print(id)
//		navigationController?.pushViewController(VC, animated: true)
//		navigationController?.pushViewController(page, animated: true)
//		sideMenuController.hideLeftView(animated: true)
//		push(VC: VC)
		// 獲取 UITabBarController 的引用
//		if let tabBarController = self.tabBarController {
//			let selectedIndex = tabBarController.selectedIndex
//			tabBarController.viewControllers?[selectedIndex] = VC
//			tabBarController.selectedIndex = selectedIndex
//		}
//		page.addChild()
		self.navigationController?.pushViewController(page, animated: true)
//		sideMenuController.rootViewController = VC
		sideMenuController.rootViewController = page
//		self.navigationController?.pushViewController(VC, animated: true)
//		sideMenuController.rootViewController = page
		

		sideMenuController.hideLeftView(animated: true)

	}
    // MARK: - UITableViewDelegate -

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.row]
		pageGO(id: item.pageID, VC: item.VC)
		
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        return cellHeight / 2.0
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }

}
