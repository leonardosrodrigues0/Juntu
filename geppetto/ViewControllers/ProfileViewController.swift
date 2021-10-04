//
//  ProfileViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 29/06/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileSegmentedControl: UISegmentedControl!
    @IBOutlet var momentsContainer: UIView!
    @IBOutlet var historyContainer: UIView!
    @IBOutlet var favoritesContainer: UIView!
    
    // TODO: implementar action do bar button
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    let name: String = "Nome mockado rs"
    let image = UIImage(named: "frameprofile")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = name
        self.navigationItem.rightBarButtonItems = [addButton]
        profileImage.image = image
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
        
    }

    @IBAction func segmentedControlChanged(_ sender: Any) {
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
    }
    
    func viewOrganizer(_ segmentIndex: Int) {
        if segmentIndex == 0 {
            momentsContainer.isHidden = false
            historyContainer.isHidden = true
            favoritesContainer.isHidden = true
        } else if segmentIndex == 1 {
            momentsContainer.isHidden = true
            favoritesContainer.isHidden = false
            historyContainer.isHidden = true
        } else {
            momentsContainer.isHidden = true
            favoritesContainer.isHidden = true
            historyContainer.isHidden = false
        }
    }
}
