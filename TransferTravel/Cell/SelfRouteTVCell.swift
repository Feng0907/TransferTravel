//
//  SelfRouteTVCell.swift
//  TransferTravel
//
//  Created by Feng on 2023/8/14.
//

import UIKit

class SelfRouteTVCell: UITableViewCell {

	@IBOutlet weak var selfIconImage: UIImageView!
	@IBOutlet weak var startPointName: UILabel!
	@IBOutlet weak var endPointName: UILabel!
	
//	@IBOutlet weak var timeShow: UIButton!
	@IBOutlet weak var timeLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
