//
//  ActivityFirebase.swift
//  geppetto
//
//  Created by Matheus Vicente on 07/07/21.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

/// Builds Activities from our database information.
/// Singleton class: use `ActivityConstructor.getInstance()` method.
class ActivityConstructor {
    
    // MARK: - Constants
    static let ActivitiesDirectory = "Activities"
    static let ActivityImageName = "overview"
    static let ImagesExtension = ".png"
    private static let MaxJsonFileSize: Int64 = 1000000
    private static let JsonFilename = "info.json"
    
    // MARK: - Properties
    private let decoder: JSONDecoder
    private var activities: [Activity]?
    
    // MARK: - Singleton Logic
    private static var instance: ActivityConstructor?
    
    static func getInstance() -> ActivityConstructor {
        if let constructor = Self.instance {
            return constructor
        } else {
            Self.instance = ActivityConstructor()
            return Self.instance!
        }
    }
    
    private init() {
        decoder = JSONDecoder()
    }
    
    // MARK: - Activity Construction Methods
    /// Runs completion with a list of all activities.
    func getActivities(completion: @escaping ([Activity]) -> Void) {
        if let activities = self.activities {
            completion(activities)
        } else {
            buildAllActivities(completion: completion)
        }
    }
    
    /// Get a list of activities from database files, build the list and run completion.
    private func buildAllActivities(completion: @escaping ([Activity]) -> Void) {
        let storageRef = Storage.storage().reference()
        let activitiesRef = storageRef.child(Self.ActivitiesDirectory)
        
        activitiesRef.listAll(completion: { activities, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            self.buildActivities(completion: completion, activities: activities)
        })
    }
    
    /// With the list of activities, build each struct and run completion.
    private func buildActivities(completion: @escaping ([Activity]) -> Void, activities: StorageListResult) {
        var activityStructs = [Activity]()
        let dispatchGroup = DispatchGroup()
        
        for activity in activities.prefixes {
            dispatchGroup.enter()
            let jsonRef = activity.child(Self.JsonFilename)
            jsonRef.getData(maxSize: Self.MaxJsonFileSize) { data, error in
                guard let activityData = data else {
                    print(error ?? "Error: could not get information for acitivity")
                    return
                }
                
                if let activityStruct = self.buildActivityStruct(acitivityData: activityData) {
                    activityStructs.append(activityStruct)
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activities = activityStructs
            completion(activityStructs)
        }
    }
    
    /// Build an `Activity` from a json `Data`.
    private func buildActivityStruct(acitivityData: Data) -> Activity? {
        do {
            let activity = try decoder.decode(Activity.self, from: acitivityData)
            return activity
        } catch {
            print("Error: failed to decode activity data to struct")
            return nil
        }
    }
    
}
