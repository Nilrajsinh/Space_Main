//
//  LogIn.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 08/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LogIn: UIViewController,GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        if let error = error {
          // ...
          return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
       
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
        let googlebutton = GIDSignInButton()
        googlebutton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
        view.addSubview(googlebutton)
        
        Login.layer.cornerRadius = 20
        
       GIDSignIn.sharedInstance()?.presentingViewController = self
     //  GIDSignIn.sharedInstance().signIn()
        // Do any additional setup after loading the view.
    }
    
   

    
    @IBAction func LoginBtn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: Email.text!, password: Password.text!) { (user, error) in
            if error != nil {
                print("Error")
            }
             appDelegate.loginUserID = user?.user.uid ?? ""
            self.performSegue(withIdentifier: "Home", sender: nil)
        }
    }
    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    

}

