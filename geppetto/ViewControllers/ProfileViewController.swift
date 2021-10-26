//
//  ProfileViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 29/06/21.
//

import UIKit

class ProfileViewController: UIViewController, CardNavigationDelegate, FullscreenImageNavigationDelegate {

    // MARK: - Properties
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileSegmentedControl: UISegmentedControl!
    @IBOutlet var momentsView: Moments!
    @IBOutlet var savedActivitiesView: SavedActivities!
    @IBOutlet var historyView: History!
    
    var selectedActivity: Activity?
    var selectedImage: Data?
    
    var editProfileButton: UIBarButtonItem?
    
    let images = [UIImage]()
    let image = UIImage(named: "momentsImage00")!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editProfileButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.pressed(_:)))
        
        self.navigationItem.rightBarButtonItems = [editProfileButton!]
        profileImage.image = image
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
        
        momentsView.delegate = self
        updateViews()

    }
    
    @objc func pressed(_ sender: UIBarButtonItem!) {
        if sender == editProfileButton {
            triggerEditUserNameAlert()
        }
    }
    
    private func updateTitle() {
        self.navigationItem.title = UserTracker.shared.getUserName()
    }
    
    private func updateViews() {
        self.updateTitle()
        self.updateSavedActivitiesView()
        self.updateHistoryView()
    }
    
    // update info when opening profile tab
    override func viewDidAppear(_ animated: Bool) {
        updateViews()
    }
    
    private func updateViews() {
        self.updateSavedActivitiesView()
        self.updateHistoryView()
        momentsView.retrieveImages()
        momentsView.collectionView.reloadData()
    }
    
    private func updateHistoryView() {
        let ids = UserTracker.shared.fetchActivityHistory()
        ActivityConstructor.shared.getActivities(ids: ids).then { activities in
            self.historyView.items = activities
            self.historyView.reloadCards(delegate: self)
        }
    }
    
    private func updateSavedActivitiesView() {
        let ids = UserTracker.shared.fetchSavedActivities()
        ActivityConstructor.shared.getActivities(ids: ids).then { activities in
            self.savedActivitiesView.items = activities
            self.savedActivitiesView.reloadCards(delegate: self)
        }
    }

    @IBAction func segmentedControlChanged(_ sender: Any) {
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
        updateViews()
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
    
    // MARK: - FullscreenImageNavigationDelegate Methods
    /// Navigate to FullscreenImage
    func navigate(image: Data) {
        selectedImage = image
        performSegue(withIdentifier: "goToFullscreen", sender: self)
    }
    
    // MARK: - Pass data foward in navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToOverview" {
            guard let activityOverviewViewController = segue.destination as? ActivityOverviewViewController else { return }
            activityOverviewViewController.activity = selectedActivity
        }
        
        if segue.identifier == "goToFullscreen" {
            guard let fullscreenImageViewController = segue.destination as? FullscreenImageViewController else { return }
            fullscreenImageViewController.imageData = selectedImage
        }
    }
    
    private func triggerEditUserNameAlert() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Como você gostaria que te chamemos?", message: "", preferredStyle: .alert)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Renomear", style: .default) { _ in
            // what happens once user clicks add item button in ui alert
            UserTracker.shared.editUserName(newName: textField.text!)
            self.updateTitle()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
