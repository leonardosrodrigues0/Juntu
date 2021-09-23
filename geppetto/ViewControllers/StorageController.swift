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
        ActivityConstructor.getActivitiesData { activityList in
            print(activityList)
            self.activities.append(contentsOf: activityList)
            let activity = self.activities.first
            self.image.sd_setImage(with: Storage.storage().reference().child("Activities/\(String(describing: activity?.id))/overview.png"))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
