//
//  ActivityFirebase.swift
//  geppetto
//
//  Created by Matheus Vicente on 07/07/21.
//

import Foundation
import FirebaseDatabase

typealias StringDictionary = [String: String]

class ActivityConstructor {
    
    //MARK: - Static Methods
    public static func buildStructs(data: DataSnapshot) -> [Activity] {
        var activities = [Activity]()
        
        for activity in data.children {
            guard let dataActivity = activity as? DataSnapshot else {
                print("Error: could not cast from iterable element to snapshot")
                continue
            }
            
            activities.append(buildActivityStruct(data: dataActivity))
        }
        
        return activities
    }
    
    public static func buildActivityStruct(data: DataSnapshot) -> Activity {
        var name = ""
        var imageName = ""
        var time = ""
        var difficulty = ""
        var age = ""
        var caution = ""
        var introduction = ""
        var materials = [String]()
        var steps = [ActivityStep]()
        
        for information in data.children {
            guard let dataInfo = information as? DataSnapshot else {
                print("Error: could not cast from iterable element to snapshot")
                continue
            }
            
            switch dataInfo.key {
            case "overview":
                for firstScreenInfo in dataInfo.children {
                    guard let dataFirstScreenInfo = firstScreenInfo as? DataSnapshot else {
                        print("Error: could not cast from iterable element to snapshot")
                        continue
                    }
                    
                    let stringValue = dataFirstScreenInfo.value as? String ?? ""
                    
                    switch dataFirstScreenInfo.key {
                    case "age":
                        age = stringValue
                    case "caution":
                        caution = stringValue
                    case "difficulty":
                        difficulty = stringValue
                    case "introduction":
                        introduction = stringValue
                    case "name":
                        name = stringValue
                    case "imageName":
                        imageName = stringValue
                    case "time":
                        time = stringValue
                    default:
                        print("Error: invalid key for overview items: \(dataFirstScreenInfo.key)")
                    }
                }
                
            case "materials":
                for materialInfo in dataInfo.children {
                    guard let dataMaterialinfo = materialInfo as? DataSnapshot else {
                        print("Error: could not cast from iterable element to snapshot")
                        continue
                    }
                    
                    let materialString = dataMaterialinfo.value as? String ?? ""
                    materials.append(materialString)
                }
                
            case "phases":
                for step in dataInfo.children {
                    guard let dataStep = step as? DataSnapshot else {
                        print("Error: could not cast from iterable element to snapshot")
                        continue
                    }
                    
                    steps.append(parseStep(dataStep: dataStep))
                }
                
            default:
                print("Error: key not found")
            }
        }
        
        return Activity(
            name: name,
            imageName: imageName,
            time: time,
            difficulty: difficulty,
            age: age,
            caution: caution,
            introduction: introduction,
            materialList: materials,
            steps: steps
        )
    }
    
    private static func parseStep(dataStep: DataSnapshot) -> ActivityStep {
        var imageName = ""
        var information = ""
        var reference = ""
        
        for stepInfo in dataStep.children {
            guard let dataStepInfo = stepInfo as? DataSnapshot else {
                print("Error: could not cast from iterable element to snapshot")
                continue
            }
            
            let stringValue = dataStepInfo.value as? String ?? ""
            
            switch dataStepInfo.key {
            case "imageName":
                imageName = stringValue
            case "information":
                information = stringValue
            case "reference":
                reference = stringValue
            default:
                print("Error: invalid key for step information: \(dataStepInfo.key)")
            }
        }
        
        return ActivityStep(imageName: imageName, information: information, reference: reference)
    }
    
    public static func getAllActivitiesData(completion: @escaping (DataSnapshot) -> Void) {
        let databaseRef = Database.database().reference()
        databaseRef.observeSingleEvent(of: .childAdded, with: { (snapshot) in
            completion(snapshot)
        })
    }
}
