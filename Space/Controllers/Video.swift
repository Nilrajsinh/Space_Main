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
            
         ///
           
            
            do {
                       if #available(iOS 13, *) {
                           //If on iOS13 slice the URL to get the name of the file
                           let urlString = vidURL!.relativeString
                           let urlSlices = urlString.split(separator: ".")
                           //Create a temp directory using the file name
                           let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                           let targetURL = tempDirectoryURL.appendingPathComponent(String(urlSlices[1])).appendingPathExtension(String(urlSlices[2]))

                           //Copy the video over
                           try FileManager.default.copyItem(at: vidURL!, to: targetURL)

                           picker.dismiss(animated: true) {
                            let videoref = Storage.storage().reference().child(appDelegate.loginUserID).child("Video/" + self.randomstring(20))
                                  
                                  
                            let uploadtask = videoref.putFile(from: targetURL, metadata: nil) { (metadata, error) in
                                      if error != nil {
                                          print("Failed to upload video :",error)
                                      }
                                      else{
                                        videoref.downloadURL { (url, error) in
                                                           guard let downloadURL = url else {
                                                        
                                                               return
                                                           }
                                           
                                                           print(downloadURL)
                                            let key = self.ref.child(appDelegate.loginUserID).child("Video").childByAutoId().key
                                            let video = ["url":downloadURL.absoluteString]
                                            
                                            //To get Url
                                            let childUpdate = ["/\(key ?? "")":video]
                                            self.ref.updateChildValues(childUpdate)
                                            
                                            self.collectionView.reloadData()
                                            
                                        }
                                           print("Video Upload Done")
                                      }
                                     
                                  }
                           }
                       }
                       else {
                           //If on iOS12 just use the original URL
                           picker.dismiss(animated: true) {
                            let videoref = Storage.storage().reference().child(appDelegate.loginUserID).child("Video/" + self.randomstring(20))
                               
                               
                               let uploadtask = videoref.putFile(from: vidURL!, metadata: nil) { (metadata, error) in
                                   if error != nil {
                                       print("Failed to upload video :",error)
                                   }
                                   else{
                                       videoref.downloadURL { (url, error) in
                                                           guard let downloadURL = url else {
                                                        
                                                               return
                                                           }
                                      
                                        
                                                           print(downloadURL)
                                            let key = self.ref.child(appDelegate.loginUserID).child("Video").childByAutoId().key
                                            let video = ["url":downloadURL.absoluteString]
                                            
                                            //To get Url
                                            let childUpdate = ["/\(key ?? "")":video]
                                            self.ref.updateChildValues(childUpdate)
                                            
                                            self.collectionView.reloadData()
                                            
                                        }
                                           print("Video Upload Done")
                                   }
                                  
                               }
                             
                           }
                       }
                   }
                   catch let error {
                       //Handle errors
                   }
            
            ///
     
      
        }
        
    }
    
    func LoadVideo(){

           ref.observe(DataEventType.value) { (snapshot) in
               var newImage = [Space_picture]()

               for spacePic in snapshot.children {
                   let SpacePicObject = Space_picture(snapshot: spacePic as! DataSnapshot)
                   newImage.append(SpacePicObject)
               }
               self.Video = newImage
               self.collectionView.reloadData()
           }


       }
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         ref = Database.database().reference().child(appDelegate.loginUserID).child("Video")
        
        var CustomImageFlow = FlowLayoutColllectionView()
            collectionView.collectionViewLayout = CustomImageFlow
            collectionView.backgroundColor =  .black
         
        self.LoadVideo()
       imagePicker.delegate = self
        collectionView.reloadData()
        // Register cell classes
        
        // Do any additional setup after loading the view.
    }

   

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           print(Video.count)
        // #warning Incomplete implementation, return the number of items
        return Video.count
     
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! VideoCell
    
        let url = Video[indexPath.row].url
        
        let vidUrl = URL(string: url!)
        
        let avplayer = AVPlayer(url: vidUrl as! URL )
        
      
        cell.Player.PlayerLayer.player = avplayer
        
        cell.Player.player?.play()
        cell.Player.player?.isMuted = true
     
        
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

   

}
