//
//  FullScreenPic.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 14/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class FullScreenPic: UIViewController {

    @IBOutlet weak var FullImage: UIImageView!
     var ref: DatabaseReference!
    let storage = Storage.storage()
   
    var MainDataFull : Data!
    
    var imageURL : String?
    

    
  
    @IBAction func Save(_ sender: Any) {
        
   
                 let alert = UIAlertController(title: "Save", message: "Would you like to save photo??", preferredStyle: .alert)
                 let yeah = UIAlertAction(title: "Yeah", style: .default) { (action) in
            
                    UIImageWriteToSavedPhotosAlbum(self.FullImage.image!, nil, nil, nil)
                 }
                 let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                 alert.addAction(cancel)
                 alert.addAction(yeah)
                 self.present(alert, animated: true, completion: nil)
            
        
        
    }
    
    @IBAction func Share(_ sender: Any) {
        
        let activityVC = UIActivityViewController(activityItems: [FullImage.image], applicationActivities: nil)
              activityVC.popoverPresentationController?.sourceView = self.view
              present(activityVC ,animated : true ,completion : nil)
        
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
    
    
    @IBAction func LikePic(_ sender: Any) {
        var data = Data()
                  
        data = Data(imageURL!.utf8)
        
                  let imageRef = Storage.storage().reference().child(appDelegate.loginUserID).child("LikedImages/" + randomstring(20))
                  
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
                          let key = self.ref.child(appDelegate.loginUserID).child("LikedImages").childByAutoId().key
                          let image = ["url":downloadURL.absoluteString]
                          
                          //To get Url
                        
                          let childUpdate = ["/\(key ?? "")":image]
                        self.ref.child(appDelegate.loginUserID).child("LikedImages").updateChildValues(childUpdate)
                          
                      }
              
                      
                  }
        
    }
    
    @IBAction func DeletePic(_ sender: Any) {
  
        
        let deleteMess = Database.database().reference().child(appDelegate.loginUserID).child("Images")
     print(deleteMess)
        
    }
    
    var dimg = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      ref = Database.database().reference()
        
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        view.addGestureRecognizer(pinch)
        
        self.tabBarController?.tabBar.isHidden = true
        
      
        FullImage.image = dimg

        self.FullImage.sd_setImage(with: URL(string:imageURL!), placeholderImage: UIImage(named: "placeholder.png"),options: SDWebImageOptions(), completed: {(image, error, cacheType, imageURL) -> Void in
              print("image loaded")
          })
        // Do any additional setup after loading the view.
    }
    

    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        guard sender.view != nil else {
            return
        }
        if sender.state == .began || sender.state == .changed {
            sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)) as! CGAffineTransform
            sender.scale = 1.0
    
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
