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
    enum SystemColor: String {
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
                return .systemRed
            case .systemOrange:
                return .systemOrange
            case .systemYellow:
                return .systemYellow
            case .systemGreen:
                return .systemGreen
            case .systemTeal:
                return .systemTeal
            case .systemBlue:
                return .systemBlue
            case .systemIndigo:
                return .systemIndigo
            case .systemPurple:
                return .systemPurple
            case .systemPink:
                return .systemPink
            case .systemBrown:
                return .systemBrown
            default:
                return nil
            }
        }
    }
}
