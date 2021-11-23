import UIKit

/// UITableView with height defined by its content (cells).
///
/// If some errors occur in the storyboard, open the size inspector and override the intrinsicContentSize to a placeholder value.
/// It's only used in design time and will be overwritten.
final class ContentSizedTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
