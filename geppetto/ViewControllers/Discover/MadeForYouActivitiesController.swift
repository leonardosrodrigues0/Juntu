import Foundation
import UIKit

internal class MadeForYouActivitiesController: ActivitiesCollectionViewController {
    override func loadActivitiesPromise() {
        let loadingHandler = LoadingHandler(parentView: collectionView)
        let database = ActivitiesDatabase.shared
        database.getAllActivities().then { activities in
            self.activities = activities
            self.collectionView.reloadData()
            loadingHandler.stop()
        }
    }
}
