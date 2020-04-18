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

    var Video = [""]
    
    let imagePicker = UIImagePickerController()
    
    
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
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                print("VIDEO URL: \(videoURL!)")
            
            var data = Data()
            
            do {
                data = try Data(contentsOf: videoURL! as URL)
            } catch  {
                print("Not Working")
            }
            
            Storage.storage().reference().child(appDelegate.loginUserID).child("Video/" + randomstring(20)).putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                            print("Faild to upload video",error!)
                                }
                        else{
                              print("Done")
                            }
            }
            

        }
         dismiss(animated: true, completion: nil)
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       imagePicker.delegate = self

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
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

   

}
