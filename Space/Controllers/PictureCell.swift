//
//  PictureCell.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 13/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
    
    
    @IBOutlet weak var Picture: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.Picture.image = nil
        
    }
}
