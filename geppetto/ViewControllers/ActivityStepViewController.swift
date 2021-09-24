//
//  ActivityStepsViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 02/07/21.
//

import UIKit
import FirebaseStorage

/// Individual activity step screen
class ActivityStepViewController: UIViewController {

    // MARK: - Properties
    var index: Int? // PageController index.
    var step: ActivityStep?
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
        
        guard let imageRef = step?.getImageDatabaseRef() else {
            return
        }
        
        image.sd_setImage(with: imageRef)
        indexLabel.text = "Passo \(indexValue + 1)"
        instructions.text = step?.information
        references.text = step?.reference
    }
    
}
