//
//  UserActivity.swift
//  geppetto
//
//  Created by Erick Manaroulas Felipe on 19/10/21.
//

import Foundation

public class UserActivity: Codable {
    private var activityHistory = [Activity]()
    private var savedActivities = [Activity]()
    private var completedActivities = [Activity]()
    // private var moments = Moments()
    
    // MARK: - Setters
    
    public func seeActivity(_ activity: Activity) {
        // check if activity is in history and bring it to the top of the stack
        if let index = activityHistory.firstIndex(where: { $0.name == activity.name }) {
            activityHistory.remove(at: index)
        }
        
        activityHistory.append(activity)
    }
    
    public func completeActivity(_ activity: Activity) {
        completedActivities.append(activity)
    }
    
    public func toggleSaveActivity(_ activity: Activity) {
        // find and replace activity
        if let index = savedActivities.firstIndex(where: { $0.name == activity.name }) {
            savedActivities.remove(at: index)
            return
        }

        savedActivities.append(activity)
    }
    
    // MARK: - Getters

    public func fetchActivityHistory() -> [Activity] {
        return activityHistory.reversed()
    }
}
