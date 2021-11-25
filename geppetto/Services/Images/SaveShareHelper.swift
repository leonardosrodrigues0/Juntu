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
            self.saveImageToLibrary(image)
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
    func saveImageToLibrary(_ image: UIImage) {
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
