//
//  TymetroTimeTVCell.swift
//  TransferTravel
//
//  Created by Feng on 2023/10/7.
//

import UIKit

class TymetroTimeTVCell: UITableViewCell {

	@IBOutlet weak var routeTypeLabel: UILabel!
	@IBOutlet weak var departureTimeLabel: UILabel!
	@IBOutlet weak var arrivalTimeLabel: UILabel!
	@IBOutlet weak var travelTimeLabel: UILabel!
	@IBOutlet weak var cellTimeLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
