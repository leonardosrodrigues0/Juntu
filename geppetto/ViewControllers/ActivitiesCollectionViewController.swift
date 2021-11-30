import Foundation
import UIKit
import Promises

class ActivitiesCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private let activityCellIdentifier = "ActivityCardCell"
    var activities: [Activity] = []
    weak var collectionView: UICollectionView!
    weak var cardHeightConstraint: NSLayoutConstraint!
    weak var activityNavigationDelegate: ActivityNavigationDelegate!
    
    // MARK: - Methods
    
    func setup() -> Promise<[Activity]> {
        let nib = UINib(nibName: activityCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: activityCellIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return loadActivitiesPromise()
    }
    
    /// Override this method to load the activities you want to display
    func loadActivitiesPromise() -> Promise<[Activity]> {
        let database = ActivitiesDatabase.shared
        return database.getAllActivities().then { activities in
            self.activities = activities
            self.collectionView.reloadData()
        }
    }
    
    func invalidateLayoutIfPossible() {
        if !self.activities.isEmpty {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

// MARK: - DataSource and Delegate

extension ActivitiesCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellIdentifier, for: indexPath) as? ActivityCardCell
        
        if let activity = activities.get(at: indexPath.row) {
            cell?.cellActivity = activity
            cell?.image.bottomGradientColor = UIColor.black.withAlphaComponent(0.75)
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let activity = activities.get(at: indexPath.row) {
            activityNavigationDelegate?.navigate(to: activity)
        }
    }
}

// MARK: - Delegate Flow Layout

extension ActivitiesCollectionViewController: UICollectionViewDelegateFlowLayout {
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
        
        cardHeightConstraint.constant = CGFloat(adjustedHeight)
        
        return CGSize(width: width, height: adjustedHeight)
    }
}
