//
//  Pictures.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 13/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage
import GoogleMobileAds


class Pictures: UICollectionViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, photodelegate,GADBannerViewDelegate, GADInterstitialDelegate {
    
  var bannerView: GADBannerView!
    
    
    
    
  var interstitial: GADInterstitial!
    
    var picture = [Space_picture]()
    
    let imagePicker = UIImagePickerController()
    var ref: DatabaseReference!
    var CustomImageFlow : FlowLayoutColllectionView!
   
    
    var imgData : Data!
    var Picturecollection = [""]
    
    
    
      func delete(cell: PictureCell) {
          if let indexpath = collectionView.indexPath(for: cell) {
              
              //delete from database
            Database.database().reference().child(appDelegate.loginUserID).child("Images")
              
                        self.picture.remove(at: indexpath.item)
                        self.collectionView.deleteItems(at: [indexpath])
             
           
            }
        
          
      }
      
    
    
    

    @IBOutlet weak var AddbtnOut: UIBarButtonItem!
    
    @IBAction func AddBtn(_ sender: Any) {
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        }
        
        let picker =  UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
    
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancled picker")
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
             dismiss(animated: true, completion: nil)
        
        if let pickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            //UploadImageTo Firebase
            var data = Data()
            
            data = pickedimage.jpegData(compressionQuality: 0.8)!
            
            self.imgData = data
            let imageRef = Storage.storage().reference().child(appDelegate.loginUserID).child("Images/" + randomstring(20))
            
            _ = imageRef.putData(data, metadata: nil){ (metadata ,error) in
                guard let metadata = metadata else {
                    return
                }
                
                let size = metadata.size
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                 
                        return
                    }
                    print(downloadURL)
                    
                    let key = self.ref.child(appDelegate.loginUserID).child("Images").childByAutoId().key
                    let image = ["url":downloadURL.absoluteString]
                    
                    //To get Url
                    let childUpdate = ["/\(key ?? "")":image]
                    self.ref.updateChildValues(childUpdate)
                    
                    if self.interstitial.isReady {
                        self.interstitial.present(fromRootViewController: self)
                    }
                    
                    self.collectionView.reloadData()
                    
                }
        
                
            }
            
        }
   
    }

    func randomstring(_ length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomstring = ""
        
        for _ in 0..<length {
            let rand = arc4random_uniform(len)
            var nextchar = letters.character(at: Int(rand))
            randomstring += NSString(characters: &nextchar, length: 1) as String
          
        }
        return randomstring
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
          self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }

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
        
//        nativeAd.delegate = self
        
        
       
        
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
        
        ref = Database.database().reference().child(appDelegate.loginUserID).child("Images")
        imagePicker.delegate = self
        
        loadDb()
         self.tabBarController?.tabBar.isHidden = false
        
        var CustomImageFlow = FlowLayoutColllectionView()
        collectionView.collectionViewLayout = CustomImageFlow
        
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Do any additional setup after loading the view.
    }
    
    func adLoader(_ adLoader: GADAdLoader,
                   didReceive nativeAd: GADUnifiedNativeAd) {
        
       // A unified native ad has loaded, and can be displayed.
     }

     func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
         // The adLoader has finished loading ads, and a new request can be sent.
     }

    
    

    func loadDb(){
      
        ref.observe(DataEventType.value) { (snapshot) in
            var newImage = [Space_picture]()
            
            for spacePic in snapshot.children {
                let SpacePicObject = Space_picture(snapshot: spacePic as! DataSnapshot)
                newImage.append(SpacePicObject)
            }
            self.picture = newImage
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
        return picture.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PictureCell
        
        cell.DeleteBackground.layer.cornerRadius = cell.DeleteBackground.bounds.width / 2.0
        cell.DeleteBackground.layer.masksToBounds = true
        cell.delegate = self
        cell.DeleteBackground.isHidden = !isEditing
  
        
       // cell.Picture.image = picture[indexPath.row]
    
        cell.Picture.sd_setImage(with: URL(string: picture[indexPath.row].url), placeholderImage: #imageLiteral(resourceName: "crop.php"))
    
        return cell
    
    }
    
    
    //MARK: - Delete picture from collection view
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        AddbtnOut.isEnabled = !editing
        if let indexpaths = collectionView?.indexPathsForVisibleItems{
            for indexpath in indexpaths {
                if let cell = collectionView.cellForItem(at: indexpath) as? PictureCell {
                    cell.isEditing = editing
                    
                }
            }
        }
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       var drawVC  = self.storyboard?.instantiateViewController(withIdentifier: "DetailScene") as! FullScreenPic
   
        drawVC.imageURL = picture[indexPath.row].url
  
        if interstitial.isReady {
      interstitial.present(fromRootViewController: self)
    }
        
        //Error Error
        
//        drawVC.imgDataMain = imgData
        
        
        self.navigationController?.pushViewController(drawVC, animated: true)
    }

    
  

}
