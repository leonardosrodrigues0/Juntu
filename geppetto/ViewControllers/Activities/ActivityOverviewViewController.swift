import UIKit
import FirebaseStorageUI

/// Activity details screen
class ActivityOverviewViewController: UIViewController {
    
    // MARK: - Properties
    
    var activity: Activity?
    private var selectedActivity: Activity?
    static var stepsImages: [String: UIImage] = [:]
    private var isDataStored: Bool = false
    private var activityPageControlViewController: ActivityPageControlViewController?
    
    private var tags: [Tag] = []
    private var selectedTagCell: Tag?
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var durationUnity: UILabel!
    @IBOutlet weak var difficulty: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var fullDescription: UILabel!
    
    @IBOutlet weak var materialsTableView: UITableView!
    
    @IBOutlet weak var keepInMind: UIStackView!
    @IBOutlet weak var keepInMindText: UILabel!
    @IBOutlet weak var enterActivityStepsButton: UIButton!
    @IBOutlet weak var savedActivityButton: UIButton!
    
    @IBOutlet weak var tagsStack: UIStackView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    private let similarActivitiesController = SimilarActivitiesController()
    @IBOutlet weak var similarActivitiesStack: UIStackView!
    @IBOutlet weak var similarCollection: UICollectionView!
    @IBOutlet weak var similarCardHeight: NSLayoutConstraint!
    
    var toggleSaveButton: UIBarButtonItem?
    
    private let cellIdentifier = "MaterialTableViewCell"
    private var materials: [String] = []

    var helper = AnalyticsHelper.init()
    
    // MARK: - Methods
    
    override func viewDidLoad() {

        helper = AnalyticsHelper.init()
        super.viewDidLoad()
        
        initTableView()
        updateOutlets()
        setupSaveButton()
        
        clearTags()
        
        setupSimilarActivitiesController()
        
        helper.logViewedActivity(self.activity!)
        UserTracker.shared.logSeenActivity(self.activity!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateSavedActivityButtonImage()
    }
    
    private func initTableView() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        materialsTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        materialsTableView.dataSource = self
    }
    
    fileprivate func setupSaveButton() {
        toggleSaveButton = UIBarButtonItem(image: .none, style: .plain, target: self, action: #selector(self.editProfileButtonPressed(_:)))
        navigationItem.rightBarButtonItems = [toggleSaveButton!]
        updateSavedActivityButtonImage()
    }
    
    @objc private func editProfileButtonPressed(_ sender: UIBarButtonItem!) {
        if sender == toggleSaveButton {
            toggleSaveActivityButtonTapped(sender)
        }
    }
    
    private func updateOutlets() {
        guard let activity = activity else {
            print("Error: failed to unwrap activity at overview screen")
            return
        }
        
        image.sd_setImage(with: activity.getImageDatabaseRef())
        name.text = activity.name
        fullDescription.text = activity.introduction
        
        let rating: Double = 5
        let votes: Int = 2
        ratingLabel.text = String(format: "%.1f", rating)
        votesLabel.text = "(\(votes) avaliações)"

        if (activity.caution ?? "").isEmpty {
            keepInMind.removeFromSuperview()
        } else {
            keepInMindText.text = activity.caution
        }
        duration.text = activity.minMaxTime
        durationUnity.text = activity.timeUnit.rawValue
        difficulty.text = activity.difficulty
        age.text = activity.minMaxAge
        
        loadMaterialLabels()
        
        updateSavedActivityButtonImage()
        
        setupActivityTags()
    }
    
    /// Load materials and set them in the vertical stack
    private func loadMaterialLabels() {
        materials = activity?.materials ?? []
        materialsTableView.reloadData()
        tableHeightConstraint.constant = CGFloat(Double(materials.count) * 45)
    }
    
    private func createMaterialLabel(_ name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        label.numberOfLines = 0
        return label
    }
    
    /// Clear default tags, load activity tags and add them in the horizontal stack
    private func setupActivityTags() {
        clearTags()
        loadAndCreateTags()
    }
    
    private func clearTags() {
        for subView in tagsStack.arrangedSubviews {
            subView.removeFromSuperview()
        }
    }
    
    private func loadAndCreateTags() {
        guard self.activity?.tags != nil else { return }
        
        TagsDatabase.shared.getTags(withIds: self.activity?.tags ?? []).then { tags in
            self.tags.append(contentsOf: tags)
            self.populateTagScroll()
        }
    }
    
    private func populateTagScroll() {
        let tags = tags.map { createTagLabel($0) }
        tagsStack.populateWithViews(tags)
    }

    private func createTagLabel(_ tag: Tag) -> ClickableTagUILabel {
        let clickableTag = ClickableTagUILabel()
        clickableTag.thisTag = tag
        clickableTag.tagNavigationDelegate = self
        return clickableTag
    }
    
    private func setupSimilarActivitiesController() {
        similarActivitiesController.collectionView = similarCollection
        similarActivitiesController.cardHeightConstraint = similarCardHeight
        similarActivitiesController.activityNavigationDelegate = self
        similarActivitiesController.similarTo = self.activity
        similarActivitiesController.delegate = self
        
        _ = similarActivitiesController.setup()
    }
    
    /// Empty `stepsImages`. Download images from their storage reference and set it to the step
    /// image view using its view controller and add them to `stepsImages`.
    private func downloadStepsImages() {
        ActivityOverviewViewController.stepsImages.removeAll()
        if let activity = activity {
            for step in activity.getSteps() {
                let storageRef = step.getImageDatabaseRef()
                storageRef?.getData(maxSize: 4 * 1024 * 1024, completion: { (data, error) in
                    if let error = error {
                        print("Got an error fetching data: \(error.localizedDescription)")
                        return
                    }
                    
                    if
                        let data = data,
                        let pages = self.activityPageControlViewController?.pageViewController?.pages,
                        let stepVC = pages[step.stepIndex! - 1] as? ActivityStepViewController
                    {
                        stepVC.image?.image = UIImage(data: data)
                        ActivityOverviewViewController.stepsImages[String(describing: step.stepIndex!)] = UIImage(data: data)
                    }
                })
            }
            self.isDataStored = true
        }
    }

    // MARK: - Actions
    
    @IBAction private func enterActivityButtonTapped() {
        
        if !isDataStored {
            downloadStepsImages()
        }
        
        let storyboard = UIStoryboard(name: "ActivityStep", bundle: nil)
        activityPageControlViewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: ActivityPageControlViewController.self)
        ) as? ActivityPageControlViewController
        
