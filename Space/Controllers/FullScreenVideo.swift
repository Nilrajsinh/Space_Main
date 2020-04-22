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
        
        
        
        
//        let vidUrl = URL(string: url)
//
//              let avplayer = AVPlayer(url: vidUrl as! URL )
//
//
//              Player.PlayerLayer.player = avplayer
//
//              Player.player?.play()
        
        
        // Do any additional setup after loading the view.
    }
  
    
    
    //Button
    
    @IBAction func Play(_ sender: Any) {
        
        if interstitial.isReady {
             interstitial.present(fromRootViewController: self)
           }
        
         let vidUrl = URL(string: url)
        
        let avplayer = AVPlayer(url: vidUrl as! URL )
        
        let videoplayer = AVPlayerViewController()
        
        videoplayer.player = avplayer
        self.present(videoplayer, animated: true , completion: {
            avplayer.play()
        })
        
    }
    
   
    
    @IBAction func Share(_ sender: Any) {
           
        if interstitial.isReady {
             interstitial.present(fromRootViewController: self)
           }
        
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                        activityVC.popoverPresentationController?.sourceView = self.view
                        present(activityVC ,animated : true ,completion : nil)
           
       }
    
    
   

   

}
