//
//  History.swift
//  geppetto
//
//  Created by Eduardo Dini on 05/10/21.
//

import UIKit

class History: UIView {
    
    @IBOutlet var historyView: UIView!
    @IBOutlet weak var stack: UIStackView!
    var items: [Activity] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("History", owner: self, options: nil)
        addSubview(historyView)
        historyView.frame = self.bounds
        historyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    /// Reload cards in view with items array
    func reloadCards(delegate: ActivityNavigationDelegate) {
        let cards = items.map { createCard($0, delegate: delegate) } // create all cards for each activity
        stack.populateWithCards(cards) // append all cards into the horizontal stack of first section
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