        activityPageControlViewController?.activity = activity
        helper.logDiveInPressed(activity: self.activity!)
        show(activityPageControlViewController!, sender: self)
    }
    
    @IBAction func toggleSaveActivityButtonTapped(_ sender: UIBarButtonItem) {
        UserTracker.shared.logToggleSavedActivity(self.activity!)
        helper.logSavedActivity(self.activity!)
        updateSavedActivityButtonImage()
    }
    
    private func updateSavedActivityButtonImage() {
        let isSaved = UserTracker.shared.fetchIfActivityIsSaved(self.activity!)
        let buttonImageString = isSaved ? "bookmark.fill" : "bookmark"
        toggleSaveButton?.image = UIImage(systemName: buttonImageString)
    }
    
    /// Prepare Navigation to ActivityOverview or TagActivities
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOverview" {
            guard let activityOverviewViewController = segue.destination as? ActivityOverviewViewController else { return }
            activityOverviewViewController.activity = selectedActivity
        } else if segue.identifier == "goToTag" {
            guard let tagViewController = segue.destination as? TagViewController else { return }
            tagViewController.viewTag = selectedTagCell
        }
    }
}

extension ActivityOverviewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MaterialTableViewCell
        let item = materials[indexPath.row]
        cell?.name.text = item
        return cell!
    }
    
}

extension ActivityOverviewViewController: ActivityNavigationDelegate {
    func navigate(to activity: Activity) {
        selectedActivity = activity
        performSegue(withIdentifier: "goToOverview", sender: self)
    }
}

extension ActivityOverviewViewController: TagNavigationDelegate {
    func navigate(to tag: Tag) {
        selectedTagCell = tag
        performSegue(withIdentifier: "goToTag", sender: self)
    }
}

extension ActivityOverviewViewController: SimilarActivitiesDelegate {
    func similarActivities(_ controller: SimilarActivitiesController, didEndLoad: Bool) {
        print("didEndLoad")
        if controller.activities.isEmpty {
            similarActivitiesStack.removeFromSuperview()
        }
    }
    
}

fileprivate extension UIStackView {
    /// Inject an array of UIView into StackView
    func populateWithViews(_ array: [UIView]) {
        for item in self.arrangedSubviews {
            item.removeFromSuperview()
        }
        
        for view in array {
            self.addArrangedSubview(view)
        }
    }
}
