import Foundation
import UIKit

class AlertManager {
    static func singleActionAlert(title: String?, message: String?, action: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: action))
        return alert
    }

    static func multipleActionAlert(title: String?, message: String?, actions: [UIAlertAction], preferredStyle: UIAlertController.Style = .alert)
    -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach(alert.addAction(_:))
        return alert
    }
    
    static func shareLink(controller: UIViewController, text: String) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = controller.view // so that iPads won't crash
        activityViewController.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
        activityViewController.isModalInPresentation = true

        return activityViewController
    }

    static func shareImageAndTextAlert(controller: UIViewController, image: UIImage, text: String) -> UIActivityViewController {
        let shareItems: [Any] = [image, OptionalTextActivityItemSource(text: text)]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = controller.view // so that iPads won't crash
        activityViewController.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
        activityViewController.isModalInPresentation = true

        return activityViewController
    }

    static var cancelAction: UIAlertAction {
        UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
    }

    static var settingsAction: UIAlertAction {
        UIAlertAction(title: "Vá aos Ajustes", style: .default, handler: { _ -> Void in
            let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        })
    }
}
