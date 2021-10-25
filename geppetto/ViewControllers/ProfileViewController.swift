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
    @IBOutlet var favoritesView: Favorites!
    @IBOutlet var historyView: History!
    
    var selectedActivity: Activity?
    var selectedImage: Data?
    
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
        
        momentsView.delegate = self
        loadActivities()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        momentsView.retrieveImages()
        momentsView.collectionView.reloadData()
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
}
