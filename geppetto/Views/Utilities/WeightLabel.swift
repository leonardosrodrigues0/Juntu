//  Define font weight of UILabel
//  Use: In Interface Builder > Identity Inspector set the class of UILabel to one of below custom class
//  Disclaimer: This classes are built to use only in Storyboards, not in code

import Foundation
import UIKit

class MediumLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.font = self.font.withWeight(.medium)
    }
}

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
