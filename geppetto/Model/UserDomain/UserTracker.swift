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
    
    let dataPlistFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("User.plist")
    
    var profilePictureFilePath: URL
    let profilePictureName = "UserProfilePicture.png"
    
    var profilePictureFolderDatapath: URL = { () -> URL in
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let folderDataPath = docURL.appendingPathComponent("ProfilePicture")
        if !FileManager.default.fileExists(atPath: folderDataPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: folderDataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        return folderDataPath
    }()
    
    // implementacao de singleton
    static var shared: UserTracker = {
        let instance = UserTracker()
        instance.loadUser()
        return instance
    }()
    
    private var user: User?
    
    private init() {
        self.profilePictureFilePath = self.profilePictureFolderDatapath.appendingPathComponent(self.profilePictureName)
    }
    
    // MARK: - Methods for Logging User Activity
    
    func logSeenActivity(_ activity: Activity) {
        user?.seeActivity(activity)
        print("Logging seen activity: \(activity.name) on datapath \(String(describing: dataPlistFilePath))")
        saveUser()
    }
    
    func logCompletedActivity(_ activity: Activity) {
        user?.completeActivity(activity)
        print("Logging completed activity: \(activity.name) on datapath \(String(describing: dataPlistFilePath))")
        saveUser()
    }
    
    func logToggleSavedActivity(_ activity: Activity) {
        user?.toggleSaveActivity(activity)
        print("Logging saved activity: \(activity.name) on datapath \(String(describing: dataPlistFilePath))")
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
            try data.write(to: self.dataPlistFilePath!)
        } catch {
            print("Error encoding User \n \(error)")
        }
    }
    
    private func loadUser() {
        if let data = try? Data(contentsOf: dataPlistFilePath!) {
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
    
    private func saveImage(image: UIImage) {
        let data = image.jpegData(compressionQuality: 1) ?? image.pngData()
        do {
            try data!.write(to: URL(fileURLWithPath: profilePictureFilePath.path))
        } catch {
            print(error.localizedDescription)
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
        saveImage(image: newImage)
    }
    
    // MARK: - Methods for Reading User Profile
    
    func getUserName() -> String {
        return user?.name ?? ""
    }
    
    func getProfilePicture() -> UIImage? {
        return UIImage(contentsOfFile: profilePictureFilePath.path)
    }
}
