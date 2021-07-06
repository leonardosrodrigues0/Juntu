//
//  Activity.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 30/06/21.
//

import Foundation

struct Activity: Searchable, Codable {

    // MARK: - Properties
    let name: String
    let imageName: String
    let duration: String
    let difficulty: String
    let age: String
    let cost: String
    let fullDescription: String
    
    // MARK: - Methods
    func getDescription() -> String {
        return age
    }
    
    func isResultWithSearchString(_ searchString: String) -> Bool {
        return name.lowercased().contains(searchString.lowercased())
    }
    
    // MARK: - Static Methods
    static func activities() -> [Activity] {
        guard
            let url = Bundle.main.url(forResource: "activities", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Activity].self, from: data)
        } catch {
            return []
        }
    }
}

