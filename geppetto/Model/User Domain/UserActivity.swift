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
    
    public func seeActivity(_ activity: Activity) {
        activityHistory.append(activity)
    }
    
    public func completeActivity(_ activity: Activity) {
        completedActivities.insert(activity, at: 0)
    }
    
    public func toggleSaveActivity(_ activity: Activity) {
        // find and replace activity
        for i in  0...savedActivities.count {
            if savedActivities[i].name == activity.name {
                savedActivities.remove(at: i)
                return
            }
        }
        
        savedActivities.append(activity)
    }

}
