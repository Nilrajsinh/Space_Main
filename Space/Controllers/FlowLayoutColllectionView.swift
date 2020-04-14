//
//  FlowLayoutColllectionView.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 14/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit

class FlowLayoutColllectionView: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override var itemSize: CGSize {
        set{
        }
        get {
            let numberofcolums :CGFloat = 3
            
            let itemWidth = ((self.collectionView?.frame.width)! - (numberofcolums - 1)) / numberofcolums
            return CGSize(width: itemWidth, height: itemWidth)
            
        }
    }
    
    func setupLayout(){
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }

}
