import UIKit

class SavedActivities: UIView {
    
    // MARK: - Properties

    @IBOutlet var savedView: UIView!
    @IBOutlet weak var stack: UIStackView!
    var items: [Activity] = []
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Methods
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SavedActivities", owner: self, options: nil)
        addSubview(savedView)
        savedView.frame = self.bounds
        savedView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    /// Reload cards in view with items array
    func reloadCards(delegate: ActivityNavigationDelegate) {
        let cards = items.map { createCard($0, delegate: delegate) }
        stack.populateWithCards(cards)
    }
    
    /// Instantiate the Card Views with data from activity
    private func createCard(_ activity: Activity, delegate: ActivityNavigationDelegate) -> Card {
        let card = Card()
        card.activity = activity
        card.delegate = delegate
        card.updateView()
        stack.addSubview(card) // add card as subview of the horizontal stack
        let constraint = [card.widthAnchor.constraint(equalTo: stack.widthAnchor)]
        NSLayoutConstraint.activate(constraint)
        return card
    }

}
