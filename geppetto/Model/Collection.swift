//
//  Collection.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 20/10/21.
//

public extension Collection {
    /// Optional access in the collection.
    ///
    /// - Returns: `nil` when invalid index.
    ///
    /// ```swift
    /// ["a", "b", "c"].get(at: 1) == "b"
    ///
    /// ["a", "b"].get(at: 2) == nil
    /// ```
    @inlinable
    func get(at position: Index) -> Element? {
        if self.indices.contains(position) {
            return self[position]
        } else {
            return nil
        }
    }
}
