//
//  Tag.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 19/10/21.
//

import FirebaseStorage
import UIKit

struct Tag {
    
    // MARK: - Properties
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
}

extension Tag: Decodable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Tag name:
        name = try values.decode(String.self, forKey: .name)
        
        // Tag color:
        let colorValues = try values.nestedContainer(keyedBy: ColorCodingKeys.self, forKey: .color)
        let red = try colorValues.decode(CGFloat.self, forKey: .red)
        let green = try colorValues.decode(CGFloat.self, forKey: .green)
        let blue = try colorValues.decode(CGFloat.self, forKey: .blue)
        color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        // Tag picture:
        pictureFilename = try values.decode(String.self, forKey: .pictureFilename)
    }
    
    /// Coding keys for the `Tag` struct.
    enum CodingKeys: String, CodingKey {
        case name
        case color
        case pictureFilename
    }
    
    /// Coding keys for the tag color.
    enum ColorCodingKeys: String, CodingKey {
        case red
        case green
        case blue
    }
}
