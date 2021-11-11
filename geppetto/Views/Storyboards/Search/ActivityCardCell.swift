import UIKit

class ActivityCardCell: UICollectionViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var image: DesignableImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var cellActivity: Activity? {
        didSet {
            updateOutlets()
        }
    }
    
    // MARK: - Methods
    
    private func updateOutlets() {
        image.sd_setImage(with: (cellActivity?.getImageDatabaseRef())!)
        ageLabel.text = cellActivity?.getAgeText()
        durationLabel.text = cellActivity?.time
        titleLabel.text = cellActivity?.name
        let rating: Double = 5
        ratingLabel.text = String(format: "%.1f", rating)
        let votes: Int = 2
        ratingCountLabel.text = "(\(votes) avaliações)"
        descriptionLabel.text = cellActivity?.introduction
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
