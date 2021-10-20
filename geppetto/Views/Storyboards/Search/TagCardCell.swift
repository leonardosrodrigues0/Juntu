//
//  TagCardCell.swift
//  geppetto
//
//  Created by Leonardo de Sousa Rodrigues on 19/10/21.
//

import UIKit
import FirebaseStorage

class TagCardCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func setTag(_ tag: Tag) {
        label.text = tag.name
        image.sd_setImage(with: tag.getImageDatabaseRef())
    }
}
