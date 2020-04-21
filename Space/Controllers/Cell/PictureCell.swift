//
//  PictureCell.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 13/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit


protocol photodelegate: class {
    
    func delete(cell:PictureCell)
}

class PictureCell: UICollectionViewCell {
    
    
    weak var delegate:photodelegate!
    
    
    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var DeleteBackground: UIVisualEffectView!
    
    
    
    @IBAction func DeleteButton(_ sender: Any) {
        
        delegate.delete(cell: self)
    }
    
    var isEditing:Bool = false {
           didSet {
            DeleteBackground.isHidden = !isEditing
            
               
           }
       }
    
   
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.Picture.image = nil
        
       
    }
}
