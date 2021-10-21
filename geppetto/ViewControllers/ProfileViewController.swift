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
    @IBOutlet var savedActivitiesView: SavedActivities!
    @IBOutlet var historyView: History!
    
    var selectedActivity: Activity?
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    let name: String = "Celso Pereira"
    let images = [UIImage]()
    let image = UIImage(named: "momentsImage00")!
    
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
        self.updateSavedActivities()
        self.updateHistory()
    }
    
    // update info when opening profile tab
    override func viewDidAppear(_ animated: Bool) {
        loadActivities()
    }
    
    private func updateHistory() {
        let ids = UserTracker.shared.fetchActivityHistory()
        ActivityConstructor.shared.getActivities(ids: ids).then { activities in
            self.historyView.items = activities
            self.historyView.reloadCards(delegate: self)
        }
    }
    
    private func updateSavedActivities() {
        let ids = UserTracker.shared.fetchSavedActivities()
        ActivityConstructor.shared.getActivities(ids: ids).then { activities in
            self.savedActivitiesView.items = activities
            self.savedActivitiesView.reloadCards(delegate: self)
        }
    }

    @IBAction func segmentedControlChanged(_ sender: Any) {
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
        updateHistory()
    }
    
    func viewOrganizer(_ segmentIndex: Int) {
        momentsView.isHidden = segmentIndex != 0
        savedActivitiesView.isHidden = segmentIndex != 1
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
