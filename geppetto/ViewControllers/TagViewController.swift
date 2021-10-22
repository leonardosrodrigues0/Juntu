//
//  TagViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 22/10/21.
//

import UIKit

class TagViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var label: UILabel!
    var viewTag: Tag?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = viewTag?.name
    }
    
}
