//
//  MomentImageContentViewController.swift
//  geppetto
//
//  Created by Gabriel Muelas on 28/10/21.
//

import UIKit

class MomentImageContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    private var imageData: Data?
    private var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadImage()
    }

    func setup(imageData: Data, index: Int) {
        self.imageData = imageData
        self.index = index
    }
    
    /// Displays the image selected at Moments into UIImageView
    private func loadImage() {
        if let data = imageData {
            imageView.image = UIImage(data: data)
        }
    }
    
    func getIndex() -> Int {
        return index
    }
}
