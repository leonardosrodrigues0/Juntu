import UIKit

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
            self.saveImageToLibrary(image)
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
    func saveImageToLibrary(_ image: UIImage) {
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
