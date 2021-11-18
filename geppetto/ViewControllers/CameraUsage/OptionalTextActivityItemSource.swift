import UIKit

/// Item to share with image. In cases that sharing both is not possible, the text return is nil.
class OptionalTextActivityItemSource: NSObject, UIActivityItemSource {
    
    // MARK: - Properties
    
    let text: String
    
    // MARK: - Initializers
    
    init(text: String) {
        self.text = text
    }
    
    // MARK: - Methods
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return text
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        if activityType?.rawValue == "net.whatsapp.WhatsApp.ShareExtension" {
            // WhatsApp doesn't support both image and text, so return nil and thus only sharing an image.
            return nil
        } else {
            return text
        }
    }
}
