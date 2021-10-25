//
//  TagViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 22/10/21.
//

import UIKit

class TagViewController: UIViewController, CardNavigationDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var stack: UIStackView!
    var viewTag: Tag?
    var items: [Activity] = []
    var selectedActivity: Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = viewTag?.name
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.tintColor = viewTag?.color
        viewTag?.getTagActivities().then { activities in
            self.items.append(contentsOf: activities)
            self.reloadCards(delegate: self)
        }
    }
    
    // MARK: - CardNavigationDelegate Methods
    /// Navigate to ActivityOverview
    func navigate(from card: Card) {
        selectedActivity = card.activity
        performSegue(withIdentifier: "goToOverview", sender: self)
    }
    
    /// Prepare for navigate to ActivityOverview, i.e. pass the activity data forward.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOverview" {
            guard let activityOverviewViewController = segue.destination as? ActivityOverviewViewController else { return }
            activityOverviewViewController.activity = selectedActivity
        }
    }
    
    /// Reload cards in view with items array
    func reloadCards(delegate: CardNavigationDelegate) {
        let cards = items.map { createCard($0, delegate: self) }
        stack.populateWithCards(cards)
    }
    
    /// Instantiate the Card Views with data from activity
    private func createCard(_ activity: Activity, delegate: CardNavigationDelegate) -> Card {
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
