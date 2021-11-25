import Foundation
import UIKit

/// Is the main interface for interacting with the User
/// Singleton class: use `UserTracker.shared` attribute.
class UserTracker {
    
    // MARK: - Static attributes and Methods for Data Persistence
    
    static private let documentsDirectory: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    static private let profilePictureFolderName = "ProfilePicture"
    static private let picturesFolderName = "Pictures"
    static private let profilePictureName = "UserProfilePicture.png"
    static private let profilePictureFolderDataPath = getFolderDataPath(profilePictureFolderName)
    static private let picturesFolderDataPath = getFolderDataPath(picturesFolderName)
    
    static private func getFolderDataPath(_ folderName: String) -> URL {
        let folderDataPath = UserTracker.documentsDirectory!.appendingPathComponent(folderName)
        if !FileManager.default.fileExists(atPath: folderDataPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: folderDataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Unable to create new directory to Disk: \(error.localizedDescription)")
            }
        }
        return folderDataPath
    }
    
    // MARK: - Properties for Data Persistence
    
    private let dataPlistFilePath = documentsDirectory?.appendingPathComponent("User.plist")
    private let profilePictureFilePath = profilePictureFolderDataPath.appendingPathComponent(profilePictureName)
    private var newSavedPictureFilePath: URL {
        UserTracker.picturesFolderDataPath.appendingPathComponent("\(Date()).png")
    }
    
    private var user: User?
    
    // MARK: - Initializers
    
    /// Singleton instance.
    static var shared: UserTracker = {
        let instance = UserTracker()
        instance.loadUser()
        return instance
    }()
    
    // MARK: - Methods for Logging User Activity
    
    func logSeenActivity(_ activity: Activity) {
        user?.seeActivity(activity)
        print("Logging seen activity: \(activity.name) on data path \(String(describing: dataPlistFilePath))")
        saveUser()
    }
    
    func logCompletedActivity(_ activity: Activity) {
        user?.completeActivity(activity)
        print("Logging completed activity: \(activity.name) on data path \(String(describing: dataPlistFilePath))")
        saveUser()
    }
    
    func logToggleSavedActivity(_ activity: Activity) {
        user?.toggleSaveActivity(activity)
        print("Logging saved activity: \(activity.name) on data path \(String(describing: dataPlistFilePath))")
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
    
    /// Save an image to the user moments.
    private func saveImage(_ image: UIImage, at pathURL: URL) {
        let data = image.jpegData(compressionQuality: 1) ?? image.pngData()
        do {
            try data!.write(to: URL(fileURLWithPath: pathURL.path))
            print("Logging saved image on data path  \(pathURL.path)")
        } catch {
            print("Unable to Write Data to Disk \(error.localizedDescription)")
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
        saveImage(newImage, at: profilePictureFilePath)
    }
    
    // MARK: - Methods for handling Moments
    
    func savePicture(_ image: UIImage) {
        saveImage(image, at: newSavedPictureFilePath)
    }
    
    func getAllMomentsPictures() -> [Data] {
        var images = [Data]()
        
        let fm = FileManager.default
        
        do {
            var imagePaths = try fm.contentsOfDirectory(
                at: UserTracker.picturesFolderDataPath,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            
            imagePaths.sort { $0.lastPathComponent > $1.lastPathComponent }
            
            for imagePath in imagePaths {
                if imagePath.path.hasSuffix("png") {
                    if let imageData = fm.contents(atPath: imagePath.path) {
                        images.append(imageData)
                    } else {
                        print("Error finding path content.")
                    }
                }
            }
            
        } catch {
            print("Error finding imagePaths: \(error)")
        }
        
        return images
    }
    
    // MARK: - Methods for Reading User Profile
    
    func getUserName() -> String {
        return user?.name ?? ""
    }
    
    func getProfilePicture() -> UIImage? {
        return UIImage(contentsOfFile: profilePictureFilePath.path)
    }
}
