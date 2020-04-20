//
//  ContactViewController.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 20/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit
import Firebase

class ContactViewController: UIViewController {

     var ref: DatabaseReference!
    
    
    @IBOutlet weak var TextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
          navigationController?.navigationBar.isHidden = false
         tabBarController?.tabBar.isHidden = true
      }
    
    
    @IBAction func SubmitBtn(_ sender: Any) {
        
        
        ref.child("Req").child(appDelegate.loginUserID).childByAutoId().setValue(TextField.text!)
        
        if TextField.text != "" {
                             let alert = UIAlertController(title: "Okay", message: "We Have Got your problem Our advisoure will be in touch with you shortly", preferredStyle: .alert)
                                 let restartAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                                 alert.addAction(restartAction)
                                 present(alert, animated: true, completion: nil)
                       }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  ref = Database.database().reference()
        
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
                    
                    view.addGestureRecognizer(tap)
        
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
    
    @objc func dismissKeyboard() {
                  view.endEditing(true)
                 
              }
    

}
