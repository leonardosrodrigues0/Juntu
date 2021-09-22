//
//  ProfileViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 29/06/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBAction func storageButtonTapped() {
        let storyboard = UIStoryboard(name: "Storage", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        show(controller!, sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
