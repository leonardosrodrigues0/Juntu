//
//  DiscoverTagUILabel.swift
//  geppetto
//
//  Created by Renato Noronha Máximo on 05/11/21.
//

import Foundation
import UIKit

@IBDesignable
class DiscoverTagUILabel: TagUILabel {
    var thisTag: Tag?
    private var _tagColor: UIColor = .label
    
    override func initializeLabel() {
        self.font = UIFont.preferredFont(forTextStyle: .headline).withWeight(.semibold)
        self.textAlignment = .center
        self.numberOfLines = 1
        
        self.tagColor = .label
        
        self.topInset = 12
        self.bottomInset = 12
        self.leftInset = 16
        self.rightInset = 16
        
        self.borderWidth = 0
        self.cornerRadius = 16
        
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
    }
    
    override func setLabelColor(to color: UIColor) {
        self.textColor = color
        self.backgroundColor = .label.withAlphaComponent(0.05)
    }
}
