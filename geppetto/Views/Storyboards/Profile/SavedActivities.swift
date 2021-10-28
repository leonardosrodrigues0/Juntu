//
//  SavedActivities.swift
//  geppetto
//
//  Created by Eduardo Dini on 05/10/21.
//

import UIKit

class SavedActivities: UIView {

    @IBOutlet var SavedView: UIView!
    @IBOutlet weak var stack: UIStackView!
    var items: [Activity] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SavedActivities", owner: self, options: nil)
        addSubview(SavedView)
        SavedView.frame = self.bounds
        SavedView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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
