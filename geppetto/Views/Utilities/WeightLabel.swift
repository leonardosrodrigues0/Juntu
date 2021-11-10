//
//  FontWeights.swift
//  geppetto
//
//  Created by Gabriel Muelas on 10/11/21.
//
//  Define font weight of UILabel
//  Use: In Interface Builder > Identity Inspector set the class of UILabel to one of below custom class

import Foundation
import UIKit

class SemiBoldLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.font = self.font.withWeight(.semibold)
    }
}

class BoldLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.font = self.font.withWeight(.bold)
    }
}
