//
//  History.swift
//  geppetto
//
//  Created by Eduardo Dini on 05/10/21.
//

import UIKit

class History: UIView {
    
    @IBOutlet var historyView: UIView!
    @IBOutlet var historyLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("History", owner: self, options: nil)
        addSubview(historyView)
        historyView.frame = self.bounds
        historyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }

}
