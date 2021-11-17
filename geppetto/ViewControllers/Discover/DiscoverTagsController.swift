import Foundation
import UIKit
import Promises

internal class DiscoverTagsController: UIViewController {
    
    // MARK: - Properties
    
    private var tags: [Tag] = []
    weak var tagNavigationDelegate: TagNavigationDelegate!
    weak var tagsStack: UIStackView!
    weak var tagsScrollView: UIScrollView!

    // MARK: - Methods
    
    func setup() -> Promise <[Tag]> {
        let tagDatabase = TagsDatabase.shared
        return tagDatabase.getNonEmptyTags().then { tags in
            self.tags.append(contentsOf: tags)
            self.populateTagScroll()
        }
    }
    
    private func populateTagScroll() {
        let tags = tags.map { createTagLabel($0) }
        tagsStack.populateWithViews(tags)
    }
    
    private func createTagLabel(_ tag: Tag) -> DiscoverTagUILabel {
        let aTagLabel = DiscoverTagUILabel()
        aTagLabel.thisTag = tag
        aTagLabel.tagNavigationDelegate = tagNavigationDelegate
        
        return aTagLabel
    }
}

fileprivate extension UIStackView {
    /// Inject an array of UIView into StackView
    func populateWithViews(_ array: [UIView]) {
        for item in self.arrangedSubviews {
            item.removeFromSuperview()
        }
        
        for view in array {
            self.addArrangedSubview(view)
        }
    }
}
