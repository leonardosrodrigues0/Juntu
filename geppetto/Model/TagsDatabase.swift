//
//  TagConstructor.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 19/10/21.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

/// Builds tags from our database information.
/// Singleton class: use `TagsDatabase.shared` to get instance.
struct TagsDatabase {
    
    // MARK: - Constants
    static let picturesDirectory = "TagPictures"
    static let imagesExtension = ".png"
    private static let databaseTagsChild = "tags"
    
    // MARK: - Properties
    private let decoder: JSONDecoder
    private var tags: [Tag]?
    
    // MARK: - Singleton Logic
    /// TagConstructor singleton instance.
    public static var shared = TagsDatabase()
    
    private init() {
        decoder = JSONDecoder()
    }
    
    // MARK: - Tag Construction Methods
    func getTags(completion: @escaping ([Tag]) -> Void) {
        if let tags = self.tags {
            completion(tags)
        } else {
            buildAllTags(completion: completion)
        }
    }
    
    private func buildAllTags(completion: @escaping ([Tag]) -> Void) {
        let databaseRef = Database.database().reference()
        databaseRef.child(Self.databaseTagsChild).getData { _, data in
            let info = data.value as? NSArray
            self.buildTags(completion: completion, tags: info!)
        }
    }
    
    private func buildTags(completion: @escaping ([Tag]) -> Void, tags: NSArray) {
        let tagStructs = tags.map { (tag) -> Tag in
            let tagData = try? JSONSerialization.data(withJSONObject: tag, options: .prettyPrinted)
            let tagStruct = self.buildTagStruct(tagData: tagData!)
            return tagStruct!
        }
        
        // Dispatch to main thread as it's the only that can create frames.
        DispatchQueue.main.async {
            completion(tagStructs)
        }
    }
    
    private func buildTagStruct(tagData: Data) -> Tag? {
        do {
            let tag = try decoder.decode(Tag.self, from: tagData)
            return tag
        } catch {
            print("Error: failed to decode tag data to struct")
            return nil
        }

    }
}
