//
//  ActivityFirebase.swift
//  geppetto
//
//  Created by Matheus Vicente on 07/07/21.
//

import Foundation
import FirebaseDatabase
import Promises

/// Builds Activities from our database information.
/// Singleton class: use `ActivityConstructor.shared` attribute.
class ActivityConstructor {
    
    // MARK: - Constants
    static let activitiesStorageDirectory = "Activities"
    static let activityImageName = "overview"
    static let imagesExtension = ".png"
    private static let databaseActivitiesChild = "activities-with-id"
    private static let activities: [String: Activity]? = nil
    
    // MARK: - Properties
    private let decoder: JSONDecoder
    private var activities: [String: Activity]?
    
    // MARK: - Singleton Logic
    public static var shared: ActivityConstructor = {
        let instance = ActivityConstructor()
        return instance
    }()
    
    private init() {
        decoder = JSONDecoder()
    }
    
    // MARK: - Database Queries
    /// Get all activities from database and return them as dictionary with id as key.
    func getAllActivitiesAsDictionary() -> Promise<[String: Activity]> {
        return Promise { fulfill, _ in
            if self.activities == nil {
                let query = Database.database().reference()
                    .child(Self.databaseActivitiesChild)
                    .queryOrderedByKey()
                
                query.getData { _, data in
                    self.activities = self.buildActivitiesFromDataSnapshot(data: data)
                    fulfill(self.activities ?? [:])
                }
            } else {
                fulfill(self.activities ?? [:])
            }
        }
    }
    
    /// Get all activities from database and return them as Array
    func getAllActivities() -> Promise<[Activity]> {
        return getAllActivitiesAsDictionary().then { activitiesAsDictionary in
            self.activitiesDictionaryToArray(activitiesAsDictionary) ?? []
        }
    }
    
    /// Get a dictionary of activities filtered by ids. If self.activities is nil, load from firebase
    func getActivities(ids: [String]) -> Promise<[Activity]> {
        return getAllActivitiesAsDictionary().then { activitiesAsDictionary in
            activitiesAsDictionary.filter { ids.contains($0.key) }
        }.then { filtered in
            self.activitiesDictionaryToArray(filtered) ?? []
        }
    }
 
    /// Get a dictionary of activities filtered by ids. If self.activities is nil, load from firebase
    func getActivity(id: String) -> Promise<Activity?> {
        return Promise { fulfill, _ in
            let query = Database.database().reference()
                .child(Self.databaseActivitiesChild)
                .queryOrderedByKey()
                .queryEqual(toValue: id)
            
            query.getData { _, data in
                let activities = self.activitiesDictionaryToArray(self.buildActivitiesFromDataSnapshot(data: data))
                
                // Should reject with Error
                guard activities != nil && !activities!.isEmpty else {
                    fulfill(nil)
                    return
                }
                
                fulfill(activities![0])
            }
        }
    }
    
    // MARK: - Activity Builder Methods
    /// With the DataSnapshot of the database activities, build a dictionary with each Activity.
    private func buildActivitiesFromDataSnapshot(data: DataSnapshot) -> [String: Activity]? {
        if let safeActivities = data.value as? [String: Any] {
            let activities = safeActivities.mapValues { (activity) -> Activity in
                let activityData = try? JSONSerialization.data(withJSONObject: activity, options: .prettyPrinted)
                let activityStruct = self.buildActivityStruct(activityData: activityData!)
                return activityStruct!
            }
            return activities
        }
        return nil
    }
    
    /// Build an `Activity` from a json `Data`.
    private func buildActivityStruct(activityData: Data) -> Activity? {
        do {
            let activity = try decoder.decode(Activity.self, from: activityData)
            return activity
        } catch {
            print("Error: failed to decode activity data to struct")
            return nil
        }
    }
    
    /// Convert activities dictionary to array
    private func activitiesDictionaryToArray(_ dictionary: [String: Activity]?) -> [Activity]? {
        if let safeActivities = dictionary {
            return Array(safeActivities.values)
        }
        return nil
    }
}
