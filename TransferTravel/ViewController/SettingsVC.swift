//
//  SettingsVC.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/17.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

	let visionItem = VisionItem()
	
	@IBOutlet weak var settingsTableView: UITableView!
	
	required init?(coder: NSCoder) {
		super .init(coder: coder)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.navigationBar.isHidden = false
		self.settingsTableView.dataSource = self
		self.settingsTableView.delegate = self
        // Do any additional setup after loading the view.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "versionCell", for: indexPath)
		let item = self.visionItem
		cell.textLabel?.text = item.key
		cell.detailTextLabel?.text = item.value
		return cell
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
