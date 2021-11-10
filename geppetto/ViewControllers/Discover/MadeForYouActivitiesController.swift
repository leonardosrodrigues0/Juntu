//
//  MadeForYouActivitiesController.swift
//  geppetto
//
//  Created by Renato Noronha Máximo on 09/11/21.
//

import Foundation
import UIKit

internal class MadeForYouActivitiesController: UIViewController {
    
    private let activityCellIdentifier = "ActivityCardCell"
    private var activities: [Activity] = []
    weak var collectionView: UICollectionView!
    weak var cardHeightConstrait: NSLayoutConstraint!
    weak var activityNavigationDelagate: ActivityNavigationDelegate!
    
    func setup() {
        let nib = UINib(nibName: activityCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: activityCellIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let loadingHandler = LoadingHandler(parentView: collectionView)
        let database = ActivitiesDatabase.shared
        database.getAllActivities().then { activities in
            self.activities = activities
            self.collectionView.reloadData()
            loadingHandler.stop()
        }
    }
}

// MARK: - Made For You Collection
extension MadeForYouActivitiesController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
            activityNavigationDelagate?.navigate(to: activity)
        }
    }
}

extension MadeForYouActivitiesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpacing = CGFloat(10)
        let contentInsets = CGFloat(16)
        let width: CGFloat = floor((collectionView.frame.size.width - 2 * contentInsets - horizontalSpacing) / 2)
        let height = width * (20 / 9)
        
        cardHeightConstrait.constant = CGFloat(height)
        
        return CGSize(width: width, height: height)
    }
}
