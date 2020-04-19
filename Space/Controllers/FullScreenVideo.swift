//
//  FullScreenVideo.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 19/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit

class FullScreenVideo: UIViewController {
    
    @IBOutlet weak var Player: PlayerView!
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
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
