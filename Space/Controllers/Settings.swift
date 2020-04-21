//
//  Settings.swift
//  Space
//
//  Created by Nilrajsinh Vaghela on 20/04/20.
//  Copyright © 2020 Nilrajsinh Vaghela. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class Settings: UIViewController,GADBannerViewDelegate, GADInterstitialDelegate {
    
     var interstitial: GADInterstitial!
     var bannerView: GADBannerView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
         tabBarController?.tabBar.isHidden = false
    }
 
    @IBAction func About(_ sender: Any) {
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        }
            
        
        let Navigate = self.storyboard?.instantiateViewController(withIdentifier:"About")
                     
           self.navigationController?.pushViewController(Navigate!, animated: true)
        
    }
    @IBAction func Contact(_ sender: Any) {
        
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        }
            
        
        let Navigate = self.storyboard?.instantiateViewController(withIdentifier:"Contact")
                     
           self.navigationController?.pushViewController(Navigate!, animated: true)
        
       }
    @IBAction func LogOut(_ sender: Any) {
        
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        }
            
        try! Auth.auth().signOut()

        if let storyboard = self.storyboard {
            self.performSegue(withIdentifier: "BackLogin", sender: self)
                }
        
        
       }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
          bannerView.frame = CGRect(x: 0, y: (view.bounds.height - bannerView.frame.size.height) - 49, width: self.view.bounds.size.width, height: 49)
       bannerView.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(bannerView)
       view.addConstraints(
          
         [NSLayoutConstraint(item: bannerView,
                             attribute: .bottom,
                             relatedBy: .equal,
                             toItem: bottomLayoutGuide,
                             attribute: .top,
                             multiplier: 1,
                             constant: 0),
          NSLayoutConstraint(item: bannerView,
                             attribute: .centerX,
                             relatedBy: .equal,
                             toItem: view,
                             attribute: .centerX,
                             multiplier: 1,
                             constant: 0)
         ])
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
        
       
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

              addBannerViewToView(bannerView)
            bannerView.adUnitID = "ca-app-pub-4454896708430305/6275341843"
             bannerView.rootViewController = self
            bannerView.load(GADRequest())
              bannerView.delegate = self
      
        
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4454896708430305/7246283364")
                  let request = GADRequest()
                  interstitial.load(request)
              interstitial = createAndLoadInterstitial()
              interstitial.delegate = self
        
        
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
