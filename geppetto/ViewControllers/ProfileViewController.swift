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
    @IBOutlet var momentsView: Moments!
    @IBOutlet var favoritesView: Favorites!
    @IBOutlet var historyView: History!
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    let name: String = "Nome mockado rs"
    let image = UIImage(named: "frameprofile")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = name
        self.navigationItem.rightBarButtonItems = [addButton]
        profileImage.image = image
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
        momentsView.momentsLabel.text = "Hello"
        favoritesView.favoritesLabel.text = "Nihao"
        historyView.historyLabel.text = "Hallo"
        
    }

    @IBAction func segmentedControlChanged(_ sender: Any) {
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
    }
    
    func viewOrganizer(_ segmentIndex: Int) {
        if segmentIndex == 0 {
            momentsView.isHidden = false
            favoritesView.isHidden = true
            historyView.isHidden = true
        } else if segmentIndex == 1 {
            momentsView.isHidden = true
            favoritesView.isHidden = false
            historyView.isHidden = true
        } else {
            momentsView.isHidden = true
            favoritesView.isHidden = true
            historyView.isHidden = false
        }
    }
}
