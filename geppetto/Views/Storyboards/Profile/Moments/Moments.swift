import UIKit

protocol FullscreenImageNavigationDelegate: AnyObject {
    func navigate(selectedImageIndex: Int)
}

class Moments: UIView {
    
    // MARK: - Properties
    
    @IBOutlet var momentsView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    var images = [Data]()
    weak var delegate: FullscreenImageNavigationDelegate?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initCollectionView()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("Moments", owner: self, options: nil)
        addSubview(momentsView)

        momentsView.frame = self.bounds
        momentsView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func initCollectionView() {
        let nib = UINib(nibName: "MomentsCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CustomCell")
        collectionView.dataSource = self
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width: CGFloat = floor(((momentsView.frame.size.width) - CGFloat(10)) / CGFloat(3))
            layout.itemSize = CGSize(width: width, height: width)
        }
        
        retrieveImages()
    }
    
    /// Retrieve images from pictures directory in documents.
    func retrieveImages() {
        images = UserTracker.shared.getAllMomentsPictures()
        collectionView.reloadData()
    }
}

extension Moments: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.isEmpty {
            EmptyViewHandler.setEmptyView(for: .moments, in: collectionView)
        } else {
            collectionView.backgroundView = nil
        }
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? MomentsCell else {
            fatalError("can't dequeue CustomCell")
        }
        
        cell.momentsImage.image = UIImage(data: images[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let helper = AnalyticsHelper()
        helper.logViewedMomentsImage(at: indexPath.row, collectionSize: images.count)
        delegate?.navigate(selectedImageIndex: indexPath.row)
    }
}
