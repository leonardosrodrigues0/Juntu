//
//  ActivityFirebase.swift
//  geppetto
//
//  Created by Matheus Vicente on 07/07/21.
//

import Foundation
import FirebaseDatabase

class ActivityConstructor {
    
    // MARK: - Properties
    var firstScreenList = [String:String]()
    var materialsList = [String:String]()
    var stepsList = [String:[String:String]]()
    
    //MARK: - Methods
    func infoRequest (localization: String) {
        let databaseRef = Database.database().reference().child("activity list/\(localization)") //"activity of the week"
        
        databaseRef.observe(.childAdded, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String : Any] {
                
                switch snapshot.key {
                case "phases":
                    self.stepsList = dict as! [String : [String : String]]
                case "materials":
                    self.materialsList = dict as! [String: String]
                case "first screen":
                    self.firstScreenList = dict as! [String: String]
                default:
                    break
                }
            }
        })
    }
    
    func structConstructor() -> StructActivity {
        let lista = stepsList.values.map({$0})
        var stepActivity = [ActivityStep]()
        for step in lista {
            let newStep = ActivityStep(
                information: step["information"] ?? "",
                reference: step["reference"] ?? ""
            )
            stepActivity.append(newStep)
        }
        
        let newActivity = StructActivity(
            age: firstScreenList["age"] ?? "",
            caution: firstScreenList["caution"] ?? "",
            difficulty: firstScreenList["difficulty"] ?? "",
            introduction: firstScreenList["introduction"] ?? "",
            name: firstScreenList["name"] ?? "",
            time: firstScreenList["time"] ?? "",
            matererialList: materialsList.values.map({$0}),
            steps: stepActivity
        )
            
        
        return newActivity
    }
    
}




