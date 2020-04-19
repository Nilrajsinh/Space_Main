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

class FullScreenVideo: UIViewController {
    
    var selectedVideo = [""]
    
   
    var url = String()
    var playerLayer: AVPlayerLayer?
      var player: AVPlayer?
      var isLoop: Bool = true
    
    @IBOutlet weak var Player: PlayerView!
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
         let vidUrl = URL(string: url)
        
        let avplayer = AVPlayer(url: vidUrl as! URL )
        
        let videoplayer = AVPlayerViewController()
        
        videoplayer.player = avplayer
        self.present(videoplayer, animated: true , completion: {
            avplayer.play()
        })
        
    }
    
   
    
    @IBAction func Share(_ sender: Any) {
           
        
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                        activityVC.popoverPresentationController?.sourceView = self.view
                        present(activityVC ,animated : true ,completion : nil)
           
       }
    
    
   

   

}
