//
//  Activity.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 30/06/21.
//

import Foundation

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
    let steps: [ActivityStep]
    
    // MARK: - Methods
    func getDescription() -> String {
        return age
    }
    
    func isResultWithSearchString(_ searchString: String) -> Bool {
        return name.lowercased().contains(searchString.lowercased())
    }
    
}
