//
//  Searchable.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 30/06/21.
//

import Foundation

protocol Searchable {
    
    // MARK: - Properties
    var name: String { get }
    
    // MARK: - Methods
    func getDescription() -> String
    
    func isResultWithSearchString(_ searchString: String) -> Bool
}
