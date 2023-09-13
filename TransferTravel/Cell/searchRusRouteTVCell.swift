//
//  searchRusRouteTVCell.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/12.
//

import UIKit

class searchRusRouteTVCell: UITableViewCell {

	@IBOutlet weak var routeNumLabel: UILabel!
	@IBOutlet weak var routeStartEndLabel: UILabel!
	@IBOutlet weak var routeCityLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
