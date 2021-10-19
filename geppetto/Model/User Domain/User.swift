//
//  User.swift
//  geppetto
//
//  Created by Erick Manaroulas Felipe on 19/10/21.
//

import Foundation

public class User: Codable {
    private var id = UUID()
    private var name: String = "none"
    private var profilePicture: String = "none"
    private var creationDate = Date()
    private var activity = UserActivity()
    
    public func seeActivity(_ activity: Activity) {
        self.activity.seeActivity(activity)
    }
    
    public func completeActivity(_ activity: Activity) {
        self.activity.completeActivity(activity)
    }
    
    public func toggleSaveActivity(_ activity: Activity) {
        self.activity.toggleSaveActivity(activity)
    }
}
