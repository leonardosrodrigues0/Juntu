import UIKit
import Photos

/// Use from a view controller (`owner`) to save images to moments, to the library and to share images.
class SaveShareHelper: NSObject, UIImagePickerControllerDelegate {
    
    // MARK: - Properties
    
    var owner: UIViewController
    
    // MARK: - Initializers
    
    init(owner: UIViewController) {
        self.owner = owner
    }
    
    // MARK: - Saving and Sharing Flow
    
    /// Save to moments and prompts user for saving image to photos or sharing it.
    func saveImageToMomentsAndPromptForMore(for image: UIImage, activity: Activity?) {
        saveImageToMoments(image)

        let alert = AlertManager.singleActionAlert(title: "Sucesso!", message: "Sua foto está salva na aba Momentos", action: { _ in
            self.promptForSavingOrSharing(for: image, activity: activity)
        })

        owner.present(alert, animated: true)
    }
    
    /// Warn user that the picture was saved in moments.
    func promptForSavingOrSharing(for image: UIImage, activity: Activity?) {
        let actShare = UIAlertAction(title: "Compartilhar", style: .default, handler: { _ in
            let alert = AlertManager.shareImageAndTextAlert(controller: self.owner, image: image, text: activity?.shareText ?? "")
            self.owner.present(alert, animated: true)
        })

        let actLibrary = UIAlertAction(title: "Salvar na Biblioteca", style: .default, handler: { _ in
            self.trySaveImageToLibrary(image)
        })

        let alert = AlertManager.multipleActionAlert(
            title: nil,
            message: "Você quer fazer algo a mais com a foto que tirou?",
            actions: [AlertManager.cancelAction, actShare, actLibrary],
            preferredStyle: .actionSheet
        )

        owner.present(alert, animated: true)
    }
    
    // MARK: - Save Image to Moments
    
    func saveImageToMoments(_ image: UIImage) {
        UserTracker.shared.savePicture(image)
    }

    // MARK: - Save Image to Library
    
    /// Save image to library.
    func trySaveImageToLibrary(_ image: UIImage) {
        let status = PHPhotoLibrary.authorizationStatus(for: PHAccessLevel.addOnly)
        switch status {
        case .notDetermined:
            requestPhotosAccess(image)
        case .restricted:
            presentPhotosAccessNeededAlert()
        case .denied:
            presentPhotosAccessNeededAlert()
        case .authorized:
            saveImageToLibrary(image)
        default:
            return
        }
    }
    
    /// Request photos access and save an image.
    private func requestPhotosAccess(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.addOnly) { status in
            switch status {
            case .authorized:
                self.saveImageToLibrary(image)
            default:
                return
            }
        }
    }
    
    /// Present the alert that explain the need of photos access authorization and lead to settings app.
    private func presentPhotosAccessNeededAlert() {
        DispatchQueue.main.async {
            let alert = self.createPhotosAccessNeededAlert()
            self.owner.present(alert, animated: true, completion: nil)
        }
    }

    /// Create and alert that explain the need of photos access authorization and lead to settings app.
    private func createPhotosAccessNeededAlert() -> UIAlertController {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!

        let alert = UIAlertController(
            title: "Necessário acesso às Fotos",
            message: "Para poder salvar uma imagem à galeria, precisamos da sua permissão.",
            preferredStyle: UIAlertController.Style.alert
        )

        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Vá aos Ajustes", style: .cancel, handler: { _ -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))

        return alert
    }
    
    private func saveImageToLibrary(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            owner.present(AlertManager.singleActionAlert(title: "Erro!", message: error.localizedDescription), animated: true)
        } else {
            owner.present(AlertManager.singleActionAlert(title: "Imagem salva!", message: "Sua imagem foi salva na galeria."), animated: true)
        }
    }
}
