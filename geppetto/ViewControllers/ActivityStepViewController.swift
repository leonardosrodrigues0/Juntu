//
//  ActivityStepsViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 02/07/21.
//

import UIKit

class ActivityStepViewController: UIViewController {

    // MARK: - Properties
    var index: Int? // PageController index.
    var activity: Activity?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
//    // MARK: - Initializers
//    init(label: String) {
//        self.label = label
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOutlets()
    }
    
    private func updateOutlets() {
        label.text = activity?.name
        let newImage = UIImage(named: activity!.imageName)
        image.image = newImage
    }
    
}
