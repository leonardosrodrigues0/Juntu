//
//  Activity.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 30/06/21.
//

import Foundation

public struct Activity: Searchable {
    
    // MARK: - Properties
    let name: String
    let imageName: String
    let time: String
    let difficulty: String
    let age: String
    let caution: String
    let introduction: String
    let materialList: [String]
    let steps: [ActivityStep]
    
    // MARK: - Methods
    func getDescription() -> String {
        return age
    }
    
    func isResultWithSearchString(_ searchString: String) -> Bool {
        return name.lowercased().contains(searchString.lowercased())
    }
    
}
