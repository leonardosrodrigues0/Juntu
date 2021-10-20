//
//  Moments.swift
//  geppetto
//
//  Created by Eduardo Dini on 05/10/21.
//

import UIKit

class Moments: UIView {
    
    @IBOutlet var momentsView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    var images = [Data]()
    
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
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        retrieveImages()
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
    
    private func retrieveImages() {
        let fm = FileManager.default
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print("\n\n\n\n")
        print(documentsPath)
        do {
            let contents = try fm.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            print("\n\n\n\n \(contents)")
            for imagePath in contents {
                if let imageData = fm.contents(atPath: imagePath.path) {
                    images.append(imageData)
                } else {
                    print("Algo de errado não está certo")
                }
            }
            
        } catch {
            print("\nDeu erro carai\n")
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
}
