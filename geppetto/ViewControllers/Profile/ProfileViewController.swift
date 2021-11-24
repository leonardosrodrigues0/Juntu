import UIKit

class ProfileViewController: UIViewController, ActivityNavigationDelegate, FullscreenImageNavigationDelegate {

    // MARK: - Properties
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileSegmentedControl: UISegmentedControl!
    @IBOutlet var momentsView: Moments!
    @IBOutlet var historyView: History!
    @IBOutlet var savedActivitiesView: SavedActivities!
    
    var selectedActivity: Activity?
    var selectedImageIndex: Int = 0
    
    var editProfileButton: UIBarButtonItem?
    
    let images = [UIImage]()
    let placeholderProfilePicture = UIImage(named: "placeholderProfilePicture")!
    
    // MARK: - Startup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyView.activityNavigationDelegate = self
        savedActivitiesView.activityNavigationDelegate = self
        
        setupProfileEditing()
        
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
        
        momentsView.delegate = self
        
        updateViews()
    }
    
    fileprivate func setupProfileEditing() {
        editProfileButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editProfileButtonPressed(_:)))
        navigationItem.rightBarButtonItems = [editProfileButton!]
    }
    
    // MARK: - Segmented Control
    
    @IBAction private func segmentedControlChanged(_ sender: Any) {
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
        updateViews()
    }
    
    private func viewOrganizer(_ segmentIndex: Int) {
        momentsView.isHidden = segmentIndex != 0
        savedActivitiesView.isHidden = segmentIndex != 1
        historyView.isHidden = segmentIndex != 2
    }
    
    // MARK: - View Update Methods
    
    // Update info when opening profile tab
    override func viewDidAppear(_ animated: Bool) {
        updateViews()
    }
    
    private func updateViews() {
        self.updateTitle()
        self.updateSavedActivitiesView()
        self.updateHistoryView()
        momentsView.retrieveImages()
        profileImageView.image = UserTracker.shared.getProfilePicture() ?? self.placeholderProfilePicture
    }
    
    private func updateTitle() {
        self.navigationItem.title = UserTracker.shared.getUserName()
        
        if self.navigationItem.title!.isEmpty {
            self.navigationItem.title = "Perfil"
        }
    }
    
    private func updateHistoryView() {
        let ids = UserTracker.shared.fetchActivityHistory()
        ActivitiesDatabase.shared.getActivities(ids: ids).then { activities in
            self.historyView.activityList = activities
            self.historyView.reloadCards()
        }
    }
    
    private func updateSavedActivitiesView() {
        let ids = UserTracker.shared.fetchSavedActivities()
        ActivitiesDatabase.shared.getActivities(ids: ids).then { activities in
            self.savedActivitiesView.items = activities
            self.savedActivitiesView.reloadCards()
        }
    }
    
    // MARK: - CardNavigationDelegate Methods
    
    /// Navigate to ActivityOverview
    func navigate(to activity: Activity) {
        selectedActivity = activity
        performSegue(withIdentifier: "goToOverview", sender: self)
    }
    
    // MARK: - FullscreenImageNavigationDelegate Methods
    
    /// Navigate to FullscreenImage
    func navigate(selectedImageIndex: Int) {
        self.selectedImageIndex = selectedImageIndex
        performSegue(withIdentifier: "goToFullscreen", sender: self)
    }
    
    // MARK: - Pass data forward in navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToOverview" {
            guard let activityOverviewViewController = segue.destination as? ActivityOverviewViewController else { return }
            activityOverviewViewController.activity = selectedActivity
        } else if segue.identifier == "goToFullscreen" {
            guard let fullscreenImageViewController = segue.destination as? FullscreenImageViewController else { return }
            fullscreenImageViewController.images = momentsView.images
            fullscreenImageViewController.currentImageIndex = selectedImageIndex
        }
    }
    
    // MARK: - Profile Editing Methods
    
    @objc private func editProfileButtonPressed(_ sender: UIBarButtonItem!) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfile") as? EditProfileViewController {
            vc.delegate = self
            
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = UIModalPresentationStyle.popover
            
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: EditProfileViewControllerDelegate {
    func didFinishEditing() {
        updateViews()
    }
}
