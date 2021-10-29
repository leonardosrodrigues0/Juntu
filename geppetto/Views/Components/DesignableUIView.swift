//
//  DesignableUIView.swift
//  geppetto
//
//  Created by Renato Noronha Máximo on 27/09/21.
//

// Adds Corner Radius, Border and Shadow properties to a UIView and allows you to preview it in the Interface Builder

// Example of use:
// Add a Button
// In the identity inspector set its class to DesignableButton
// change its Corner Radius

import UIKit

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 0
    @IBInspectable var rightInset: CGFloat = 0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += topInset + bottomInset
        contentSize.width += leftInset + rightInset
        return contentSize
    }
    
    /// Space between letters
    @IBInspectable public var kerningSpace: CGFloat {
        get {
            var kerning: CGFloat = 0
            if let attributedText = self.attributedText {
                let range = NSRange(location: 0, length: attributedText.length)
                attributedText.enumerateAttribute(.kern, in: range, options: .init(rawValue: 0)) { (value, _, _) in kerning = value as? CGFloat ?? 0
                }
            }
            return kerning
        }

        set {
            if let currentAttibutedText = self.attributedText {
                let attribString = NSMutableAttributedString(attributedString: currentAttibutedText)
                let range = NSRange(location: 0, length: currentAttibutedText.length)
                attribString.addAttributes([.kern: newValue], range: range)
                self.attributedText = attribString
            }
        }
        
    }
}

@IBDesignable
class DesignableImageView: UIImageView {
    
    private var _bottomGradientColor: UIColor?
    private var _topGradientColor: UIColor?
    
    @IBInspectable
    var bottomGradientColor: UIColor {
        get {
            return _bottomGradientColor ?? .clear
        }
        set {
            _bottomGradientColor = newValue
            addGradientLayerInBackground(colors: [.clear, _bottomGradientColor ?? .clear])
        }
    }
    
    @IBInspectable
    var topGradientColor: UIColor {
        get {
            return _topGradientColor ?? .clear
        }
        set {
            _topGradientColor = newValue
            addGradientLayerInBackground(colors: [.clear, _topGradientColor ?? .clear], up: false)
        }
    }
    
    /// Add a vertical gradient in front of the image.
    /// - Parameter colors: colors to use in the gradient (e.g. `[.clear, .black]`)
    fileprivate func addGradientLayerInBackground(colors: [UIColor], up: Bool = true) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        
        if !up {
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint.zero
        }

        self.layer.insertSublayer(gradient, at: 1)
    }
    
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
