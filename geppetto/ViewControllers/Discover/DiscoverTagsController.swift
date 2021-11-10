//
//  DiscoverTagsController.swift
//  geppetto
//
//  Created by Renato Noronha Máximo on 09/11/21.
//

import Foundation
import UIKit

internal class DiscoverTagsController: UIViewController {
    
    private var tags: [Tag] = []
    weak var tagNavigationDelagate: TagNavigationDelegate!
    weak var tagsStack: UIStackView!
    weak var tagsScrollView: UIScrollView!

    func setup() {
        let loadingHandler = LoadingHandler(parentView: tagsScrollView
        )
        let tagDatabase = TagsDatabase.shared
        tagDatabase.getNonEmptyTags().then { tags in
            self.tags.append(contentsOf: tags)
            self.populateTagScroll()
            loadingHandler.stop()
        }
    }
    
    private func populateTagScroll() {
        let tags = tags.map { creatTagLabel($0) }
        tagsStack.populateWithViews(tags)
    }
    
    private func creatTagLabel(_ tag: Tag) -> DiscoverTagUILabel {
        let aTagLabel = DiscoverTagUILabel()
        aTagLabel.text = tag.name
        aTagLabel.tagColor = tag.color
        aTagLabel.thisTag = tag
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tagSelectionAction(_:)))
        aTagLabel.addGestureRecognizer(tap)
        return aTagLabel
    }

    // Action called when a Tag is tapped.
    @objc private func tagSelectionAction(_ sender: UITapGestureRecognizer) {
        if let tappedTag = sender.view as? DiscoverTagUILabel, let tag = tappedTag.thisTag {
            tagNavigationDelagate?.navigate(to: tag)
        }
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
