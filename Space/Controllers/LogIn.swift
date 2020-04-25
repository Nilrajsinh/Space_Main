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
import AuthenticationServices
import CryptoKit

class LogIn: UIViewController
, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    fileprivate var currentNonce: String?

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
         
        
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }

        // Retrieve Apple identity token
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Failed to fetch identity token")
            return
        }

        // Convert Apple identity token to string
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Failed to decode identity token")
            return
        }

        // Initialize a Firebase credential using secure nonce and Apple identity token
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
        Auth.auth().signIn(with: firebaseCredential) { [weak self] (authResult, error) in
            // Do something after Firebase sign in completed
            UserDefaults.standard.set(true, forKey: "ISUSERLOGGEDIN")
                      UserDefaults.standard.synchronize()
                      
                       appDelegate.loginUserID = authResult?.user.uid ?? ""
            self!.performSegue(withIdentifier: "Home", sender: nil)
            print("Ohh")
        }
        
        
        print("appleid Credentail:\(appleIDCredential.user)")
        
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleID Credential failed with error: \(error.localizedDescription)")
    }
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
         return self.view.window!
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSignInButton()
    
    
    
         let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
                     
                     view.addGestureRecognizer(tap)


       
      
        
//        GIDSignIn.sharedInstance().signIn()
        
        if Auth.auth().currentUser?.uid != nil {
                       appDelegate.loginUserID = Auth.auth().currentUser?.uid as! String
                           self.performSegue(withIdentifier: "Home", sender: nil)
                         }
   
        
    }
    
   


    
  
    
    @objc func dismissKeyboard() {
                  view.endEditing(true)
                 
              }
    
    
    
    
    
    private func setupSignInButton() {
        let signInButton = ASAuthorizationAppleIDButton(type: .default, style: .black)
        signInButton.cornerRadius = 20
           signInButton.addTarget(self, action: #selector(LogIn.signInButtonTapped), for: .touchDown)
           
           signInButton.translatesAutoresizingMaskIntoConstraints = false
           self.view.addSubview(signInButton)
           
           NSLayoutConstraint.activate([
            
            
            NSLayoutConstraint(item: signInButton, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: -150),
            NSLayoutConstraint(item: signInButton,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1,
            constant: 0),
            
               signInButton.heightAnchor.constraint(equalToConstant: 50),
               
               signInButton.widthAnchor.constraint(equalToConstant: 250)
           ])
      
       }
    
   
    
    
    @objc private func signInButtonTapped() {
        startSignInWithAppleFlow()
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request = authorizationProvider.createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
 private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }



    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}

