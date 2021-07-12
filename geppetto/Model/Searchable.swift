//
//  Searchable.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 30/06/21.
//

import Foundation

/// Protocol for items that can be found on search screen
protocol Searchable {
    
    // MARK: - Properties
    var name: String { get }
    
    // MARK: - Methods
    /// Description to be shown at seatch
    func getDescription() -> String
    
    /// Must return wheter the object should be a result for a given search
    /// - Parameter searchString: current search bar text
    func isResultWithSearchString(_ searchString: String) -> Bool
}
