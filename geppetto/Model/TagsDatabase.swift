//
//  TagConstructor.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 19/10/21.
//

import Foundation
import FirebaseDatabase
import Promises

/// Builds tags from our database information.
/// Singleton class: use `TagsDatabase.shared` to get instance.
class TagsDatabase {
    
    // MARK: - Constants
    static let picturesDirectory = "TagPictures"
    static let imagesExtension = ".png"
    private static let databaseTagsChild = "tags"
    
    // MARK: - Properties
    private let decoder: JSONDecoder
    private var tags: [Tag]?
    
    // MARK: - Singleton Logic
    /// TagConstructor singleton instance.
    public static var shared: TagsDatabase = {
        let instance = TagsDatabase()
        return instance
    }()
    
    private init() {
        decoder = JSONDecoder()
    }
    
    // MARK: - Tag Construction Methods
    func getTags(withIds ids: [String]) -> Promise<[Tag]> {
        getTags { ids.contains($0.id) }
    }
    
    func getTag(withId id: String) -> Promise<Tag> {
        return Promise { fulfill, _ in
            self.getAllTags().then { allTags in
                let tag = allTags.filter { $0.id == id }
                fulfill(tag.first!)
            }
        }
    }
    
    /// Get tags filtered.
    /// - Parameter filter: function that indicates if the tag should be in the return.
    func getTags(where filter: @escaping (Tag) -> Bool) -> Promise<[Tag]> {
        getAllTags().then { allTags in
            allTags.filter(filter)
        }
    }
    
    /// Return a promise to all tags in database.
    func getAllTags() -> Promise<[Tag]> {
        if let tags = self.tags {
            return Promise { fulfill, _ in
                fulfill(tags)
            }
        } else {
            return buildAllTags()
        }
    }
    
    /// Get a Promise to a dictionary with tagID as key and a tuple (tag, activities) as value.
    /// key: tag identifier (tagID)
    /// tag: owner of this tagID
    /// activities:  list of Activities that have this tag as one of their tags.
    private func getTagsAndActivitiesGroupedByTagId() -> Promise<[String: (tag: Tag, activities: [Activity])]> {
        var activitiesGroupByTag: [String: (tag: Tag, activities: [Activity])] = [:]
        var tagIds: [String] = []
        return getAllTags().then { allTags in
            tagIds = allTags.map { $0.id }
            return all(allTags.map { $0.getTagActivities() })
            .then { tagActivities in
                for i in 0..<tagIds.count {
                    let activities = tagActivities[i]
                    let tag = allTags[i]
                    let id = tagIds[i]
                    activitiesGroupByTag[id] = (tag: tag, activities: activities)
                }
                return Promise(activitiesGroupByTag)
            }
        }
    }
    
    /// Get a Promise to all Tags that contain at least one Activity
    func getNonEmptyTags() -> Promise<[Tag]> {
        return getTagsAndActivitiesGroupedByTagId().then { dictionaries in
            dictionaries.filter { !$0.value.activities.isEmpty }
            .map { $0.value.tag }
        }
    }
    
    /// Build all tags in database and return promise.
    /// Update `self.tags` with built tags.
    private func buildAllTags() -> Promise<[Tag]> {
        let databaseRef = Database.database().reference()
        return Promise { fulfill, _ in
            databaseRef.child(Self.databaseTagsChild).getData { _, data in
                let info = data.value as? NSArray
                self.tags = self.buildTags(tags: info!)
                fulfill(self.tags!) // Safety: self.tags was just updated.
            }
        }
    }
    
    /// Build tags from the database data.
    private func buildTags(tags: NSArray) -> [Tag] {
        return tags.map { (tag) -> Tag in
            let tagData = try? JSONSerialization.data(withJSONObject: tag, options: .prettyPrinted)
            let tagStruct = self.buildTagStruct(tagData: tagData!)
            return tagStruct!
        }
    }
    
    /// Decode tag struct from its data.
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
