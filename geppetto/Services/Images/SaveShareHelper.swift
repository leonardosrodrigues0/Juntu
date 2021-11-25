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
        let alert = UIAlertController(title: "Sucesso!", message: "Sua foto está salva na aba Momentos", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.promptForSavingOrSharing(for: image, activity: activity)
        }))

        owner.present(alert, animated: true)
    }
    
    /// Warn user that the picture was saved in moments.
    func promptForSavingOrSharing(for image: UIImage, activity: Activity?) {
        let alert = UIAlertController(title: nil, message: "Você quer fazer algo a mais com a foto que tirou?", preferredStyle: .actionSheet)

        let actCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(actCancel)

        let actShare = UIAlertAction(title: "Compartilhar", style: .default, handler: { _ in
            self.shareImageAndText(image: image, text: activity?.shareText ?? "")
        })
        alert.addAction(actShare)

        let actLibrary = UIAlertAction(title: "Salvar na Biblioteca", style: .default, handler: { _ in
            self.trySaveImageToLibrary(image)
        })
        alert.addAction(actLibrary)

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
            showAlertWith(title: "Erro!", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Imagem salva!", message: "Sua imagem foi salva na galeria.")
        }
    }
    
    // MARK: - Share Image
    
    func shareImageAndText(image: UIImage, text: String) {
        // Set up activity view controller
        let shareItems: [Any] = [image, OptionalTextActivityItemSource(text: text)]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = owner.view // so that iPads won't crash

        // Present the share view controller
        owner.present(activityViewController, animated: true)
    }
    
    // MARK: - Auxiliary Methods
    
    private func showAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        owner.present(alertController, animated: true)
    }
}
