//
//  ActivityViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 05/07/21.
//

import UIKit

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
    @IBOutlet weak var enterActivityStepsButton: UIButton!
    @IBOutlet weak var materialStack: UIStackView!
    @IBOutlet weak var keepInMindText: UILabel!
    
    var helper = AnalyticsHelper.init()

    
    private let itemsColor = UIColor(named: "AccentColor") ?? UIColor.red
    private let itemsSymbolName: [String: String] = [
        "duration": "clock.fill",
        "difficulty": "square.fill",
        "age": "square.fill"
    ]
    
    // MARK: - Methods
    override func viewDidLoad() {
        helper = AnalyticsHelper.init()
        super.viewDidLoad()
        updateOutlets()
        setItemsProperties()
        helper.logViewedActivity(activity: self.activity!)
    }
    
    private func updateOutlets() {
//        image.image = UIImage(named: activity!.imageName)
        name.text = activity?.name
        duration.attributedText = getItemString(item: "duration", value: " \(activity!.time)")
        difficulty.attributedText = getItemString(item: "difficulty", value: " \(activity!.difficulty)")
        age.attributedText = getItemString(item: "age", value: " \(activity!.age)")
        fullDescription.text = activity?.introduction
        keepInMindText.text = activity?.caution
        self.loadMaterialLabels()
        enterActivityStepsButton.layer.cornerRadius = 8

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
    
    /// Set properties of duration, difficulty and age items
    private func setItemsProperties() {
        duration.sizeToFit()
        duration.textColor = self.itemsColor
        difficulty.sizeToFit()
        difficulty.textColor = self.itemsColor
        age.sizeToFit()
        age.textColor = self.itemsColor
    }
    
    /// Get item string with the corresponding SF symbol
    /// - Parameters:
    ///   - item: item name as described in `itemsSymbolName`
    ///   - value: item value
    /// - Returns: Symbol followed by the text
    private func getItemString(item: String, value: String) -> NSMutableAttributedString {
        // Get symbol as string.
        let symbolAttachment = NSTextAttachment()
        let config = UIImage.SymbolConfiguration(scale: .small)
        symbolAttachment.image = UIImage(systemName: self.itemsSymbolName[item]!, withConfiguration: config)?.withTintColor(self.itemsColor)
        let imageString = NSMutableAttributedString(attachment: symbolAttachment)
        
        // Get value as string.
        let text = NSAttributedString(string: value)
        
        imageString.append(text)
        return imageString
    }

    @IBAction private func enterActivityButtonTapped() {
        let storyboard = UIStoryboard(name: "ActivityStep", bundle: nil)
        let activityPageControlViewController = storyboard.instantiateInitialViewController() as? ActivityPageControlViewController
        activityPageControlViewController?.activity = activity
        helper.logDiveInPressed(activity: self.activity!)
        show(activityPageControlViewController!, sender: self)
    }
    
}
