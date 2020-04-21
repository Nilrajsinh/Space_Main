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
import GoogleMobileAds



class Favourite: UICollectionViewController,GADBannerViewDelegate, GADInterstitialDelegate {

     var interstitial: GADInterstitial!
    
    var LikePic = [Space_picture]()
    
    var bannerView: GADBannerView!
    
    var ref: DatabaseReference!
       var CustomImageFlow : FlowLayoutColllectionView!
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
          bannerView.frame = CGRect(x: 0, y: (view.bounds.height - bannerView.frame.size.height) - 49, width: self.view.bounds.size.width, height: 49)
       bannerView.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(bannerView)
       view.addConstraints(
          
         [NSLayoutConstraint(item: bannerView,
                             attribute: .bottom,
                             relatedBy: .equal,
                             toItem: bottomLayoutGuide,
                             attribute: .top,
                             multiplier: 1,
                             constant: 0),
          NSLayoutConstraint(item: bannerView,
                             attribute: .centerX,
                             relatedBy: .equal,
                             toItem: view,
                             attribute: .centerX,
                             multiplier: 1,
                             constant: 0)
         ])
      }
    
    func createAndLoadInterstitial() -> GADInterstitial {
         var interstitial = GADInterstitial(adUnitID: "ca-app-pub-4454896708430305/7246283364")
         interstitial.delegate = self
         interstitial.load(GADRequest())
         return interstitial
       }

       func interstitialDidDismissScreen(_ ad: GADInterstitial) {
         interstitial = createAndLoadInterstitial()
       }
    
      
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference().child(appDelegate.loginUserID).child("LikedImages")
              
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

              addBannerViewToView(bannerView)
            bannerView.adUnitID = "ca-app-pub-4454896708430305/6275341843"
             bannerView.rootViewController = self
            bannerView.load(GADRequest())
              bannerView.delegate = self
        
             
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4454896708430305/7246283364")
                  let request = GADRequest()
                  interstitial.load(request)
              interstitial = createAndLoadInterstitial()
              interstitial.delegate = self
        
        
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
//    if interstitial.isReady {
//  interstitial.present(fromRootViewController: self)
//}
    
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
