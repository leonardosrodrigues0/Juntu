//
//  DiscoverViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 29/06/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    var items: [Activity] = []
    @IBOutlet weak var stack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = Activity.activities()   // read all activities from ../Mock/activities.json
        let cards = items.map { createCard($0) }    // create all cards for each activity
        stack.populateWithCards(cards)  // append all cards into the horizontal stack of first section
    }
    
    private func createCard(_ activity: Activity) -> Card {
        let card = Card()
        card.titleLabel.text = activity.name
        card.footnoteLabel.text = activity.description
        view.addSubview(card)
        let constraint = [card.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32)]
        NSLayoutConstraint.activate(constraint)
        return card
    }
}

extension UIStackView {
    fileprivate func populateWithCards(_ array: [Card]) {
        for item in self.arrangedSubviews {
            item.removeFromSuperview()
        }
        for card in array {
            self.addArrangedSubview(card)
        }
    }
}
