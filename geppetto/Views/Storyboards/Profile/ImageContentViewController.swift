//
//  ImageContentViewController.swift
//  geppetto
//
//  Created by Gabriel Muelas on 28/10/21.
//

import UIKit

class ImageContentViewController: UIViewController {

    @IBOutlet weak var momentImage: UIImageView!
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadImage()
    }

    /// Displays the image selected at Moments into UIImageView
    private func loadImage() {
        if let data = imageData {
            momentImage.image = UIImage(data: data)
        }
    }
}
