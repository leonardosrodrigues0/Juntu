//
//  Activity.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 30/06/21.
//

import Foundation

struct Activity: Searchable, Decodable {

    // MARK: - Properties
    let name: String
    let description: String
    
    // MARK: - Methods
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
