//
//  UserTracker.swift
//  geppetto
//
//  Created by Erick Manaroulas Felipe on 19/10/21.
//

import Foundation

/// Is the main interface for interacting with the User
/// Singleton class: use `UserTracker.shared` attribute.
public class UserTracker {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("User.plist")
    
    // implementacao de singleton
    public static var shared: UserTracker = {
        let instance = UserTracker()
        instance.loadUser()
        
        return instance
    }()
    
    private var user: User?
    
    private init() {}

    // MARK: - Methods for Logging User Activity
    
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
    
    // MARK: - Methods for Reading User Activity
    
    public func fetchActivityHistory() -> [Activity] {
        return user?.fetchActivityHistory() ?? [Activity]()
    }
    
    // MARK: - Data Persistence Methods
    
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
    
    // MARK: - User Creation
     
    private func createUser() -> User {
        let user = User()
        
        saveUser()
        
        return user
    }
}
