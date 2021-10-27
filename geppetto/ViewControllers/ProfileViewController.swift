//
//  ProfileViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 29/06/21.
//

import UIKit

class ProfileViewController: UIViewController, ActivityNavigationDelegate, FullscreenImageNavigationDelegate {

    // MARK: - Properties
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileSegmentedControl: UISegmentedControl!
    @IBOutlet var momentsView: Moments!
    @IBOutlet var savedActivitiesView: SavedActivities!
    @IBOutlet var historyView: History!
    
    var selectedActivity: Activity?
    var selectedImage: Data?
    
    var editProfileButton: UIBarButtonItem?
    
    let images = [UIImage]()
    let placeholderProfilePicture = UIImage(named: "placeholderProfilePicture")!
    
    // MARK: - Startup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileEditing()
        enableProfilePictureInteraction()
        
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
        
        momentsView.delegate = self
        
        updateViews()
    }
    
    fileprivate func enableProfilePictureInteraction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.profilePictureClicked(gesture:)))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    fileprivate func setupProfileEditing() {
        editProfileButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editProfileButtonPressed(_:)))
        navigationItem.rightBarButtonItems = [editProfileButton!]
    }
    
    // MARK: - Segmented Control
    
    @IBAction private func segmentedControlChanged(_ sender: Any) {
        viewOrganizer(profileSegmentedControl.selectedSegmentIndex)
        updateViews()
    }
    
    private func viewOrganizer(_ segmentIndex: Int) {
        momentsView.isHidden = segmentIndex != 0
        savedActivitiesView.isHidden = segmentIndex != 1
        historyView.isHidden = segmentIndex != 2
    }
    
    // MARK: - View Update  Methods
    
    // update info when opening profile tab
    override func viewDidAppear(_ animated: Bool) {
        updateViews()
    }
    
    private func updateViews() {
        self.updateTitle()
        self.updateSavedActivitiesView()
        self.updateHistoryView()
        momentsView.retrieveImages()
        momentsView.collectionView.reloadData()
        profileImageView.image = UserTracker.shared.getProfilePicture() ?? self.placeholderProfilePicture
    }
    
    private func updateTitle() {
        self.navigationItem.title = UserTracker.shared.getUserName()
        
        if self.navigationItem.title!.isEmpty {
            triggerEditUserNameAlert()
        }
    }
    
    private func updateHistoryView() {
        let ids = UserTracker.shared.fetchActivityHistory()
        ActivityConstructor.shared.getActivities(ids: ids).then { activities in
            self.historyView.items = activities
            self.historyView.reloadCards(delegate: self)
        }
    }
    
    private func updateSavedActivitiesView() {
        let ids = UserTracker.shared.fetchSavedActivities()
        ActivityConstructor.shared.getActivities(ids: ids).then { activities in
            self.savedActivitiesView.items = activities
            self.savedActivitiesView.reloadCards(delegate: self)
        }
    }
    
    // MARK: - CardNavigationDelegate Methods
    /// Navigate to ActivityOverview
    func navigate(to activity: Activity) {
        selectedActivity = activity
        performSegue(withIdentifier: "goToOverview", sender: self)
    }
    
    // MARK: - FullscreenImageNavigationDelegate Methods
    /// Navigate to FullscreenImage
    func navigate(image: Data) {
        selectedImage = image
        performSegue(withIdentifier: "goToFullscreen", sender: self)
    }
    
    // MARK: - Pass data foward in navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToOverview" {
            guard let activityOverviewViewController = segue.destination as? ActivityOverviewViewController else { return }
            activityOverviewViewController.activity = selectedActivity
        }
        
        if segue.identifier == "goToFullscreen" {
            guard let fullscreenImageViewController = segue.destination as? FullscreenImageViewController else { return }
            fullscreenImageViewController.imageData = selectedImage
        }
    }
    
    // MARK: - Profile Editing Methods
    
    @objc private func editProfileButtonPressed(_ sender: UIBarButtonItem!) {
        if sender == editProfileButton {
            triggerEditUserNameAlert()
        }
    }
    
    @objc private func profilePictureClicked(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            showImagePickerController()
        }
    }
    
    fileprivate func addCancelAction(_ alert: UIAlertController) {
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alert.addAction(cancelAction)
    }
    
    private func triggerEditUserNameAlert() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Qual é o seu nome?", message: "", preferredStyle: .alert)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Digite o seu Apelido"
            textField = alertTextField
        }
        
        let renameAction = UIAlertAction(title: "Renomear", style: .default) { _ in
            // what happens once user clicks add item button in ui alert
            let firstRun = self.navigationItem.title!.isEmpty
        
            UserTracker.shared.editUserName(newName: textField.text!)
            self.updateTitle()
            
            if firstRun {
                self.triggerEditProfilePictureAlert()
            }
        }
        
        // do not let user cancel rename in first run
        if !self.navigationItem.title!.isEmpty {
            addCancelAction(alert)
        }
        
        alert.addAction(renameAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func triggerEditProfilePictureAlert() {
        let alert = UIAlertController(title: "Se quiser, escolha uma foto para te representar", message: "", preferredStyle: .alert)
        
        let addPictureAction = UIAlertAction(title: "Abrir Fotos", style: .default) { _ in
            // what happens once user clicks add item button in ui alert
            self.showImagePickerController()
        }
        
        addCancelAction(alert)
        alert.addAction(addPictureAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - ImagePicker

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = originalImage
        }
        
        UserTracker.shared.editUserProfilePicture(newImage: profileImageView.image!)
                
        dismiss(animated: true, completion: nil)
    }
}
