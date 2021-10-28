//
//  FullscreenImageViewController.swift
//  geppetto
//
//  Created by Gabriel Muelas on 22/10/21.
//

import UIKit

class FullscreenImageViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarButtons()
        configViewControllerStyle()
    }
    
    // MARK: - Private functions

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
            action: #selector(didTapMoreButton(sender:))
        )
    }
    
    private func createActionSheet() -> UIAlertController {
        // create alert
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        // create actions
        let shareAction = UIAlertAction(title: "Compartilhar", style: .default) {_ in
            print("Compartilhar")
        }
        
        let useAsProfileImageAction = UIAlertAction(title: "Usar como foto do perfil", style: .default) {_ in
            print("Usar como foto do perfil")
        }
        
        let goToActivityAction = UIAlertAction(title: "Ir para atividade", style: .default) {_ in
            print("Ir para atividade")
        }
        
        let deletePhotoAction = UIAlertAction(title: "Apagar foto", style: .destructive) {_ in
            print("Apagar foto")
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        // add actions to alert
        alert.addAction(shareAction)
        alert.addAction(useAsProfileImageAction)
        alert.addAction(goToActivityAction)
        alert.addAction(deletePhotoAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    // MARK: - Actions
    
    /// Dismiss this ViewController. Triggered when close button is tapped
    @objc private func didTapCloseButton(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    /// Show action sheet when more button is tapped
    @objc private func didTapMoreButton(sender: UIBarButtonItem) {
        let actionSheet = createActionSheet()
        present(actionSheet, animated: true)
    }

    // MARK: - Child View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "childView" {
            guard let imageContentViewController = segue.destination as? ImageContentViewController else { return }
            imageContentViewController.imageData = imageData
        }
        
    }
}

    
