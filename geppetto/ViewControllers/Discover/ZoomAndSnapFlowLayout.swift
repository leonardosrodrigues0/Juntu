import Foundation
import UIKit

// UICollectionViewFlowLayout that adds Zoom and Snap effects.
// Moves at most a single cell and always center it. The centered cell will be zoomed.
class ZoomAndSnapFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Properties
    
    var activeDistance: CGFloat = 250
    var zoomFactor: CGFloat = 0.1
    var currentItemIdx: Int = 0
    var horizontalInsets: CGFloat = 0
    weak var pageControl: UIPageControl?
    
    // MARK: - Initializers
    
    init(zoomFactor: CGFloat) {
        super.init()
        
        self.zoomFactor = zoomFactor
        
        scrollDirection = .horizontal
        minimumLineSpacing = 50
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepare() {
        super.prepare()
        
        let vInsets = CGFloat(20)
        let hInsets = CGFloat(32)
        
        self.sectionInset = UIEdgeInsets(top: vInsets, left: hInsets, bottom: vInsets, right: hInsets)

        guard let collectionView = collectionView else { fatalError() }
        minimumLineSpacing = collectionView.frame.width * (1 + zoomFactor) * (20/400)
        
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }

    // MARK: - Zoom effect
    
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

    // MARK: - Snap effect
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard collectionView != nil else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        if velocity.x > 0 {
            currentItemIdx = getNextValidItemIdx()
        } else if velocity.x < 0 {
            currentItemIdx = getPreviousValidItemIdx()
        } else {
            currentItemIdx = getItemIdxBasedOnPosition(of: proposedContentOffset)
        }
        
        pageControl?.currentPage = currentItemIdx
        
        let xOffset = getCurrentItemContentOffsetX()
        return CGPoint(x: xOffset, y: proposedContentOffset.y)
    }
    
    private func getNextValidItemIdx() -> Int {
        guard let collectionView = collectionView else { return 0 }
        let itemRowIndex = currentItemIdx + 1
        return min(itemRowIndex, collectionView.numberOfItems(inSection: 0) - 1)
    }
    
    private func getPreviousValidItemIdx() -> Int {
        let itemRowIndex = currentItemIdx - 1
        return max(itemRowIndex, 0)
    }
    
    /// Gets the item index row based on the scroll point
    private func getItemIdxBasedOnPosition(of point: CGPoint) -> Int {
        let closestIndex = getClosestIndex(from: point)
        var itemRowIndex = currentItemIdx
        
        if closestIndex > currentItemIdx {
            itemRowIndex = getNextValidItemIdx()
        } else if closestIndex < currentItemIdx {
            itemRowIndex = getPreviousValidItemIdx()
        }
        
        return itemRowIndex
    }
    
    /// Gets the index row of the closes item from point
    private func getClosestIndex(from point: CGPoint) -> Int {
        guard let collectionView = collectionView else { return 0 }
        
        let itemWidth: CGFloat = floor((collectionView.frame.size.width - 2 * horizontalInsets)) / (1 + zoomFactor)
        var closestIndex: Int = Int(round(Float(point.x) / Float(itemWidth + horizontalInsets)))
        
        if closestIndex > collectionView.numberOfItems(inSection: 0) {
            closestIndex = collectionView.numberOfItems(inSection: 0)
        } else if closestIndex < 0 {
            closestIndex = 0
        }
        
        return closestIndex
    }
    
    /// Adds some snapping behavior so that the zoomed cell is always centered
    private func getCurrentItemContentOffsetX() -> CGFloat {
        guard let collectionView = collectionView else { return CGFloat(0) }
        
        let itemWidth: CGFloat = floor((collectionView.frame.size.width - 2 * horizontalInsets)) / (1 + zoomFactor)
        let itemWithSpaceWidth = itemWidth + minimumLineSpacing
        let nearestPageOffset = CGFloat(currentItemIdx) * itemWithSpaceWidth
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = nearestPageOffset + collectionView.frame.width / 2
        
        let targetRect = CGRect(x: nearestPageOffset, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }

        return CGFloat(nearestPageOffset + offsetAdjustment)
    }

    /// Always invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as? UICollectionViewFlowLayoutInvalidationContext
        context?.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context!
    }
}
