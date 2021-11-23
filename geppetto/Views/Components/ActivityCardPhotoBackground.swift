import UIKit

class ActivityCardPhotoBackground: UICollectionViewCell {
    
    // MARK: - Properties

    @IBOutlet weak var image: DesignableImageView!
    @IBOutlet weak var mainTagLabel: DesignableLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    
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
    
    // MARK: - Methods
    
    private func updateOutlets() {
        image.sd_setImage(with: (cellActivity?.getImageDatabaseRef())!)
        titleLabel.text = cellActivity?.name
        descriptionLabel.text = cellActivity?.introduction
        ageLabel.text = cellActivity?.fullAgeText
        durationLabel.text = cellActivity?.fullTimeText
        difficultyLabel.text = cellActivity?.difficulty
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
