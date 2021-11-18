import UIKit
import FirebaseStorageUI

/// Card view for discover screen
class Card: UIView {
    
    // MARK: - Properties
    
    var activity: Activity? // Essential data
    @IBOutlet var cardView: Card!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var footnoteLabel: UILabel!
    
    weak var delegate: ActivityNavigationDelegate?
    
    // MARK: - Methods
    
    @IBAction func navigateToDetail(_ sender: UITapGestureRecognizer) {
        if let activity = self.activity {
            delegate?.navigate(to: activity)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Card", owner: self, options: nil)
        addSubview(cardView)
        cardView.frame = self.bounds
        cardView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    /// Required to be called after the `activity` have been set to update the card subviews.
    func updateView() {
        guard let activity = activity else {
            print("Error: failed to unwrap activity at Card view")
            return
        }

        image.sd_setImage(with: activity.getImageDatabaseRef())
        titleLabel.text = activity.name
        descriptionLabel.text = activity.introduction
        footnoteLabel.text = activity.fullAgeText
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
    }
}

extension UIStackView {
    
    /// Inject an array of Card Views into StackView.
    func populateWithCards(_ array: [Card]) {
        for item in self.arrangedSubviews {
            item.removeFromSuperview()
        }
        
        for card in array {
            self.addArrangedSubview(card)
        }
    }
}
