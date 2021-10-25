//
//  ActivityCardCell.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 25/10/21.
//

import UIKit

class ActivityCardCell: UICollectionViewCell {

    @IBOutlet weak var image: DesignableImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagLabel: DesignableLabel!
    
    var cellActivity: Activity? {
        didSet {
            updateOutlets()
        }
    }
    
    private func updateOutlets() {
        image.sd_setImage(with: (cellActivity?.getImageDatabaseRef())!)
        ageLabel.text = cellActivity?.getAgeText()
        durationLabel.text = cellActivity?.time
        titleLabel.text = cellActivity?.name
        ratingLabel.text = "4,6"
        ratingCountLabel.text = "(5 avaliações)"
        descriptionLabel.text = cellActivity?.introduction
        TagsDatabase.shared.getTag(withId: (cellActivity?.tags?.first)!).then { tag in
            self.tagLabel.text = tag.name
            self.tagLabel.tintColor = tag.color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
