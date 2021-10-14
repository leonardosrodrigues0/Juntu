//
//  ActivityPageControlViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 02/07/21.
//

import UIKit

/// Control of the PageViewController for a given activity
class ActivityPageControlViewController: UIViewController, CameraManager {
    
    // MARK: - Properties
    @IBOutlet weak var contentView: UIView!
    var activity: Activity?
    var helper = AnalyticsHelper()
    
    // MARK: - Page Control Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        helper = AnalyticsHelper()
        configurePageViewController()
    }
    
    /// Set options for pages
    func configurePageViewController() {
        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: ActivityPageViewController.self)) as? ActivityPageViewController else {
            return
        }
        
        if activity != nil {
            pageViewController.setActivity(activity!)
        }
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        contentView.addSubview(pageViewController.view)
        
        let views: [String: Any] = ["pageView": pageViewController.view!]
        
        contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[pageView]-0-|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: views
            )
        )
        
        contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[pageView]-0-|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: views
            )
        )
    }
    
    // MARK: - Camera Usage Methods
    @IBAction private func cameraButtonTapped() {
        takePicture()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        guard let name = activity?.name else {
            return
        }
        
        let shareText = "Estou usando Juntu e fazendo a atividade \(name) com minha criança!"
        shareImageAndText(didFinishPickingMediaWithInfo: info, text: shareText)
    }
    
}
