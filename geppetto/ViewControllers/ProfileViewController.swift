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
    let name: String = "Nome mockado rs"
    let image = UIImage(named: "frameprofile")!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = name
        self.navigationItem.rightBarButtonItems = [addButton]
        profileImage.image = image
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
        momentsView.momentsLabel.text = "Hello"
        loadActivities()
    }
    
    private func loadActivities() {
        let constructor = ActivityConstructor.getInstance()
        constructor.getActivities { activities in
            self.favoritesView.items = activities
            self.favoritesView.reloadCards(delegate: self)
            self.historyView.items = activities
            self.historyView.reloadCards(delegate: self)
        }
    }

    @IBAction func segmentedControlChanged(_ sender: Any) {
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
    }
    
    func viewOrganizer(_ segmentIndex: Int) {
        if segmentIndex == 0 {
            momentsView.isHidden = false
            favoritesView.isHidden = true
            historyView.isHidden = true
        } else if segmentIndex == 1 {
            momentsView.isHidden = true
            favoritesView.isHidden = false
            historyView.isHidden = true
        } else {
            momentsView.isHidden = true
            favoritesView.isHidden = true
            historyView.isHidden = false
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
}
