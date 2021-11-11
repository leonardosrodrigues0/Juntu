import Foundation
import UIKit

@IBDesignable
class TagUILabel: DesignableLabel {
    
    // MARK: - Properties
    
    private var _tagColor: UIColor = .label
    
    @IBInspectable
    var tagColor: UIColor {
        get {
            return _tagColor
        }
        set {
            _tagColor = newValue
            setLabelColor(to: _tagColor)
        }
    }
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeLabel()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeLabel()
    }
    
    // MARK: - Methods

    func initializeLabel() {
        self.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.textAlignment = .center
        self.numberOfLines = 1
        
        self.tagColor = .label
        
        self.topInset = 4
        self.bottomInset = 4
        self.leftInset = 12
        self.rightInset = 12
        
        self.borderWidth = 1
        self.cornerRadius = 13
        
        self.clipsToBounds = true
    }
    
    func setLabelColor(to color: UIColor) {
        self.textColor = color
        self.backgroundColor = color.withAlphaComponent(0.10)
        self.borderColor = color
    }
}
