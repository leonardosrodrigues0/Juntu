import UIKit
import AVKit

/// Allow a UIViewController to use the camera.
protocol CameraManager: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /// Called after the image picker finished taking a picture.
    ///
    /// Remember to always dismiss the picker with `picker.dismiss()`.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
}

extension CameraManager {

    // MARK: - Camera Access Handler

    /// Try to take a picture with behavior according to the current camera authorization status.
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
        default:
            return
        }
    }

    /// Request camera access and take a picture.
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            if accessGranted {
                self.takePicture()
            }
        })
    }

    /// Present the alert that explain the need of camera access authorization and lead to settings app.
    private func presentCameraAccessNeededAlert() {
        DispatchQueue.main.async {
            let alert = AlertManager.multipleActionAlert(
                title: "Necessário acesso à Câmera",
                message: "Para poder tirar fotos dentro do app, precisamos da sua permissão.",
                actions: [AlertManager.cancelAction, AlertManager.settingsAction]
            )
            self.present(alert, animated: true, completion: nil)
        }
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
}
