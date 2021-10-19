//
//  UserTracker.swift
//  geppetto
//
//  Created by Erick Manaroulas Felipe on 19/10/21.
//

import Foundation

public class UserTracker {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("User.plist")
    
    // implementacao de singleton
    public static var tracker: UserTracker = {
        let instance = UserTracker()
        instance.loadUser()
        
        return instance
    }()
    
    private var user: User?
    
    private init() {}

    public func logSeenActivity(_ activity: Activity) {
        user?.seeActivity(activity)
        print("Logging seen activity: \(activity.name) on datapath \(String(describing: dataFilePath))")
        saveUser()
    }
    
    public func logCompletedActivity(_ activity: Activity) {
        user?.completeActivity(activity)
        print("Logging completed activity: \(activity.name) on datapath \(String(describing: dataFilePath))")
        saveUser()
    }
    
    public func logToggleSavedActivity(_ activity: Activity) {
        user?.toggleSaveActivity(activity)
        print("Logging saved activity: \(activity.name) on datapath \(String(describing: dataFilePath))")
        saveUser()
    }
    
    private func saveUser() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.user)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding User \n \(error)")
        }
    }
    
    private func loadUser() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                self.user = try decoder.decode(User.self, from: data)
            } catch {
                print("Error decoding User \n \(error)")
            }
        } else {
            self.user = createUser()
        }
    }
    
    private func createUser() -> User {
        let user = User()
        
        saveUser()
        
        return user
    }
}
