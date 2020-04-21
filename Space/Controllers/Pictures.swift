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





class Pictures: UICollectionViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var picture = [Space_picture]()
    
    let imagePicker = UIImagePickerController()
    var ref: DatabaseReference!
    var CustomImageFlow : FlowLayoutColllectionView!
   
    
    var imgData : Data!
    var Picturecollection = [""]
    
    @IBAction func AddBtn(_ sender: Any) {
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child(appDelegate.loginUserID).child("Images")
        imagePicker.delegate = self
        
        loadDb()
         self.tabBarController?.tabBar.isHidden = false
        
        var CustomImageFlow = FlowLayoutColllectionView()
        collectionView.collectionViewLayout = CustomImageFlow
        
        
        
        // Do any additional setup after loading the view.
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
       // cell.Picture.image = picture[indexPath.row]
    
        cell.Picture.sd_setImage(with: URL(string: picture[indexPath.row].url), placeholderImage: #imageLiteral(resourceName: "crop.php"))
    
        return cell
    
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       var drawVC  = self.storyboard?.instantiateViewController(withIdentifier: "DetailScene") as! FullScreenPic
   
        drawVC.imageURL = picture[indexPath.row].url
    
        
        //Error Error
        
       // drawVC.imgDataMain = imgData
        
        
        self.navigationController?.pushViewController(drawVC, animated: true)
    }

    
  

}
