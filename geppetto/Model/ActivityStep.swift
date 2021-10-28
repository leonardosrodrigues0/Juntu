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
    var activityDirectory: String?
    var stepIndex: Int?
    
    // MARK: - Methods
    mutating func updateStep(directory: String, index: Int) {
        activityDirectory = directory
        stepIndex = index
    }
    
    func getImageDatabaseRef() -> StorageReference? {
        guard let directory = activityDirectory, let index = stepIndex else {
            print("Error: failed to get reference for step image")
            return nil
        }
        
        var path = ActivityConstructor.activitiesStorageDirectory
        path += "/\(directory)/"
        path += String(format: "%02d", index)
        path += ActivityConstructor.imagesExtension
        return Storage.storage().reference().child(path)
    }
}
