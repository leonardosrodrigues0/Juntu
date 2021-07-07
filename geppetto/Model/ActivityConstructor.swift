//
//  ActivityFirebase.swift
//  geppetto
//
//  Created by Matheus Vicente on 07/07/21.
//

import Foundation
import FirebaseDatabase

typealias StringDictionary = [String:String]

class ActivityConstructor {
    
    //MARK: - Static Methods
    public static func getAllActivities() -> [StructActivity] {
        let names = getAllActivitiesNames()
        return names.map({ getActivity(localization: $0 ) })
    }
    
    public static func getActivity(localization: String) -> StructActivity {
        var information = StringDictionary()
        var materials = StringDictionary()
        var steps = [String: StringDictionary]()
        
        // Get information from firebase.
        let databaseRef = Database.database().reference().child("activity list/\(localization)") //"activity of the week"
        
        databaseRef.observe(.childAdded, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                switch snapshot.key {
                case "phases":
                    steps = dict as! [String: StringDictionary]
                case "materials":
                    materials = dict as! StringDictionary
                case "first screen":
                    information = dict as! StringDictionary
                default:
                    break
                }
            }
        })
        
        // Build struct.
        return buildActivityStruct(information: information, materials: materials, steps: steps)
    }
    
    public static func getAllActivitiesNames() -> [String] {
        var names = [String]()
        
        let databaseRef = Database.database().reference().child("activity list")
        databaseRef.observe(.childAdded, with: { (snapshot) in
            print(snapshot.key)
            names.append(snapshot.key)
        })
        
        return names
    }
    
    private static func buildActivityStruct(information: StringDictionary, materials: StringDictionary, steps: [String: StringDictionary]) -> StructActivity {
        let stepList = steps.values.map({$0})
        var activitySteps = [ActivityStep]()
        
        for step in stepList {
            let newStep = ActivityStep(
                information: step["information"] ?? "",
                reference: step["reference"] ?? ""
            )
            
            activitySteps.append(newStep)
        }
        
        let newActivity = StructActivity(
            age: information["age"] ?? "",
            caution: information["caution"] ?? "",
            difficulty: information["difficulty"] ?? "",
            introduction: information["introduction"] ?? "",
            name: information["name"] ?? "",
            time: information["time"] ?? "",
            matererialList: materials.values.map({$0}),
            steps: activitySteps
        )
            
        return newActivity
    }
    
}




