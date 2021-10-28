//
//  FullscreenImageViewController.swift
//  geppetto
//
//  Created by Gabriel Muelas on 22/10/21.
//

import UIKit

class FullscreenImageViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = imageData {
            image.image = UIImage(data: data)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
