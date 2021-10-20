//
//  ActivityViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 05/07/21.
//

import UIKit
import FirebaseStorageUI

/// Activity details screen
class ActivityOverviewViewController: UIViewController {
    
    // MARK: - Properties
    var activity: Activity?
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var difficulty: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var fullDescription: UILabel!
    @IBOutlet weak var materialStack: UIStackView!
    @IBOutlet weak var keepInMind: UIStackView!
    @IBOutlet weak var keepInMindText: UILabel!
    @IBOutlet weak var enterActivityStepsButton: UIButton!
    
    var helper = AnalyticsHelper.init()
    
    // MARK: - Methods
    override func viewDidLoad() {
        helper = AnalyticsHelper.init()
        super.viewDidLoad()
        updateOutlets()
        helper.logViewedActivity(activity: self.activity!)
        UserTracker.shared.logSeenActivity(self.activity!)
    }
    
    private func updateOutlets() {
        guard let activity = activity else {
            print("Error: failed to unwrap activity at overview screen")
            return
        }

        image.sd_setImage(with: activity.getImageDatabaseRef())
        name.text = activity.name
        fullDescription.text = activity.introduction

        if (activity.caution ?? "").isEmpty {
            keepInMind.removeFromSuperview()
        } else {
            keepInMindText.text = activity.caution
        }
        duration.text = activity.time
        difficulty.text = activity.difficulty
        age.text = activity.getAgeText()
        self.loadMaterialLabels()
    }
    
    /// Load materials and set them in the vertical stack
    private func loadMaterialLabels() {
        for subView in materialStack.arrangedSubviews {
            subView.removeFromSuperview()
        }
        
        guard let materials = activity?.materials else {
            return
        }
        
        for material in materials {
            materialStack.addArrangedSubview(createMaterialLabel(material))
        }
    }
    
    private func createMaterialLabel(_ name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        label.numberOfLines = 0
        return label
    }

    @IBAction private func enterActivityButtonTapped() {
        let storyboard = UIStoryboard(name: "ActivityStep", bundle: nil)
        let activityPageControlViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ActivityPageControlViewController.self)) as? ActivityPageControlViewController
        activityPageControlViewController?.activity = activity
        helper.logDiveInPressed(activity: self.activity!)
        show(activityPageControlViewController!, sender: self)
    }
}
