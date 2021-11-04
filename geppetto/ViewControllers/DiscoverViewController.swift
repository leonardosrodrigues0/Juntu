//
//  DiscoverViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 29/06/21.
//

import UIKit
import Firebase

class DiscoverViewController: UIViewController, ActivityNavigationDelegate {
    
    // MARK: - Properties
    var items: [Activity] = []
    var selectedActivity: Activity?
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Methods
    /// Get information from database and reload the cards
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let helper = AnalyticsHelper()
        let database = ActivitiesDatabase.shared
        database.getAllActivities().then { activities in
            self.items.append(contentsOf: activities)
            self.reloadCards()
            helper.logAppOpen()
        }
    }
    
    /// Reload cards in view with items array
    func reloadCards() {
        let cards = items.map { createCard($0) } // create all cards for each activity
        stack.populateWithCards(cards) // append all cards into the horizontal stack of first section
    }
    
    /// Instantiate the Card Views with data from activity
    private func createCard(_ activity: Activity) -> Card {
        let card = Card()
        card.activity = activity
        card.delegate = self
        card.updateView()
        stack.addSubview(card) // add card as subview of the horizontal stack
        let constraint = [card.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -10)]
        NSLayoutConstraint.activate(constraint)
        return card
    }
    
    /// Navigate to ActivityOverview
    func navigate(to activity: Activity) {
        selectedActivity = activity
        performSegue(withIdentifier: "goToOverview", sender: self)
    }
    
    /// Prepare for navigate to ActivityOverview, i.e. pass the activity data foward
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOverview" {
            guard let activityOverviewViewController = segue.destination as? ActivityOverviewViewController else { return }
            activityOverviewViewController.activity = selectedActivity
        }
    }
}
