import Foundation

class UserActivity: Codable {

    // MARK: - Properties
    
    private var savedActivities = [String]()
    private var activityHistory = [String]()
    private var completedActivities = [Activity]()
    
    // MARK: - Setters
    
    /// Add activity to the history.
    func seeActivity(_ activity: Activity) {
        if let index = activityHistory.firstIndex(where: { $0 == activity.id }) {
            activityHistory.remove(at: index)
        }
        
        activityHistory.append(activity.id)
    }
    
    func completeActivity(_ activity: Activity) {
        completedActivities.append(activity)
    }
    
    /// Look for activity in saved. Remove if present and add otherwise.
    func toggleSaveActivity(_ activity: Activity) {
        if let index = savedActivities.firstIndex(where: { $0 == activity.id }) {
            savedActivities.remove(at: index)
            return
        }

        savedActivities.append(activity.id)
    }
    
    // MARK: - Getters

    func fetchActivityHistory() -> [String] {
        return activityHistory.reversed()
    }
    
    func fetchSavedActivities() -> [String] {
        return savedActivities.reversed()
    }
    
    func fetchIfActivityIsSaved(_ activity: Activity) -> Bool {
        if savedActivities.firstIndex(where: { $0 == activity.id }) != nil {
            return true
        }
        
        return false
    }
}
