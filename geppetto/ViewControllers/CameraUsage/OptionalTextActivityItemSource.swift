//
//  OptionalTextActivityItemSource.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 01/10/21.
//

import UIKit

/// Item to share with image. In cases that sharing both is not possible, the text return is nil.
class OptionalTextActivityItemSource: NSObject, UIActivityItemSource {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType?.rawValue == "net.whatsapp.WhatsApp.ShareExtension" {
            // WhatsApp doesn't support both image and text, so return nil and thus only sharing an image.
            return nil
        } else {
            return text
        }
    }
}
