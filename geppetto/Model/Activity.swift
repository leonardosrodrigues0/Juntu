//
//  Activity.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 30/06/21.
//

import Foundation
import FirebaseStorage
import Promises

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
    let tags: [String]?
    private(set) var steps: [ActivityStep]
    
    // MARK: - Methods
    mutating func getSteps() -> [ActivityStep] {
        return steps
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
    
    /// Add activity directory and index to steps. Used at initialization.
    mutating private func updateSteps() {
        for index in 0 ..< steps.count {
            steps[index].updateStep(directory: directory, index: index + 1)
        }
    }
    
    // MARK: - Decodable
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        // Decode basic properties:
        id = try values.decode(String.self, forKey: .id)
        directory = try values.decode(String.self, forKey: .directory)
        name = try values.decode(String.self, forKey: .name)
        introduction = try values.decode(String.self, forKey: .introduction)
        caution = try? values.decode(String.self, forKey: .caution)
        age = try values.decode(String.self, forKey: .age)
        difficulty = try values.decode(String.self, forKey: .difficulty)
        time = try values.decode(String.self, forKey: .time)
        materials = try values.decode([String].self, forKey: .materials)

        // Decode tags:
        tags = try? values.decode([String].self, forKey: .tags)

        // Decode and update steps:
        steps = try values.decode([ActivityStep].self, forKey: .steps)
        updateSteps()
    }
}
