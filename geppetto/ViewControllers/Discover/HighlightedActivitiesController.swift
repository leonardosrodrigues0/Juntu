import Foundation
import UIKit
import Promises

internal class HighlightedActivitiesController: UIViewController {
    
    // MARK: - Properties
    
    weak var collectionView: UICollectionView!
    weak var pageControl: UIPageControl!
    weak var cardHeightConstraint: NSLayoutConstraint!
    weak var activityNavigationDelegate: ActivityNavigationDelegate!
    
    private var activities: [Activity] = []
    private var zoomFactor: CGFloat = 0.075
    private let highlightedCellIdentifier = "ActivityCardPhotoBackground"
    
    private let horizontalInsets = CGFloat(16)
    
    // MARK: - Methods
    
    func setup() -> Promise<[Activity]> {
        let flowLayout = ZoomAndSnapFlowLayout(zoomFactor: zoomFactor)
        flowLayout.horizontalInsets = horizontalInsets
        flowLayout.delegate = self
        
        let nib = UINib(nibName: highlightedCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: highlightedCellIdentifier)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.collectionViewLayout = flowLayout
        
        pageControl.currentPageIndicatorTintColor = .accentColor
        pageControl.pageIndicatorTintColor = .pageTintColor
        pageControl.numberOfPages = self.activities.count
        pageControl.currentPage = 0
        
        let database = ActivitiesDatabase.shared
        return database.getHighlightedActivities().then { activities in
            self.activities = activities
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HighlightedActivitiesController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = activities.count
        return activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: highlightedCellIdentifier, for: indexPath) as? ActivityCardPhotoBackground
        
        if let activity = activities.get(at: indexPath.row) {
            cell?.cellActivity = activity
            cell?.mainTag = nil
            
            if let tagId = activity.tags?.first {
                TagsDatabase.shared.getTag(withId: tagId).then { tag in
                    cell?.mainTag = tag
                }
            }
        }
        
        return cell!
    }
}

// MARK: - UICollectionViewDelegate

extension HighlightedActivitiesController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let activity = activities.get(at: indexPath.row) {
            activityNavigationDelegate?.navigate(to: activity)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HighlightedActivitiesController: UICollectionViewDelegateFlowLayout {
    /// Also updates the collectionView height constraint.
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemWidth: CGFloat = floor((collectionView.frame.size.width - 2 * horizontalInsets)) / (1 + zoomFactor)
        let itemHeight = itemWidth * (400 / 340)
        
        cardHeightConstraint?.constant = CGFloat(itemHeight * (1 + zoomFactor))
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    /// Updates pageControl currentPage in the end of scrolling
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let itemWidth: CGFloat = floor((collectionView.frame.size.width - 2 * horizontalInsets)) / (1 + zoomFactor)
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(itemWidth + horizontalInsets)
    }
}

// MARK: - ZoomAndSnapFlowLayoutDelegate

extension HighlightedActivitiesController: ZoomAndSnapFlowLayoutDelegate {
    func zoomAndSnap(zoomAndSnapFlowLayout: ZoomAndSnapFlowLayout, currentPageDidUpdate: Bool, currentPage: Int) {
        pageControl.currentPage = currentPage
    }
}
