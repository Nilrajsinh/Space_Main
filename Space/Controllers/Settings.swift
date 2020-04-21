//
//  Settings.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 20/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit
import Firebase

class Settings: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
         tabBarController?.tabBar.isHidden = false
    }
 
    @IBAction func About(_ sender: Any) {
        let Navigate = self.storyboard?.instantiateViewController(withIdentifier:"About")
                     
           self.navigationController?.pushViewController(Navigate!, animated: true)
        
    }
    @IBAction func Contact(_ sender: Any) {
        
        let Navigate = self.storyboard?.instantiateViewController(withIdentifier:"Contact")
                     
           self.navigationController?.pushViewController(Navigate!, animated: true)
        
       }
    @IBAction func LogOut(_ sender: Any) {
        
        try! Auth.auth().signOut()

        if let storyboard = self.storyboard {
            self.performSegue(withIdentifier: "BackLogin", sender: self)
                }
        
        
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
