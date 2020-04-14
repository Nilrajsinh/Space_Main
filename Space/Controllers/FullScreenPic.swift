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
    
    let storage = Storage.storage()
   
    
    
    
    var imageURL : String?
    
    var Mainurl : URL!
    
  
    @IBAction func Save(_ sender: Any) {
        
      
        
    }
    
    @IBAction func Share(_ sender: Any) {
    }
    
    @IBAction func LikePic(_ sender: Any) {
    }
    
    @IBAction func DeletePic(_ sender: Any) {
      
    }
    
    var dimg = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        
        
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
