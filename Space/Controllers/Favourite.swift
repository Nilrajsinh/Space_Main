//
//  Favourite.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 13/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage




class Favourite: UICollectionViewController {

    
    var LikePic = [Space_picture]()
    
   
    
    var ref: DatabaseReference!
       var CustomImageFlow : FlowLayoutColllectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference().child(appDelegate.loginUserID).child("LikedImages")
              
               
        self.loadDb()
                self.tabBarController?.tabBar.isHidden = false
               
               var CustomImageFlow = FlowLayoutColllectionView()
               collectionView.collectionViewLayout = CustomImageFlow
             
        
        collectionView.reloadData()
       
    }
    
    
     override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = false
     }
    
    
    func loadDb(){
      
        ref.observe(DataEventType.value) { (snapshot) in
            var newImage = [Space_picture]()
            
            for spacePic in snapshot.children {
                let SpacePicObject = Space_picture(snapshot: spacePic as! DataSnapshot)
                newImage.append(SpacePicObject)
            }
            self.LikePic = newImage
            self.collectionView.reloadData()
        }
        
        
    }
    

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return LikePic.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LikedCell
              // cell.Picture.image = picture[indexPath.row]
           
               cell.Picture.sd_setImage(with: URL(string: LikePic[indexPath.row].url), placeholderImage: #imageLiteral(resourceName: "crop.php"))
           
               return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//         var drawVC  = self.storyboard?.instantiateViewController(withIdentifier: "DetailScene") as! FullScreenPic
//          
//               drawVC.imageURL = LikePic[indexPath.row].url
//
//               // you can also pass string from array
//               self.navigationController?.pushViewController(drawVC, animated: true)
//    }
    
   
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
