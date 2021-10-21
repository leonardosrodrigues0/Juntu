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
    let directory: String
    let name: String
    let introduction: String
    let caution: String?
    let age: String
    let difficulty: String
    let time: String
    let materials: [String]
    
    // Steps are created when decoding database information.
    // At first call, they're updated with the activity directory and index.
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
    
    /// Add activity directory and index to steps.
    mutating private func updateSteps() {
        for index in 0 ..< steps.count {
            steps[index].updateStep(directory: directory, index: index + 1)
        }
    }
    
    func getDescription() -> String {
        return getAgeText()
    }
    
    func isResultWithSearchString(_ searchString: String) -> Bool {
        return name.lowercased().contains(searchString.lowercased())
    }
    
    func getAgeText() -> String {
        return "\(age) anos"
    }
    
    func getImageDatabaseRef() -> StorageReference {
        var path = ActivityConstructor.activitiesStorageDirectory
        path += "/\(directory)/"
        path += ActivityConstructor.activityImageName
        path += ActivityConstructor.imagesExtension
        return Storage.storage().reference().child(path)
    }
    
}
