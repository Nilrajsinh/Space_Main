//
//  PlayerView.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 19/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class PlayerView: UIView {

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var PlayerLayer : AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player : AVPlayer? {
        get {
            return PlayerLayer.player
        
        }
        set {
            PlayerLayer.player = newValue
        }
    }
    
   
}
