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
    
    private let itemsColor = UIColor(named: "AccentColor") ?? UIColor.red
    private let itemsSymbolName: [String: String] = [
        "duration": "square.fill",
        "difficulty": "square.fill",
        "age": "square.fill",
        "cost": "square.fill"
    ]
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateOutlets()
        setItemsProperties()
    }
    
    private func updateOutlets() {
        image.image = UIImage(named: activity!.imageName)
        name.text = activity?.name
        duration.attributedText = getItemString(item: "duration", value: " \(activity!.duration)")
        difficulty.attributedText = getItemString(item: "difficulty", value: " \(activity!.duration)")
        age.attributedText = getItemString(item: "age", value: " \(activity!.age)")
        cost.attributedText = getItemString(item: "cost", value: " \(activity!.cost)")
        fullDescription.text = activity?.fullDescription
    }
    
    private func setItemsProperties() {
        duration.sizeToFit()
        duration.textColor = self.itemsColor
        difficulty.sizeToFit()
        difficulty.textColor = self.itemsColor
        age.sizeToFit()
        age.textColor = self.itemsColor
        cost.sizeToFit()
        cost.textColor = self.itemsColor
    }
    
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
        let activityPageControleViewController = storyboard.instantiateInitialViewController() as? ActivityPageControlViewController
//        activityPageControleViewController?.activity = activity // Commented as activities doesn't have steps yet
        show(activityPageControleViewController!, sender: self)
    }
    
}
