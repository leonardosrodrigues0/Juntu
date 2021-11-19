import UIKit

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

class EditProfileViewController: UIViewController, UITableViewDataSource {
   
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
    
    @objc func takePictureLibrary() {
        showImagePickerController()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Imagem de Perfil"
        } else {
            return ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
          
            let cell = tableView.dequeueReusableCell(withIdentifier: "First name", for: indexPath)
            guard let viewCell = cell as? TextFieldCell else { return cell }
            viewCell.editTextField.text = UserTracker.shared.getUserName()
            return viewCell

        } else {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Button Cell", for: indexPath)
                guard let viewCell = cell as? ButtonCell else { return cell }
                
                viewCell.buttonPressed = {
                    self.takePictureLibrary()
                }
                
                return viewCell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Picture Cell", for: indexPath)
                guard let viewCell = cell as? PictureCell else { return cell }
                addPictureCellAction(viewCell)
                return viewCell
            }
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            editedProfileImage = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            editedProfileImage = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: CameraManager {
    
    private func addPictureCellAction(_ viewCell: PictureCell) {
        viewCell.buttonPressed = {
            self.tryTakePicture()
        }
    }
}
