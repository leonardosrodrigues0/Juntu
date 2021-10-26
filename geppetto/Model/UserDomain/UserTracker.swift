//
//  UserTracker.swift
//  geppetto
//
//  Created by Erick Manaroulas Felipe on 19/10/21.
//

import Foundation
import UIKit

/// Is the main interface for interacting with the User
/// Singleton class: use `UserTracker.shared` attribute.
public class UserTracker {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("User.plist")
    
    let profilePictureFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("UserProfilePicture.png")
    
    let profilePictureName = "UserProfilePicture.png"
    
    // implementacao de singleton
    static var shared: UserTracker = {
        let instance = UserTracker()
        instance.loadUser()
        
        return instance
    }()
    
    private var user: User?
    
    private init() {}
    
    // MARK: - Methods for Logging User Activity
    
    func logSeenActivity(_ activity: Activity) {
        user?.seeActivity(activity)
        print("Logging seen activity: \(activity.name) on datapath \(String(describing: dataFilePath))")
        saveUser()
    }
    
    func logCompletedActivity(_ activity: Activity) {
        user?.completeActivity(activity)
        print("Logging completed activity: \(activity.name) on datapath \(String(describing: dataFilePath))")
        saveUser()
    }
    
    func logToggleSavedActivity(_ activity: Activity) {
        user?.toggleSaveActivity(activity)
        print("Logging saved activity: \(activity.name) on datapath \(String(describing: dataFilePath))")
        saveUser()
    }
    
    // MARK: - Methods for Reading User Activity
    
    func fetchActivityHistory() -> [String] {
        return user?.fetchActivityHistory() ?? [String]()
    }
    
    func fetchSavedActivities() -> [String] {
        return user?.fetchSavedActivities() ?? []
    }
    
    func fetchIfActivityIsSaved(_ activity: Activity) -> Bool {
        return user?.fetchIfActivityIsSaved(activity) ?? false
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
    
    private func saveProfileImage(image: UIImage) {
        if let data = image.pngData() {
            do {
                try data.write(to: self.profilePictureFilePath!)
            } catch {
                print("Unable to Write Image to Disk \(error)")
            }
        }
    }
    
    // MARK: - User Creation
    
    private func createUser() -> User {
        let user = User()
        
        saveUser()
        
        return user
    }
    
    // MARK: - Methods for Editing User Profile
    
    func wasUserCreated() -> Bool {
        return user?.name != nil
    }
    
    func editUserName(newName: String) {
        user?.name = newName
        saveUser()
    }
    
    func editUserProfilePicture(newImage: UIImage) {
        
    }
    
    // MARK: - Methods fo Reading User Profile
    
    func getUserName() -> String {
        return user?.name ?? ""
    }
    
    func loadProfilePicture() -> UIImage {
        let fm = FileManager.default
        
        if let imageData =  profilePictureFilePath {
            return UIImage(contentsOfFile: (profilePictureFilePath?.appendingPathComponent(profilePictureName).path)!) ??  UIImage(named: "momentsImage00")!
        } else {
            print("Error finding path content.")
        }
        
        return  UIImage(named: "momentsImage00")!
    }
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(profilePictureName)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedImage() -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(profilePictureName).path)
        }
        return nil
    }
    
}
