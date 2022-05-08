//
//  PartsImageCollectionViewCell.swift
//  CustomPC
//
//  Created by Kai on 2022/05/08.
//

import UIKit
import Nuke

class PartsImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var partsImage: UIImageView!
    
    func setup(imageUrl : URL){
        Nuke.loadImage(with: imageUrl, into: partsImage)
    }
}
