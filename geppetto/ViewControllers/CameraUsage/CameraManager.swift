//
//  CameraViewController.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 20/09/21.
//

import UIKit

/// Allow a UIViewController to use the camera
protocol CameraManager: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    
    func takePicture()
}

extension CameraManager {
    
    /// Default implementation for a simple camera usage
    func takePicture() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .camera
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
    
    /// Share an image taken with the picker
    /// Built to be called inside `imagePickerController` method at the UIViewController
    func dismissPickerAndShareImageAndText(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any], text: String) {

        // Dismiss ImagePicker before any action
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found while unwrapping ImagePicker info")
            return
        }

        shareImageAndText(image: image, text: text)
    }
    
    private func shareImageAndText(image: UIImage, text: String) {
        // Set up activity view controller
        let shareItems: [Any] = [image, OptionalTextActivityItemSource(text: text)]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // Present the share view controller
        present(activityViewController, animated: true)
    }
}
