//
//  FullscreenImageViewController.swift
//  geppetto
//
//  Created by Gabriel Muelas on 22/10/21.
//

import UIKit

class FullscreenImageViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
        setNavigationBarButtons()
        configViewControllerStyle()
    }
    
    // MARK: - Private functions
    
    /// Displays the image selected at Moments into UIImageView
    private func loadImage() {
        if let data = imageData {
            image.image = UIImage(data: data)
        }
    }
    
    private func configViewControllerStyle() {
        // force dark mode
        overrideUserInterfaceStyle = .dark
        // remove awkward bottom border from navbar
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setNavigationBarButtons() {
        // define close button in navbar
        navItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapCloseButton(sender:))
        )
        // define more button in navbar
        navItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    // MARK: - Actions
    
    /// Dismiss this ViewController. Triggered when close button is tapped
    @objc private func didTapCloseButton(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
