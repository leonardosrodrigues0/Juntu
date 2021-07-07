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
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var references: UILabel!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOutlets()
    }
    
    private func updateOutlets() {
        guard let indexValue = index else {
            print("Error: failed to unwrap index optional at activity step.")
            return
        }
        
        let newImage = UIImage(named: activity!.imageName)
        image.image = newImage
        indexLabel.text = "Step \(indexValue + 1)"
        instructions.text = activity?.fullDescription
        references.text = activity?.fullDescription
    }
    
}
