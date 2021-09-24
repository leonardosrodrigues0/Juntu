//
//  StorageController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 22/09/21.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseStorageUI

class StorageViewController: UIViewController {
    
    static let maxSize: Int64 = 2000000000
    @IBOutlet var image: UIImageView!
    var activities = [Activity]()
    
    @IBAction func pullButtonTapped() {
        let constructor = ActivityConstructor.getInstance()
        constructor.getActivities { activities in
            print(activities)
            self.activities.append(contentsOf: activities)
            let activity = self.activities.first
            self.image.sd_setImage(with: Storage.storage().reference().child("Activities/\(String(describing: activity?.id))/overview.png"))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
