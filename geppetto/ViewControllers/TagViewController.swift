//
//  TagViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 22/10/21.
//

import UIKit

class TagViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    var viewTag: Tag?
    var activities: [Activity] = []
    var selectedActivity: Activity?
    
    private let activityCellIdentifier = "ActivityCardCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = viewTag?.name
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.tintColor = viewTag?.color
        initCollectionView()
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
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    /// Return the cell for a given index.
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: activityCellIdentifier, for: indexPath) as? ActivityCardCell
        
        // Set cell tag element:
        if let activity = activities.get(at: indexPath.row) {
            cell?.cellActivity = activity
        }
        
        return cell!
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let activity = activities.get(at: indexPath.row) {
            selectedActivity = activity
        }
        
        performSegue(withIdentifier: "goToOverview", sender: self)
    }
}

extension TagViewController: UICollectionViewDelegateFlowLayout {

    /// Return the item size for collection view.
    /// Use aspect ratio of 16:9 for two columns of items.
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Space between cells: (defined only here)
        let horizontalSpacing = CGFloat(10)
        // Space between cells and safe area (horizontally): (defined in the storyboard)
        let contentInsets = CGFloat(16) // defined in the storyboard
        // Width must be (totalWidth - 2 * contentInsets - horizontalSpacing) / 2
        let width: CGFloat = floor((collectionView.frame.size.width - 2 * contentInsets - horizontalSpacing) / 2)
        let height = width * (20 / 9)
        return CGSize(width: width, height: height)
    }
}
