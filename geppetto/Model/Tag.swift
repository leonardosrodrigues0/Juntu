//
//  Tag.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 19/10/21.
//

import FirebaseStorage
import UIKit

struct Tag: Codable {
    
    // MARK: - Properties
    /// Tag id.
    let id: String
    /// Tag descriptive name.
    let name: String
    /// Tag color.
    let color: UIColor
    /// Tag picture's filename.
    let pictureFilename: String
    
    /// Return a storage reference to the tag image.
    func getImageDatabaseRef() -> StorageReference {
        var path = TagsDatabase.picturesDirectory
        path += "/\(pictureFilename)"
        path += TagsDatabase.imagesExtension
        return Storage.storage().reference().child(path)
    }
    
    /// Coding keys for the `Tag` struct.
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
        case pictureFilename
    }
    
    // MARK: - Decodable
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Tag id:
        id = try values.decode(String.self, forKey: .id)
        
        // Tag name:
        name = try values.decode(String.self, forKey: .name)
        
        // Tag color:
        let colorName = try values.decode(String.self, forKey: .color)
        color = UIColor.systemColor(withName: colorName) ?? UIColor.accentColor
        
        // Tag picture:
        pictureFilename = try values.decode(String.self, forKey: .pictureFilename)
    }
    
    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        
        // Get the SystemColor string that corresponds to `color`.
        let test = UIColor.SystemColor.allCases.filter { self.color == $0.create }
        try container.encode(test.first?.rawValue, forKey: .color)
        
        try container.encode(pictureFilename, forKey: .pictureFilename)
    }
}
