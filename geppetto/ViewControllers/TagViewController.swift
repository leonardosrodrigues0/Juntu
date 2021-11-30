import UIKit

class TagViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewTag: Tag?
    var activities: [Activity] = []
    var selectedActivity: Activity?
    
    private let activityCellIdentifier = "ActivityCardCell"
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = viewTag?.name
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.tintColor = viewTag?.color
        initCollectionView()
    }
    
    /// Runs when the environment's traits change to update content based on the current ContentSizeCategory
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.preferredContentSizeCategory !=
            traitCollection.preferredContentSizeCategory {
            if !activities.isEmpty {
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    /// Register `TagCardCell` in collection view.
    /// Get tags from database and reload collection view data.
    private func initCollectionView() {
        let nib = UINib(nibName: activityCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: activityCellIdentifier)
        collectionView.dataSource = self
        
        viewTag?.getTagActivities().then { activities in
            self.activities.append(contentsOf: activities)
            self.collectionView.reloadData()
        }
    }
    
    /// Prepare for navigate to ActivityOverview, i.e. pass the activity data forward.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOverview" {
            guard let activityOverviewViewController = segue.destination as? ActivityOverviewViewController else { return }
            activityOverviewViewController.activity = selectedActivity
        }
    }
}

extension TagViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// Return total number of items.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    /// Return the cell for a given index.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellIdentifier, for: indexPath) as? ActivityCardCell
        
        // Set cell tag element:
        if let activity = activities.get(at: indexPath.row) {
            cell?.cellActivity = activity
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let activity = activities.get(at: indexPath.row) {
            selectedActivity = activity
        }
        
        performSegue(withIdentifier: "goToOverview", sender: self)
    }
}

extension TagViewController: UICollectionViewDelegateFlowLayout {

    /// Return the item size for collection view.
    /// Use aspect ratio of 16:9 for two columns of items.
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let horizontalSpacing = CGFloat(10) // space between cells (defined only here)
        let contentInsets = CGFloat(16) // space between cells and safe area (horizontally, defined in the storyboard)
        let width: CGFloat = floor((collectionView.frame.size.width - 2 * contentInsets - horizontalSpacing) / 2)
        let imageHeight = width * (3/2)
        
        // The next 4 constants come from ActivityCardCell storyboard
        // Title font style is headline and it has 20.5 height when there is no font scale,
        // but since scaledValue is not scaling as expected, a bigger value was necessary
        let titleAdjustedHeight = UIFontMetrics(forTextStyle: .headline).scaledValue(for: 25.0)
        // Description font style is footnote and it has 52.0 height when there is no font scale,
        // but since scaledValue is not scaling as expected, a bigger value was necessary
        let descriptionAdjustedHeight = UIFontMetrics(forTextStyle: .footnote).scaledValue(for: 55.0)
        let spaceAboveTitle = 8.0
        let spaceAboveDescription = 8.0
        
        let adjustedHeight = imageHeight + descriptionAdjustedHeight + titleAdjustedHeight + spaceAboveTitle + spaceAboveDescription
        
        return CGSize(width: width, height: adjustedHeight)
    }
}
