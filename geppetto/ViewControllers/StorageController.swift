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
    
    @IBOutlet var image: UIImageView!
    
    @IBAction func pullButtonTapped() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("test.jpeg")
        image.sd_setImage(with: imageRef)
        
        let jsonRef = storageRef.child("test.json")
        jsonRef.getData(maxSize: 20000) { data, _ in
            print(data!)
            print(type(of: data))
            let decoder = JSONDecoder()
            do {
                let test = try decoder.decode(Test.self, from: data!)
                print(test)
                print(type(of: test))
            } catch {
                print("FAILURE DECODING")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
