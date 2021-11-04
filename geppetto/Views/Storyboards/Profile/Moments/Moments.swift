//
//  Moments.swift
//  geppetto
//
//  Created by Eduardo Dini on 05/10/21.
//

import UIKit

protocol FullscreenImageNavigationDelegate: AnyObject {
    func navigate(selectedImageIndex: Int)
}

class Moments: UIView {
    
    @IBOutlet var momentsView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    var images = [Data]()
    weak var delegate: FullscreenImageNavigationDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
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
    
    // recupera imagens da pasta de pictures dentro da documents
    func retrieveImages() {
        images = [Data]()
        
        let fm = FileManager.default
        let documentsPath = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("pictures")

        do {
            var imagePaths = try fm.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

            imagePaths.sort { $0.lastPathComponent > $1.lastPathComponent }
            
            for imagePath in imagePaths {
                if imagePath.path.hasSuffix("png") {
                    if let imageData = fm.contents(atPath: imagePath.path) {
                        images.append(imageData)
                    } else {
                        print("Error finding path content.")
                    }
                }
            }
            
        } catch {
            print("Error finding imagePaths: \(error)")
        }
    }
}

extension Moments: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        
        delegate?.navigate(selectedImageIndex: indexPath.row)
        
    }
}
