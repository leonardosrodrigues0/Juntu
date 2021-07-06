//
//  ActivityViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 05/07/21.
//

import UIKit

class ActivityOverviewViewController: UIViewController {
    
    // MARK: - Properties
    var activity: Activity?
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var difficulty: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var fullDescription: UILabel!
    @IBOutlet weak var enterActivityStepsButton: UIButton!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOutlets()
    }
    
    private func updateOutlets() {
        image.image = UIImage(named: activity!.imageName)
        name.text = activity?.name
        duration.text = activity?.duration
        difficulty.text = activity?.difficulty
        age.text = activity?.age
        cost.text = activity?.cost
        fullDescription.text = activity?.fullDescription
    }
    
    @IBAction private func enterActivityButtonTapped() {
        let storyboard = UIStoryboard(name: "ActivityStep", bundle: nil)
        let activityPageControleViewController = storyboard.instantiateInitialViewController() as? ActivityPageControlViewController
//        activityPageControleViewController?.activity = activity // Commented as activities doesn't have steps yet
        show(activityPageControleViewController!, sender: self)
    }
    
}
