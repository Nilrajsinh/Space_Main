//
//  Space_picture.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 14/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import Foundation
import Firebase

struct Space_picture {
    let key:String!
     let url:String!
    
    let itemref:DatabaseReference?
    init(url:String, key:String) {
        self.key = key
        self.url = url
        self.itemref = nil
        
    }
    
    init(snapshot:DataSnapshot) {
        key = snapshot.key
        itemref = snapshot.ref
        let snapshotValue = snapshot.value as! NSDictionary
        if let imageurl = snapshotValue["url"] as? String {
            url = imageurl
        }
        else{
            url = ""
        }
        
    }
    
}
