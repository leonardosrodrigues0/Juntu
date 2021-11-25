import UIKit

/// Help to edit images in the context of our app.
struct ImageEditor {
    
    // MARK: - Properties
    
    /// Original image to be used.
    let originalImage: UIImage
    /// Watermark image to be displayed in front of the original.
    private let watermarkImage = UIImage(named: "juntuWatermark")!
    /// Proportion used as a ratio between the largest mark dimension and the smallest image dimension.
    private let watermarkProportion: CGFloat = 0.3
    
    // MARK: - Initializers
    
    init(_ image: UIImage) {
        self.originalImage = image
    }
    
    // MARK: - Watermark
    
    /// Return the image with a watermark.
    var withWatermark: UIImage {
        // Draw image
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(
            width: originalImage.size.width,
            height: originalImage.size.height
        ))

        UIGraphicsBeginImageContext(rect.size)
        originalImage.draw(in: rect)
        
        // Draw watermark image
        let scaleFactor = Self.calculateScaleFactor(imageSize: originalImage.size, markSize: watermarkImage.size, proportion: watermarkProportion)
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
    ///   - proportion: Watermark image proportion to the image size.
    /// - Returns: Scale factor to reduce watermark image.
    private static func calculateScaleFactor(imageSize: CGSize, markSize: CGSize, proportion: CGFloat) -> CGFloat {
        let smallImageDimension = min(imageSize.width, imageSize.height)
        let largeMarkDimension = max(markSize.width, markSize.height)
        let wantedMarkDimension = smallImageDimension * proportion
        return wantedMarkDimension / largeMarkDimension
    }
}
