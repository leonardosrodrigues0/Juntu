import Foundation

public class User: Codable {
    
    // MARK: - Properties
    
    private var id = UUID()
    var name: String?
    private var profilePicture: String = "none"
    private var creationDate = Date()
    private var activity = UserActivity()
    
    // MARK: - Activity Delegation Methods
    
    func seeActivity(_ activity: Activity) {
        self.activity.seeActivity(activity)
    }
    
    func completeActivity(_ activity: Activity) {
        self.activity.completeActivity(activity)
    }
    
    func toggleSaveActivity(_ activity: Activity) {
        self.activity.toggleSaveActivity(activity)
    }
    
    func fetchActivityHistory() -> [String] {
        return activity.fetchActivityHistory()
    }
    
    func fetchSavedActivities() -> [String] {
        return activity.fetchSavedActivities()
    }
    
    func fetchIfActivityIsSaved(_ activity: Activity) -> Bool {
        return self.activity.fetchIfActivityIsSaved(activity)
    }
}
