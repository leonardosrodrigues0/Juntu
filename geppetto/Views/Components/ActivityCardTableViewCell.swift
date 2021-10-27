//
//  ActivityCardTableViewCell.swift
//  geppetto
//
//  Created by Renato Noronha Máximo on 22/10/21.
//

import UIKit

@IBDesignable
class ActivityCardTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var card: ActivityCard!
    
}
