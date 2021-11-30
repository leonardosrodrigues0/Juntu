import UIKit
import Promises

class DiscoverViewController: UIViewController {
    
    // MARK: - Properties
    
    private var selectedTagCell: Tag?
    private var selectedActivity: Activity?
    
    private let discoverTagsController = DiscoverTagsController()
    private let highlightedController = HighlightedActivitiesController()
    private let madeForYouController = MadeForYouActivitiesController()
    
    @IBOutlet weak var tagsStack: UIStackView!
    @IBOutlet weak var tagsScrollView: UIScrollView!
    
    @IBOutlet weak var highlightedCollection: UICollectionView!
    @IBOutlet weak var highlightedCardHeight: NSLayoutConstraint!
    @IBOutlet weak var highlightedPageControl: UIPageControl!
    
    @IBOutlet weak var madeForYouCollection: UICollectionView!
    @IBOutlet weak var madeForYouCardHeight: NSLayoutConstraint!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let helper = AnalyticsHelper()
        let loadingHandler = LoadingHandler(parentView: self.view)
        
        all(
            setupTagsController(),
            setupHighlightedController(),
            setupMadeForYouController()
        ).then { _ in
            loadingHandler.stop()
        }
        helper.logAppOpen()
    }
    
    /// Runs when the environment's traits change to update content based on the current ContentSizeCategory
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.preferredContentSizeCategory !=
            traitCollection.preferredContentSizeCategory {
            madeForYouController.invalidateLayoutIfPossible()
        }
    }

    private func setupTagsController() -> Promise<[Tag]> {
        discoverTagsController.tagsStack = tagsStack
        discoverTagsController.tagsScrollView = tagsScrollView
        discoverTagsController.tagNavigationDelegate = self
        
        return discoverTagsController.setup()
    }
    
    private func setupHighlightedController() -> Promise<[Activity]> {
        highlightedController.collectionView = highlightedCollection
        highlightedController.pageControl = highlightedPageControl
        highlightedController.cardHeightConstraint = highlightedCardHeight
        highlightedController.activityNavigationDelegate = self
        
        return highlightedController.setup()
    }
    
    private func setupMadeForYouController() -> Promise <[Activity]> {
        madeForYouController.collectionView = madeForYouCollection
        madeForYouController.cardHeightConstraint = madeForYouCardHeight
        madeForYouController.activityNavigationDelegate = self
        
        return madeForYouController.setup()
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

extension DiscoverViewController: ActivityNavigationDelegate {
    func navigate(to activity: Activity) {
        selectedActivity = activity
        performSegue(withIdentifier: "goToOverview", sender: self)
    }
}

extension DiscoverViewController: TagNavigationDelegate {
    func navigate(to tag: Tag) {
        selectedTagCell = tag
        performSegue(withIdentifier: "goToTag", sender: self)
    }
}
