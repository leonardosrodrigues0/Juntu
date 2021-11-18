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
    let minAge: Int
    let maxAge: Int
    let minTime: Int
    let maxTime: Int?
    let timeUnit: TimeUnit
    let difficulty: String
    let materials: [String]
    let tags: [String]?
    private(set) var steps: [ActivityStep]
    
    var minMaxAge: String {
        return "\(minAge) a \(maxAge)"
    }
    
    var fullAgeText: String {
        return "\(minMaxAge) anos"
    }
    
    var minMaxTime: String {
        if let maxTime = maxTime {
            return "\(minTime) a \(maxTime)"
        } else {
            return "\(minTime)"
        }
    }
    
    var fullTimeText: String {
        return "\(minMaxTime) \(timeUnit.rawValue)"
    }
    
    // MARK: - Methods
    
    mutating func getSteps() -> [ActivityStep] {
        return steps
    }
    
    func getDescription() -> String {
        return fullAgeText
    }
    
    func isResultWithSearchString(_ searchString: String) -> Bool {
        return name.lowercased().contains(searchString.lowercased())
    }
    
    func getImageDatabaseRef() -> StorageReference {
        var path = ActivitiesDatabase.activitiesStorageDirectory
        path += "/\(directory)/"
        path += ActivitiesDatabase.activityImageName
        path += ActivitiesDatabase.imagesExtension
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
        minAge = try values.decode(Int.self, forKey: .minAge)
        maxAge = try values.decode(Int.self, forKey: .maxAge)
        
        difficulty = try values.decode(String.self, forKey: .difficulty)
        minTime = try values.decode(Int.self, forKey: .minTime)
        maxTime = try? values.decode(Int.self, forKey: .maxTime)
        timeUnit = TimeUnit(
            rawValue: try values.decode(String.self, forKey: .timeUnit)
        ) ?? TimeUnit.minutes
        materials = try values.decode([String].self, forKey: .materials)

        // Decode tags:
        tags = try? values.decode([String].self, forKey: .tags)

        // Decode and update steps:
        steps = try values.decode([ActivityStep].self, forKey: .steps)
        updateSteps()
    }
}
