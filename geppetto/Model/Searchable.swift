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
    var description: String { get }
    
    // MARK: - Methods
    func isResultWithSearchString(_ searchString: String) -> Bool
}
