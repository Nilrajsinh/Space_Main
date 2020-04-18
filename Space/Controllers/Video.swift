//
//  Video.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 13/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Firebase

private let reuseIdentifier = "Cell"

class Video: UICollectionViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
 
    var CustomImageFlow : FlowLayoutColllectionView!
    var Videost = [""]
    var Video = [Space_picture]()
    let imagePicker = UIImagePickerController()
      var ref: DatabaseReference!
    
    @IBAction func addVideo(_ sender: Any) {
        let picker =  UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
        picker.mediaTypes = [kUTTypeMovie as String]
        
            present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           print("Cancled picker")
           self.dismiss(animated: true, completion: nil)
       }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let VideoUrl = info[UIImagePickerController.InfoKey.mediaType] as AnyObject
        
        if  VideoUrl as! String == kUTTypeMovie as String {
            let vidURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                print("VIDEO URL: \(vidURL!)")
            
            var data = Data()
            
            do {
                data = try Data(contentsOf: vidURL! as URL)
            } catch  {
                print("Not Working")
            }
            
          let uploadtask = Storage.storage().reference().child(appDelegate.loginUserID).child("Video/" + randomstring(20)).putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                            print("Faild to upload video",error!)
                                }
                        else{
               
                    let key = self.ref.child(appDelegate.loginUserID).child("Video").childByAutoId().key
                    let MainVid = ["url":vidURL!.absoluteString]
                    
                    //To get Url
                    let childUpdate = ["/\(key ?? "")":MainVid]
                    self.ref.child(appDelegate.loginUserID).child("Video").updateChildValues(childUpdate)
                    
                    self.collectionView.reloadData()
                    
                    if let VideoUrl = vidURL?.absoluteString{
                        print(VideoUrl)
                    }
                    
                    let Propertise : [String:AnyObject] = ["Video Url":VideoUrl]
                    
                    
//                    let thumbnailImage = self.ThumbnailImageForVideoUrl(videourl: vidURL!)
                    
//                    self.sendMessageWithProperTise(Propertise)
                    
                              print("Done")
                            }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
//    func LoadVideo(){
//
//           ref.observe(DataEventType.value) { (snapshot) in
//               var newImage = [Space_picture]()
//
//               for spacePic in snapshot.children {
//                   let SpacePicObject = Space_picture(snapshot: spacePic as! DataSnapshot)
//                   newImage.append(SpacePicObject)
//               }
//               self.Video = newImage
//               self.collectionView.reloadData()
//           }
//
//
//       }
    
    
//    private func ThumbnailImageForVideoUrl(videourl:URL) -> UIImage{
//
////     Baki che 23:07
//        return
//
//    }
//    func sendMessageWithProperTise() {
//        return
//
//    }
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        var CustomImageFlow = FlowLayoutColllectionView()
            collectionView.collectionViewLayout = CustomImageFlow
            collectionView.backgroundColor =  .black
            
        
        
       // self.LoadVideo()
       imagePicker.delegate = self
        ref = Database.database().reference()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

   

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Video.count
        print(Video.count)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

   

}
