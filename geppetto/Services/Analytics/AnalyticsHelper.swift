import Foundation
import Firebase

class AnalyticsHelper {
    
    // MARK: - Properties
    
    private var startTime: Double
    
    // MARK: - Initializers
    
    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    // MARK: - Auxiliary Methods
    
    func getTimeFromStart() -> Double {
        return CFAbsoluteTimeGetCurrent() - startTime
    }
    
    func resetTimer() {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    // MARK: - Analytics Events
    
    func logAppOpen() {
        Analytics.logEvent("app_open", parameters: [
            "load_time": getTimeFromStart()
        ])
    }
    
    func logDiveInPressed(activity: Activity) {
        Analytics.logEvent("dive_in_pressed", parameters: [
            "screen_view_time": getTimeFromStart(),
            "activity": activity.name
        ])
    }
    
    func logViewedActivity(_ activity: Activity) {
        Analytics.logEvent("activity_viewed", parameters: [
            "load_time": getTimeFromStart(),
            "activity": activity.name
        ])
    }
    
    func logSavedActivity(_ activity: Activity) {
        Analytics.logEvent("activity_saved", parameters: [
            "activity": activity.name
        ])
    }
    
    func logViewedFinalStep(activity: Activity) {
        Analytics.logEvent("viewed_final_step", parameters: [
            "screen_view_time": getTimeFromStart(),
            "activity": activity.name
        ])
    }
    
    func logEditedProfile() {
        Analytics.logEvent("edited_profile", parameters: [
            "time_spent": getTimeFromStart()
        ])
    }
    
    func logViewedMomentsImage(at index: Int, collectionSize: Int) {
        Analytics.logEvent("view_moments_image", parameters: [
            "image_index": index,
            "collection_size": collectionSize
        ])
    }
}
