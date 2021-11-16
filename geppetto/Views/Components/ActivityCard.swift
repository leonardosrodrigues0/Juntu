import UIKit

@IBDesignable
class ActivityCard: UIView {
    
    // MARK: - Properties

    let nibName: String = "ActivityCard"
    
    var activity: Activity?
    
    weak var delegate: ActivityNavigationDelegate?
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    // MARK: - Methods
    
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: nibName) else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        tagLabel.text = ""
    }
    
    /// Required to be called after the `activity` have been set to update the card subviews.
    func updateView() {
        guard let activity = activity else {
            print("Error: failed to unwrap activity at Card view")
            return
        }
        
        image.sd_setImage(with: activity.getImageDatabaseRef())
        titleLabel.text = activity.name
        
        let rating: Double = 5
        let votes: Int = 2
        ratingLabel.text = String(format: "%.1f", rating)
        votesLabel.text = "(\(votes) avaliações)"
        
        descriptionLabel.text = activity.introduction
        ageLabel.text = activity.fullAgeText
        difficultyLabel.text = activity.difficulty
        durationLabel.text = activity.fullTimeText
    }
    
    func setTag(_ tag: Tag) {
        tagLabel.text = tag.name.uppercased()
        tagLabel.textColor = tag.color
    }
}
