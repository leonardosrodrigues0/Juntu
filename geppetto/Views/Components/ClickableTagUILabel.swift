//
//  ClickableTagUILabel.swift
//  geppetto
//
//  Created by Renato Noronha Máximo on 10/11/21.
//

import Foundation
import UIKit

@IBDesignable
class ClickableTagUILabel: TagUILabel {
    var thisTag: Tag? {
        didSet {
            self.text = thisTag?.name ?? ""
            self.tagColor = thisTag?.color ?? .label
        }
    }
    var tagNavigationDelagate: TagNavigationDelegate?
    
    override func initializeLabel() {
        super.initializeLabel()
        
        self.isUserInteractionEnabled = true
        /// Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tagSelectionAction(_:)))
        self.addGestureRecognizer(tap)
    }
    
    // Action called when a Tag is tapped.
    @objc private func tagSelectionAction(_ sender: UITapGestureRecognizer) {
        if let tag = self.thisTag {
            self.tagNavigationDelagate?.navigate(to: tag)
        }
    }
}
