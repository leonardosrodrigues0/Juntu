//
//  ZoomAndSnapFlowLayout.swift
//  geppetto
//
//  Created by Renato Noronha Máximo on 07/11/21.
//

import Foundation
import UIKit

class ZoomAndSnapFlowLayout: UICollectionViewFlowLayout {

    var activeDistance: CGFloat = 250
    var zoomFactor: CGFloat = 0.1
    
    init(zoomFactor: CGFloat) {
        super.init()
        
        self.zoomFactor = zoomFactor
        
        scrollDirection = .horizontal
        minimumLineSpacing = 50
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        let vInsets = CGFloat(20)
        let hInsets = CGFloat(32)
        
        self.sectionInset = UIEdgeInsets(top: vInsets, left: hInsets, bottom: vInsets, right: hInsets)

        guard let collectionView = collectionView else { fatalError() }
        minimumLineSpacing = collectionView.frame.width * (1 + zoomFactor) * (20/400)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        var rectAttributes: [UICollectionViewLayoutAttributes] = []
        for att in super.layoutAttributesForElements(in: rect)! {
            if let attCast = att.copy() as? UICollectionViewLayoutAttributes {
                rectAttributes.append(attCast)
            }
        }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)

        // Make the cells be zoomed when they reach the center of the screen
        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = distance / activeDistance

            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                attributes.zIndex = Int(zoom.rounded())
            }
        }

        return rectAttributes
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }

        // Add some snapping behaviour so that the zoomed cell is always centered
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as? UICollectionViewFlowLayoutInvalidationContext
        context?.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context!
    }
}
