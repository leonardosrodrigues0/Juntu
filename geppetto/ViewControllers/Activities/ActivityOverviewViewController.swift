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
    @IBOutlet weak var durationUnity: UILabel!
    @IBOutlet weak var difficulty: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var fullDescription: UILabel!
    
    @IBOutlet weak var materialsTableView: UITableView!
    
    @IBOutlet weak var keepInMind: UIStackView!
    @IBOutlet weak var keepInMindText: UILabel!
    @IBOutlet weak var enterActivityStepsButton: UIButton!
    @IBOutlet weak var savedActivityButton: UIButton!
    
    @IBOutlet weak var tagsStack: UIStackView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    var toggleSaveButton: UIBarButtonItem?
    
    private let cellIdentifier = "MaterialTableViewCell"
    private var materials: [String] = []

    var helper = AnalyticsHelper.init()
    
    // MARK: - Methods
    override func viewDidLoad() {
        helper = AnalyticsHelper.init()
        super.viewDidLoad()
        
        initTableView()
        updateOutlets()
        setupSaveButton()
        
        helper.logViewedActivity(self.activity!)
        UserTracker.shared.logSeenActivity(self.activity!)
    }
    
    private func initTableView() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        materialsTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        materialsTableView.dataSource = self
    }
    
    fileprivate func setupSaveButton() {
        toggleSaveButton = UIBarButtonItem(image: .none, style: .plain, target: self, action: #selector(self.editProfileButtonPressed(_:)))
        navigationItem.rightBarButtonItems = [toggleSaveButton!]
        updateSavedActivityButtonImage()
    }
    
    @objc private func editProfileButtonPressed(_ sender: UIBarButtonItem!) {
        if sender == toggleSaveButton {
            toggleSaveActivityButtonTapped(sender)
        }
    }
    
    private func updateOutlets() {
        guard let activity = activity else {
            print("Error: failed to unwrap activity at overview screen")
            return
        }

        image.sd_setImage(with: activity.getImageDatabaseRef())
        name.text = activity.name
        fullDescription.text = activity.introduction
        
        let rating: Double = 5
        let votes: Int = 2
        ratingLabel.text = String(format: "%.1f", rating)
        votesLabel.text = "(\(votes) avaliações)"

        if (activity.caution ?? "").isEmpty {
            keepInMind.removeFromSuperview()
        } else {
            keepInMindText.text = activity.caution
        }
        duration.text = activity.cleanTime
        durationUnity.text = "min"
        difficulty.text = activity.difficulty
        age.text = activity.minMaxAge
        
        loadMaterialLabels()
        
        updateSavedActivityButtonImage()
        
        setupActivityTags()
    }
    
    /// Load materials and set them in the vertical stack
    private func loadMaterialLabels() {
        materials = activity?.materials ?? []
        materialsTableView.reloadData()
        tableHeightConstraint.constant = CGFloat(Double(materials.count) * 45)
    }
    
    private func createMaterialLabel(_ name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        label.numberOfLines = 0
        return label
    }
    
    /// Clear default tags, load activity tags and add them in the horizontal stack
    private func setupActivityTags() {
        clearTags()
        loadAndCreateTags()
    }
    
    private func clearTags() {
        for subView in tagsStack.arrangedSubviews {
            subView.removeFromSuperview()
        }
    }
    
    private func loadAndCreateTags() {
        if let tagId = self.activity?.tags?.first {
            TagsDatabase.shared.getTag(withId: tagId).then { tag in
                self.createTagLabel(name: tag.name, color: tag.color)
            }.then { _ in
                self.createTagLabel(name: "...", color: .secondaryLabel)
            }
        }
    }
    
    private func createTagLabel(name: String, color: UIColor) {
        let aTagLabel = TagUILabel()
        aTagLabel.text = name
        aTagLabel.tagColor = color
        tagsStack.addArrangedSubview(aTagLabel)
    }

    // MARK: - Actions
    @IBAction private func enterActivityButtonTapped() {
        let storyboard = UIStoryboard(name: "ActivityStep", bundle: nil)
        let activityPageControlViewController = storyboard.instantiateViewController(withIdentifier: String(describing: ActivityPageControlViewController.self)) as? ActivityPageControlViewController
        activityPageControlViewController?.activity = activity
        helper.logDiveInPressed(activity: self.activity!)
        show(activityPageControlViewController!, sender: self)
    }
    
    @IBAction func toggleSaveActivityButtonTapped(_ sender: UIBarButtonItem) {
        UserTracker.shared.logToggleSavedActivity(self.activity!)
        helper.logSavedActivity(self.activity!)
        updateSavedActivityButtonImage()
    }
    
    private func updateSavedActivityButtonImage() {
        let isSaved = UserTracker.shared.fetchIfActivityIsSaved(self.activity!)
        let buttomImageString = isSaved ? "bookmark.fill" : "bookmark"
        toggleSaveButton?.image = UIImage(systemName: buttomImageString)
    }
}

extension ActivityOverviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materials.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MaterialTableViewCell
        let item = materials[indexPath.row]
        cell?.name.text = item
        return cell!
    }
    
}
