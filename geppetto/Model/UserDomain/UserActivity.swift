//
//  UserActivity.swift
//  geppetto
//
//  Created by Erick Manaroulas Felipe on 19/10/21.
//

import Foundation

public class UserActivity: Codable {

    private var savedActivities = [String]()
    private var activityHistory = [String]()
    private var completedActivities = [Activity]()
    // private var moments = Moments()
    
    // MARK: - Setters
    
    public func seeActivity(_ activity: Activity) {
        // check if activity is in history and bring it to the top of the stack
        if let index = activityHistory.firstIndex(where: { $0 == activity.id }) {
            activityHistory.remove(at: index)
        }
        
        activityHistory.append(activity.id)
    }
    
    public func completeActivity(_ activity: Activity) {
        completedActivities.append(activity)
    }
    
    public func toggleSaveActivity(_ activity: Activity) {
        // find and replace activity
        if let index = savedActivities.firstIndex(where: { $0 == activity.id }) {
            savedActivities.remove(at: index)
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
