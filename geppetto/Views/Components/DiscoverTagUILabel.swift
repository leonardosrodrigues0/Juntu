//
//  DiscoverTagUILabel.swift
//  geppetto
//
//  Created by Renato Noronha Máximo on 05/11/21.
//

import Foundation
import UIKit

@IBDesignable
class DiscoverTagUILabel: ClickableTagUILabel {
    
    override func initializeLabel() {
        super.initializeLabel()
        
        self.font = UIFont.preferredFont(forTextStyle: .headline)
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
    }
    
    override func setLabelColor(to color: UIColor) {
        self.textColor = color
        self.backgroundColor = .label.withAlphaComponent(0.05)
    }
}
