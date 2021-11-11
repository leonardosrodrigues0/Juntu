import UIKit
import FirebaseStorage

/// Collection cell for search screen.
class TagCardCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private static let colorOpacity = 0.3
    private static let blackOpacity = 0.3
    
    // MARK: - Properties
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var blackView: UIView!
    
    var cellTag: Tag? {
        didSet {
            label.text = cellTag?.name
            image.sd_setImage(with: (cellTag?.getImageDatabaseRef())!)
            colorView.backgroundColor = cellTag?.color.withAlphaComponent(Self.colorOpacity)
            blackView.backgroundColor = UIColor.black.withAlphaComponent(Self.blackOpacity)
        }
    }
}
