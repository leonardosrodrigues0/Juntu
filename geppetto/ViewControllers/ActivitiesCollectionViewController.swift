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
    var contentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    var horizontalSpacing = CGFloat(10)
    
    // MARK: - Methods
    
    func setup() -> Promise<[Activity]> {
        let nib = UINib(nibName: activityCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: activityCellIdentifier)
        
        setupFlowLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return loadActivitiesPromise()
    }
    
    func setupFlowLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = contentInset
        layout.minimumInteritemSpacing = horizontalSpacing
        layout.minimumLineSpacing = horizontalSpacing
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    /// Override this method to load the activities you want to display
    func loadActivitiesPromise() -> Promise<[Activity]> {
        let database = ActivitiesDatabase.shared
        return database.getAllActivities().then { activities in
            self.activities = activities
            self.collectionView.reloadData()
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
        let width: CGFloat = floor((collectionView.frame.size.width - contentInset.left - contentInset.right - horizontalSpacing) / 2)
        let height = width * (20 / 9)
        
        cardHeightConstraint?.constant = CGFloat(height + contentInset.top + contentInset.bottom)
        
        return CGSize(width: width, height: height)
    }
}
