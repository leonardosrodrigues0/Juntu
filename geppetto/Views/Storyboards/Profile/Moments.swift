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
    
//    let paises: [String] = ["BR", "AR", "CH", "BO", "CH"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        initCollectionView()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("Moments", owner: self, options: nil)
        addSubview(momentsView)

        momentsView.frame = self.bounds
        momentsView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        initCollectionView()
    }
    
    private func initCollectionView() {
        let nib = UINib(nibName: "MomentsCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CustomCell")
        collectionView.dataSource = self
    }

}

extension Moments: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? MomentsCell else {
            fatalError("can't dequeue CustomCell")
        }
        
        let image = UIImage(named: "frameprofile")!
        cell.momentsImage.image = image
        
        return cell
    }
    
}
