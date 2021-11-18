import Foundation

public class UserActivity: Codable {

    // MARK: - Properties
    
    private var savedActivities = [String]()
    private var activityHistory = [String]()
    private var completedActivities = [Activity]()
    
    // MARK: - Setters
    
    /// Add activity to the history.
    public func seeActivity(_ activity: Activity) {
        if let index = activityHistory.firstIndex(where: { $0 == activity.id }) {
            activityHistory.remove(at: index)
        }
        
        activityHistory.append(activity.id)
    }
    
    public func completeActivity(_ activity: Activity) {
        completedActivities.append(activity)
    }
    
    /// Look for activity in saved. Remove if present and add otherwise.
    public func toggleSaveActivity(_ activity: Activity) {
        if let index = savedActivities.firstIndex(where: { $0 == activity.id }) {
            savedActivities.remove(at: index)
            return
        }

        savedActivities.append(activity.id)
    }
    
    // MARK: - Getters

    public func fetchActivityHistory() -> [String] {
        return activityHistory.reversed()
    }
    
    public func fetchSavedActivities() -> [String] {
        return savedActivities.reversed()
    }
    
    public func fetchIfActivityIsSaved(_ activity: Activity) -> Bool {
        if savedActivities.firstIndex(where: { $0 == activity.id }) != nil {
            return true
        }
        
        return false
    }
}
