//
//  Activity.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 30/06/21.
//

import Foundation
import FirebaseStorage

public struct Activity: Searchable, Codable {
    
    // MARK: - Properties
    let id: String
    let name: String
    let introduction: String
    let caution: String?
    let age: String
    let difficulty: String
    let time: String
    let materials: [String]
    
    // Steps are created when decoding database information.
    // At first call, they're updated with the activity id and index.
    private var steps: [ActivityStep]
    private var didUpdateSteps: Bool?
    
    // MARK: - Methods
    /// Update steps if needed and return them.
    mutating func getSteps() -> [ActivityStep] {
        if let update = didUpdateSteps, update {
            return steps
        } else {
            updateSteps()
            didUpdateSteps = true
            return steps
        }
    }
    
    /// Add activity id and index to steps.
    mutating private func updateSteps() {
        for index in 0 ..< steps.count {
            steps[index].updateStep(id: id, index: index + 1)
        }
    }
    
    func getDescription() -> String {
        return age
    }
    
    func isResultWithSearchString(_ searchString: String) -> Bool {
        return name.lowercased().contains(searchString.lowercased())
    }
    
    func getImageDatabaseRef() -> StorageReference {
        var path = ActivityConstructor.ActivitiesDirectory
        path += "/\(id)/"
        path += ActivityConstructor.ActivityImageName
        path += ActivityConstructor.ImagesExtension
        return Storage.storage().reference().child(path)
    }
    
}
