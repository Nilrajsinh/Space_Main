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


private let reuseIdentifier = "Cell"



class Pictures: UICollectionViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
   
    
    let imagePicker = UIImagePickerController()
    var ref: DatabaseReference!
    
    
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
                    let childUpdate = ["/\(key ?? "")":image]
                    self.ref.child(appDelegate.loginUserID).child("Images").childByAutoId().updateChildValues(childUpdate)
            
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
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        ref = Database.database().reference()
        
        imagePicker.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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
