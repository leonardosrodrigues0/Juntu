//
//  Favorites.swift
//  geppetto
//
//  Created by Eduardo Dini on 05/10/21.
//

import UIKit

class Favorites: UIView {

    @IBOutlet var favoritesView: UIView!
    @IBOutlet var favoritesLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Favorites", owner: self, options: nil)
        addSubview(favoritesView)
        favoritesView.frame = self.bounds
        favoritesView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
