//
//  ProfileViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 29/06/21.
//

import UIKit

class ProfileViewController: UIViewController, CardNavigationDelegate {
    
    // MARK: - Properties
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileSegmentedControl: UISegmentedControl!
    @IBOutlet var momentsView: Moments!
    @IBOutlet var favoritesView: Favorites!
    @IBOutlet var historyView: History!
    
    var selectedActivity: Activity?
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    let name: String = "Eduardo Dini"
    let image = UIImage(named: "frameprofile")!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = name
        self.navigationItem.rightBarButtonItems = [addButton]
        profileImage.image = image
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
        loadActivities()
    }
    
    private func loadActivities() {
        let constructor = ActivityConstructor.getInstance()
        constructor.getActivities { activities in
            // Mocked data: use all activities as favorites and history, as there's no logic.
            // Shuffle to add difference between the views.
            self.favoritesView.items = activities.shuffled()
            self.favoritesView.reloadCards(delegate: self)
            self.historyView.items = activities.shuffled()
            self.historyView.reloadCards(delegate: self)
        }
    }

    @IBAction func segmentedControlChanged(_ sender: Any) {
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
    }
    
    func viewOrganizer(_ segmentIndex: Int) {
        momentsView.isHidden = segmentIndex != 0
        favoritesView.isHidden = segmentIndex != 1
        historyView.isHidden = segmentIndex != 2
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
}
