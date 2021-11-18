import Foundation
import UIKit
import Promises

internal class MadeForYouActivitiesController: ActivitiesCollectionViewController {
    override func loadActivitiesPromise() -> Promise<[Activity]> {
        let database = ActivitiesDatabase.shared
        return database.getAllActivities().then { activities in
            self.activities = activities
            self.collectionView.reloadData()
        }
    }
}
