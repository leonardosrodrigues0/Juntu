//
//  DiscoverViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 29/06/21.
//

import UIKit

class DiscoverViewController: UIViewController, CardNavigationDelegate {
    
    //MARK: - Properties
    var items: [Activity] = []
    var selectedActivity: Activity?
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        items = Activity.activities()   // read all activities from ../Mock/activities.json
        let cards = items.map { createCard($0) }    // create all cards for each activity
        stack.populateWithCards(cards)  // append all cards into the horizontal stack of first section
    }
    
    ///Instantiate the Card Views with data from activity
    private func createCard(_ activity: Activity) -> Card {
        let card = Card()
        card.activity = activity
        card.delegate = self
        card.updateView()
        view.addSubview(card)
        let constraint = [card.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -10)]
        NSLayoutConstraint.activate(constraint)
        return card
    }
    
    ///Navigate to ActivityOverview
    func navigate(from card: Card) {
        selectedActivity = card.activity
        
        performSegue(withIdentifier: "goToOverview", sender: self)
    }
    
    ///Prepare for navigate to ActivityOverview, i.e. pass the activity data foward
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOverview" {
            
            guard let vc = segue.destination as? ActivityOverviewViewController else { return }
            
            vc.activity = selectedActivity
        }
    }
}



extension UIStackView {
    ///Inject an array of Card Views into StackView
    fileprivate func populateWithCards(_ array: [Card]) {
        for item in self.arrangedSubviews {
            item.removeFromSuperview()
        }
        for card in array {
            self.addArrangedSubview(card)
        }
    }
}
