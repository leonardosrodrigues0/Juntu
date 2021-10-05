//
//  Moments.swift
//  geppetto
//
//  Created by Eduardo Dini on 05/10/21.
//

import UIKit

class Moments: UIView {
    
    @IBOutlet var momentsView: UIView!
    @IBOutlet var momentsLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Moments", owner: self, options: nil)
        addSubview(momentsView)
        momentsView.frame = self.bounds
        momentsView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
