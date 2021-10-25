//
//  ActivityCardCell.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 25/10/21.
//

import UIKit

class ActivityCardCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    var cellActivity: Activity? {
        didSet {
            image.sd_setImage(with: (cellActivity?.getImageDatabaseRef())!)
            titleLabel.text = cellActivity?.name
            ratingLabel.text = "4,6"
            ratingCountLabel.text = "(5 avaliações)"
            descriptionLabel.text = cellActivity?.introduction
            tagLabel.text = cellActivity?.tags?.first ?? "No tags"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
