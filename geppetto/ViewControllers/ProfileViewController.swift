//
//  ProfileViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 29/06/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var activityExampleButton: UIButton!
    
    @IBAction func activityExampleButtonTapped() {
        let storyboard = UIStoryboard(name: "ActivityOverview", bundle: nil)
        let activityViewController = storyboard.instantiateInitialViewController() as? ActivityOverviewViewController
        activityViewController?.activity = Activity.activities().first
        show(activityViewController!, sender: self) // Navigate to Activity Overview.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
