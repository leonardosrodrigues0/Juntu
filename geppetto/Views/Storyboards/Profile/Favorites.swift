//
//  Favorites.swift
//  geppetto
//
//  Created by Eduardo Dini on 05/10/21.
//

import UIKit

class Favorites: UIView {

    @IBOutlet var favoritesView: UIView!
    var items: [Activity] = []
    @IBOutlet weak var stack: UIStackView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Favorites", owner: self, options: nil)
        addSubview(favoritesView)
        favoritesView.frame = self.bounds
        favoritesView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    /// Reload cards in view with items array
    func reloadCards(delegate: CardNavigationDelegate) {
        let cards = items.map { createCard($0, delegate: delegate) } // create all cards for each activity
        stack.populateWithCards(cards) // append all cards into the horizontal stack of first section
    }
    
    /// Instantiate the Card Views with data from activity
    private func createCard(_ activity: Activity, delegate: CardNavigationDelegate) -> Card {
        let card = Card()
        card.activity = activity
        card.delegate = delegate
        card.updateView()
        stack.addSubview(card) // add card as subview of the horizontal stack
        return card
    }

}
