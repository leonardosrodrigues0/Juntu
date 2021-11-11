import Foundation
import UIKit

extension UIFont {
    /// Set specific weight of type `UIFont.Weight` in font
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let newDescriptor = fontDescriptor.addingAttributes([.traits: [
            UIFontDescriptor.TraitKey.weight: weight]
        ])
        return UIFont(descriptor: newDescriptor, size: pointSize)
    }
}
