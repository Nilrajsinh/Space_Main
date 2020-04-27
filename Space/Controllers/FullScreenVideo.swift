//
//  FullScreenVideo.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 19/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import GoogleMobileAds
import Photos

class FullScreenVideo: UIViewController,GADInterstitialDelegate {
    
    var selectedVideo = [""]
      
    var interstitial: GADInterstitial!
   
    var url = String()
    var playerLayer: AVPlayerLayer?
      var player: AVPlayer?
      var isLoop: Bool = true
    
    @IBOutlet weak var Player: PlayerView!
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    
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
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4454896708430305/7246283364")
                 let request = GADRequest()
                 interstitial.load(request)
             interstitial = createAndLoadInterstitial()
             interstitial.delegate = self
        
 
        // Do any additional setup after loading the view.
    }
  
    
    
    //Button
    
    @IBAction func Play(_ sender: Any) {
        
      
        
         let vidUrl = URL(string: url)
        
        
        let avplayer = AVPlayer(url: vidUrl as! URL )
        
        let videoplayer = AVPlayerViewController()
        
        videoplayer.player = avplayer
        self.present(videoplayer, animated: true , completion: {
            avplayer.play()
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
                     }
        })
        
    }
    
    
    
    @IBAction func SaveBtn(_ sender: Any) {
        let videoImageUrl = url

        DispatchQueue.global(qos: .background).async {
            if let urls = URL(string: self.url),
                let urlData = NSData(contentsOf: urls) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/tempFile.mp4"
                DispatchQueue.main.async {
                    self.showToast(message: "Saved", font: .systemFont(ofSize: 20))
                    
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            
                           
                            print("Video is saved!")
                            
                            
                        }
                    }
                }
            }
        }
        
    }
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
   
    
    @IBAction func Share(_ sender: Any) {
        
           let urls = URL(string: self.url)
         let urlData = NSData(contentsOf: urls!)
        
        
        let activityVC = UIActivityViewController(activityItems: [URL(string: url)], applicationActivities: nil)
                        activityVC.popoverPresentationController?.sourceView = self.view
                        present(activityVC ,animated : true ,completion : nil)
        if interstitial.isReady {
                   interstitial.present(fromRootViewController: self)
                 }

       }
    
    
   

   

}
