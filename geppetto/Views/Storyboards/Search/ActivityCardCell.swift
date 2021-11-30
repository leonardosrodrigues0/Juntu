import UIKit

class ActivityCardCell: UICollectionViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var image: DesignableImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var cellActivity: Activity? {
        didSet {
            updateOutlets()
        }
    }
    
    // MARK: - Methods
    
    private func updateOutlets() {
        image.sd_setImage(with: (cellActivity?.getImageDatabaseRef())!)
        ageLabel.text = cellActivity?.fullAgeText
        durationLabel.text = cellActivity?.fullTimeText
        titleLabel.text = cellActivity?.name
        descriptionLabel.text = cellActivity?.introduction
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
