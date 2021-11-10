//
//  ActivityCardPhotoBackground.swift
//  geppetto
//
//  Created by Renato Noronha Maximo on 04/11/21.
//

import UIKit

class ActivityCardPhotoBackground: UICollectionViewCell {

    @IBOutlet weak var image: DesignableImageView!
    @IBOutlet weak var mainTagLabel: DesignableLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dificultyLabel: UILabel!
    
    var cellActivity: Activity? {
        didSet {
            updateOutlets()
        }
    }
    
    var mainTag: Tag? {
        didSet {
            if mainTag != nil {
                mainTagLabel.text = mainTag?.name
                mainTagLabel.tintColor = mainTag?.color
            } else {
                mainTagLabel.text = ""
            }
        }
    }
    
    private func updateOutlets() {
        image.sd_setImage(with: (cellActivity?.getImageDatabaseRef())!)
        titleLabel.text = cellActivity?.name
        
        let rating: Double = 5
        ratingLabel.text = String(format: "%.1f", rating)
        let votes: Int = 2
        ratingCountLabel.text = "(\(votes) avaliações)"
        descriptionLabel.text = cellActivity?.introduction
        
        ageLabel.text = cellActivity?.getAgeText()
        durationLabel.text = cellActivity?.time
        dificultyLabel.text = cellActivity?.difficulty
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
