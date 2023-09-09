//
//  BusStopsTVCell.swift
//  TransferTravel
//
//  Created by Feng on 2023/9/9.
//

import UIKit

class BusStopsTVCell: UITableViewCell {

	@IBOutlet weak var busStopNameLabel: UILabel!
	@IBOutlet weak var busStopTimeLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
