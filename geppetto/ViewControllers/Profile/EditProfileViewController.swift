import UIKit
import CropViewController

class TextFieldCell: UITableViewCell {
    @IBOutlet weak var editTextField: UITextField!
}

class ButtonCell: UITableViewCell {
    var buttonPressed: (() -> Void) = {}
    
    @IBAction func buttonAction(_ sender: UIButton) {
        buttonPressed()
    }
}

class PictureCell: UITableViewCell {
    var buttonPressed: (() -> Void) = {}
    
    @IBAction func buttonAction(_ sender: UIButton) {
        buttonPressed()
    }
}

protocol EditProfileViewControllerDelegate: AnyObject {
    func didFinishEditing()
}

class EditProfileViewController: UIViewController {
   
    // MARK: - Properties
    
    @IBOutlet var tableViewEditProfile: UITableView!
    var editedProfileImage: UIImage?
    weak var delegate: EditProfileViewControllerDelegate?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewEditProfile.dataSource = self
        self.navigationController?.topViewController?.title = "Edição de Perfil"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        let indexPathFirst = IndexPath(row: 0, section: 0)
        let cellFirst = tableViewEditProfile.cellForRow(at: indexPathFirst)
        guard let viewCellFirst = cellFirst as? TextFieldCell else {return}
        
        UserTracker.shared.editUserName(newName: String(viewCellFirst.editTextField.text!))

        if editedProfileImage != nil {
            UserTracker.shared.editUserProfilePicture(newImage: editedProfileImage!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.didFinishEditing()
    }
    
    private func showImagePickerControllerFromLibrary() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension EditProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Imagem de Perfil"
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            return nameCell(tableView, cellForRowAt: indexPath)
        case (1, 0):
            return choosePictureCell(tableView, cellForRowAt: indexPath)
        case (1, 1):
            return takePictureCell(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func nameCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "First name", for: indexPath)
        guard let viewCell = cell as? TextFieldCell else { return cell }
        viewCell.editTextField.text = UserTracker.shared.getUserName()
        return viewCell
    }
    
    private func choosePictureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Button Cell", for: indexPath)
        guard let viewCell = cell as? ButtonCell else { return cell }
        
        viewCell.buttonPressed = {
            self.showImagePickerControllerFromLibrary()
        }
        
        return viewCell
    }
    
    private func takePictureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture Cell", for: indexPath)
        guard let viewCell = cell as? PictureCell else { return cell }
        
        viewCell.buttonPressed = {
            self.tryTakePicture()
        }
        
        return viewCell
    }
}

extension EditProfileViewController: CameraManager {
    
    /// Method called when image picker gets media both for choosing photo and taking picture.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var imageToCrop: UIImage
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageToCrop = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageToCrop = originalImage
        } else {
            return
        }
        
        // Dismiss image picker (choosing or camera)
        // and show the crop controller.
        picker.dismiss(animated: true) {
            let cropController = self.cropController(imageToCrop)
            self.show(cropController, sender: self)
        }
    }
}

extension EditProfileViewController: CropViewControllerDelegate {
    
    /// Build a `CropController` with fix aspect ratio.
    private func cropController(_ image: UIImage) -> CropViewController {
        let cropController = CropViewController(croppingStyle: .default, image: image)
        cropController.delegate = self

        // Configure the crop controller to have a fix aspect ratio.
        // This configuration is fragile and can stop working properly
        // with a simple change in the order of the lines below (weird
        // behavior from the CropViewController library). as! CropViewControllerDelegate
        cropController.aspectRatioPickerButtonHidden = true
        cropController.customAspectRatio = profilePictureAspectRatio ?? CGSize(width: 3, height: 1)
        cropController.aspectRatioLockEnabled = true
        cropController.resetAspectRatioEnabled = false

        cropController.doneButtonColor = .accentColor
        cropController.cancelButtonColor = .accentColor
        
        return cropController
    }
    
    /// Called at the end of the life of cropViewController. Dismiss it and set profile image.
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        navigationController?.popViewController(animated: true)
        editedProfileImage = image
    }
    
    var profilePictureAspectRatio: CGSize? {
        guard let profileController = delegate as? ProfileViewController else {
            return nil
        }
        
        return profileController.profileImageView.frame.size
    }
}
