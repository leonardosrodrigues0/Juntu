//
//  CameraViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 20/09/21.
//

import UIKit
import AVKit

/// Allow a UIViewController to use the camera.
protocol CameraManager: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
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

    // MARK: - Picture taking

    /// Default implementation for a simple camera usage,
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

    // MARK: - picture editing and sharing

    /// Share an image with a Juntu watermark and an associated text.
    /// Built to be called inside `imagePickerController` method at the UIViewController.
    func shareImageAndText(didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any], text: String) {
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found while unwrapping ImagePicker info")
            return
        }
        
        guard let juntuImage = UIImage(named: "juntuWatermark") else {
            print("Error: failed to load Juntu image.")
            return
        }
        
        let watermarkedImage = addWatermark(image: image, watermarkImage: juntuImage, proportion: 0.3)
        // here you add image to filesystem
        saveOnFileSystem(image: watermarkedImage)
        shareImageAndText(image: watermarkedImage, text: text)
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

        // Get result.
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
    
    private func shareImageAndText(image: UIImage, text: String) {
        // Set up activity view controller
        let shareItems: [Any] = [image, OptionalTextActivityItemSource(text: text)]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // Present the share view controller
        present(activityViewController, animated: true)
    }

    // MARK: - picture saving
    
    private func saveOnFileSystem(image: UIImage) {
        if let data = image.pngData() {
            let date = Date()
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documents.appendingPathComponent("\(date).png")
            
            do {
                try data.write(to: url)
            } catch {
                print("Unable to Write Data to Disk \(error)")
            }
        }
    }
}
