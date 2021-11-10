//
//  Colors.swift
//  geppetto
//
//  Created by Renato Noronha Máximo on 06/10/21.
//

import UIKit

extension UIColor {
    public class var accentColor: UIColor {
        UIColor(named: "AccentColor") ?? UIColor.white
    }
    
    public class var pageTintColor: UIColor {
        UIColor(named: "pageTintColor") ?? UIColor.white
    }
    
    /// Return the system color by its name.
    static func systemColor(withName name: String) -> UIColor? {
        return SystemColor(rawValue: name)?.create
    }
    
    /// System colors described as strings.
    /// Used to create colors from strings.
    enum SystemColor: String, CaseIterable {
        case systemRed
        case systemOrange
        case systemYellow
        case systemGreen
        case systemMint
        case systemTeal
        case systemCyan
        case systemBlue
        case systemIndigo
        case systemPurple
        case systemPink
        case systemBrown
        
        /// The equivalent UIColor.
        var create: UIColor? {
            switch self {
            case .systemRed:
                return UIColor.systemRed
            case .systemOrange:
                return UIColor.systemOrange
            case .systemYellow:
                return UIColor.systemYellow
            case .systemGreen:
                return UIColor.systemGreen
            case .systemTeal:
                return UIColor.systemTeal
            case .systemBlue:
                return UIColor.systemBlue
            case .systemIndigo:
                return UIColor.systemIndigo
            case .systemPurple:
                return UIColor.systemPurple
            case .systemPink:
                return UIColor.systemPink
            case .systemBrown:
                return UIColor.systemBrown
            default:
                return nil
            }
        }
    }
}
