//
//  ActivityStep.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 05/07/21.
//

import Foundation
import FirebaseStorage

public struct ActivityStep: Codable {
    
    // MARK: - Properties
    var information: String
    var reference: String?
    var activityId: String?
    var stepIndex: Int?
    
    // MARK: - Methods
    mutating func updateStep(id: String, index: Int) {
        activityId = id
        stepIndex = index
    }
    
    func getImageDatabaseRef() -> StorageReference? {
        guard let id = activityId, let index = stepIndex else {
            print("Error: failed to get reference for step image")
            return nil
        }
        
        var path = ActivityConstructor.ActivitiesDirectory
        path += "/\(id)/"
        path += String(format: "%02d", index)
        path += ActivityConstructor.ImagesExtension
        return Storage.storage().reference().child(path)
    }
}
