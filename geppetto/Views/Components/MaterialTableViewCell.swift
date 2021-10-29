//
//  ActivityCardTableViewCell.swift
//  geppetto
//
//  Created by Renato Noronha Máximo on 22/10/21.
//

import UIKit

@IBDesignable
class MaterialTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var checkMarkButton: UIImageView!
    
    private var _checked = false
    var checked: Bool {
        get {
            return _checked
        }
        set {
            _checked = newValue
            updateCheckView()
        }
    }
    
    private func updateCheckView() {
        var checkedImageName = "square"
        var nameColor: UIColor = .label
        var checkedImageColor: UIColor = .accentColor
        
        if _checked {
            checkedImageName = "checkmark.square.fill"
            nameColor = .secondaryLabel
            checkedImageColor = .secondaryLabel
        }
        checkMarkButton.image = UIImage(systemName: checkedImageName)
        checkMarkButton.tintColor = checkedImageColor
        name.textColor = nameColor
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateCheckView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checked = selected
    }
}
