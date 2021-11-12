import Foundation
import UIKit

class ActivitiesCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private let activityCellIdentifier = "ActivityCardCell"
    public var activities: [Activity] = []
    weak var collectionView: UICollectionView!
    weak var cardHeightConstraint: NSLayoutConstraint!
    weak var activityNavigationDelegate: ActivityNavigationDelegate!
    
    // MARK: - Methods
    
    func setup() {
        let nib = UINib(nibName: activityCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: activityCellIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadActivitiesPromise()
    }
    
    /// Override this method to load the activities you want to display
    func loadActivitiesPromise() {
        let loadingHandler = LoadingHandler(parentView: collectionView)
        let database = ActivitiesDatabase.shared
        database.getAllActivities().then { activities in
            self.activities = activities
            self.collectionView.reloadData()
            loadingHandler.stop()
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpacing = CGFloat(10)
        let contentInsets = CGFloat(16)
        let width: CGFloat = floor((collectionView.frame.size.width - 2 * contentInsets - horizontalSpacing) / 2)
        let height = width * (20 / 9)
        
        cardHeightConstraint.constant = CGFloat(height)
        
        return CGSize(width: width, height: height)
    }
}
