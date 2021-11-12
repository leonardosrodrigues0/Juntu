import Foundation
import UIKit

protocol SimilarActivitiesDelegate: AnyObject {
    func similarActivities(_ controller: SimilarActivitiesController, didEndLoad: Bool)
}

internal class SimilarActivitiesController: ActivitiesCollectionViewController {
    
    // MARK: - Properties
    
    var similarTo: Activity!
    weak var delegate: SimilarActivitiesDelegate?
    
    // MARK: - Methods
    
    override func loadActivitiesPromise() {
        let loadingHandler = LoadingHandler(parentView: collectionView)
        let database = ActivitiesDatabase.shared
        database.getAllActivities().then { activities in
            let similarActivities = self.orderBySimilarity(activities)
            self.activities = similarActivities
            self.collectionView.reloadData()
            loadingHandler.stop()
            self.delegate?.similarActivities(self, didEndLoad: true)
        }
    }
    
    func orderBySimilarity(_ activities: [Activity]) -> [Activity] {
        if let similarTags = similarTo.tags {
            let filtered = activities.filter { $0.id != similarTo.id && $0.tags?.contains(where: similarTags.contains) ?? false }
            return filtered.sorted(by: sorterActivitiesByTagsInCommom)
        }
        return activities
    }
    
    /// Sort activities by the amount of tags in common - alls tags have the same importance
    private func sorterActivitiesByTagsInCommom(this: Activity, that: Activity) -> Bool {
        if let similarTags = similarTo.tags {
            let thisTagsInCommon = this.tags?.filter(similarTags.contains).count ?? 0
            let thatTagsInCommon = that.tags?.filter(similarTags.contains).count ?? 0
            return thisTagsInCommon > thatTagsInCommon
        }
        return false
    }
}
