//
//  ActivityFirebase.swift
//  geppetto
//
//  Created by Matheus Vicente on 07/07/21.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

typealias StringDictionary = [String: String]

/// Builds Activities from our database information
class ActivityConstructor {
    
    private static let MaxJsonFileSize: Int64 = 1000000
    private static let ActivitiesDirectory = "Activities"
    private static let JsonFilename = "info.json"
    private static let decoder = JSONDecoder()
    
    public static func getActivitiesData(completion: @escaping ([Activity]) -> Void) {
        let storageRef = Storage.storage().reference()
        let activitiesRef = storageRef.child(Self.ActivitiesDirectory)
        
        activitiesRef.listAll(completion: { activities, error in
            var activityStructs = [Activity]()
            for activity in activities.prefixes {
                let jsonRef = activity.child(Self.JsonFilename)
                jsonRef.getData(maxSize: Self.MaxJsonFileSize) { data, error in
                    guard let activityData = data else {
                        print(error!)
                        return
                    }
                    
                    guard let activityStruct = Self.buildActivityStruct(acitivityData: activityData) else {
                        return
                    }
                    
                    activityStructs.append(activityStruct)
                }
            }
            
            print(activityStructs)
            completion(activityStructs)
        })
    }
    
    public static func buildActivityStruct(acitivityData: Data) -> Activity? {
        do {
            let activity = try decoder.decode(Activity.self, from: acitivityData)
            return activity
        } catch {
            print("Error: failed to decode activity data to struct")
            return nil
        }
    }
    
    /// Builds a list of activity structs from data retrieved
    /// - Parameter data: information retrieved from `getAllActivitiesData()`
    /// - Returns: list of Activities built
    public static func buildStructs(data: DataSnapshot) -> [Activity] {
        var activities = [Activity]()
        
//        for activity in data.children {
//            guard let dataActivity = activity as? DataSnapshot else {
//                print("Error: could not cast from iterable element to snapshot")
//                continue
//            }
//
//            activities.append(buildActivityStruct(data: dataActivity))
//        }
        
//        return activities
        
        return []
    }
    
    /// Get all activities data from database
    /// - Parameter completion: function to run when information is retrieved
    public static func getAllActivitiesData(completion: @escaping (DataSnapshot) -> Void) {
        let databaseRef = Database.database().reference()
        databaseRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            completion(snapshot)
        })
    }
    
}
