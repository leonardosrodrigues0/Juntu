import UIKit
import AVKit

/// Allow a UIViewController to use the camera.
protocol CameraManager: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func tryTakePicture()
    func confirmImage(with info: [UIImagePickerController.InfoKey: Any], to picker: UIImagePickerController)
    func getShareText() -> String
}

extension CameraManager {

    // MARK: - Camera Access Handler

    func tryTakePicture() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch cameraAuthorizationStatus {
        case .notDetermined:
            requestCameraAccess()
        case .restricted:
            presentCameraAccessNeededAlert()
        case .denied:
            presentCameraAccessNeededAlert()
        case .authorized:
            takePicture()
        default : return
        }
    }

    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            if accessGranted {
                self.takePicture()
            }
        })
    }

    private func presentCameraAccessNeededAlert() {
        DispatchQueue.main.async {
            let alert = self.createCameraAccessNeededAlert()
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func createCameraAccessNeededAlert() -> UIAlertController {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!

        let alert = UIAlertController(
            title: "Necessário acesso à Câmera",
            message: "Para poder tirar fotos dentro do app, precisamos da sua permissão.",
            preferredStyle: UIAlertController.Style.alert
        )

        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Vá aos Ajustes", style: .cancel, handler: { _ -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))

        return alert
    }

    // MARK: - Picture Taking

    /// Default implementation for a simple camera usage.
    private func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            DispatchQueue.main.async {
                let pickerController = UIImagePickerController()
                pickerController.sourceType = .camera
                pickerController.delegate = self
                self.present(pickerController, animated: true)
            }
        } else {
            print("Camera not Available")
        }

    }

    // MARK: - Picture Editing and Sharing

    func confirmImage(with info: [UIImagePickerController.InfoKey: Any], to picker: UIImagePickerController) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found while unwrapping ImagePicker info")
            return
        }

        guard let juntuImage = UIImage(named: "juntuWatermark") else {
            print("Error: failed to load Juntu image.")
            return
        }

        let watermarkedImage = addWatermark(image: image, watermarkImage: juntuImage, proportion: 0.3)
        UserTracker.shared.savePicture(watermarkedImage)
        handleConfirmationFlow(for: watermarkedImage)
    }

    fileprivate func handleConfirmationFlow(for image: UIImage) {
        let alert = UIAlertController(title: "Sucesso!", message: "Sua foto está salva na aba Momentos", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.showPhotoMenu(for: image)
        }))

        present(alert, animated: true)
    }

    private func showPhotoMenu(for image: UIImage) {
        let alert = UIAlertController(title: nil, message: "Você quer fazer algo a mais com a foto que tirou?", preferredStyle: .actionSheet)

        let actCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(actCancel)

        let actShare = UIAlertAction(title: "Compartilhar", style: .default, handler: { _ in
            self.shareImageAndText(image)
        })
        alert.addAction(actShare)

        let actLibrary = UIAlertAction(title: "Salvar na Biblioteca", style: .default, handler: { _ in
            self.saveImageToLibrary(image)
        })
        alert.addAction(actLibrary)

        present(alert, animated: true, completion: nil)
    }

    /// Add a watermark to an image. The proportion is used as a ratio between the largest mark dimension and the smallest image dimension.
    private func addWatermark(image: UIImage, watermarkImage: UIImage, proportion: CGFloat) -> UIImage {
        // Draw image
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(
            width: image.size.width,
            height: image.size.height
        ))

        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        
        // Draw watermark image
        let scaleFactor = calculateScaleFactor(imageSize: image.size, markSize: watermarkImage.size, proportion: proportion)
        let watermarkRect = CGRect(origin: CGPoint.zero, size: CGSize(
            width: scaleFactor * watermarkImage.size.width,
            height: scaleFactor * watermarkImage.size.height
        ))
        
        watermarkImage.draw(in: watermarkRect)

        // Get result
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    /// Calculates the scale factor for watermark image.
    /// - Parameters:
    ///   - imageSize: Image size.
    ///   - markSize: Watermark image original size.
    ///   - markSize: Watermark image proportion to the image size.
    /// - Returns: Scale factor to reduce watermark image.
    private func calculateScaleFactor(imageSize: CGSize, markSize: CGSize, proportion: CGFloat) -> CGFloat {
        let smallImageDimension = min(imageSize.width, imageSize.height)
        let largeMarkDimension = max(markSize.width, markSize.height)
        let wantedMarkDimension = smallImageDimension * proportion
        return wantedMarkDimension / largeMarkDimension
    }

    // MARK: - Add image to Library
    private func saveImageToLibrary(_ image: UIImage) {
        let helper = ImagePickerHelper()
        helper.owner = self
        helper.saveImageToLibrary(image)
    }
    
    private func shareImageAndText(_ image: UIImage) {
        // Set up activity view controller

        let shareItems: [Any] = [image, OptionalTextActivityItemSource(text: getShareText())]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // Present the share view controller
        present(activityViewController, animated: true)
    }

    func getShareText() -> String {
        return ""
    }
}

private class ImagePickerHelper: NSObject, UIImagePickerControllerDelegate {
    var owner: UIViewController?

    // MARK: - Add image to Library
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Erro!", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Imagem salva!", message: "Your image has been saved to your photos.")
        }
    }

    private func showAlertWith(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        owner?.present(ac, animated: true)
    }

    func saveImageToLibrary(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}
