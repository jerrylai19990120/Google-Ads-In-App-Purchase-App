//
//  ViewController.swift
//  Daily Dose
//
//  Created by Jerry Lai on 2021-02-01.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var removeAdsBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAds()
        
    }
    
    func setUpAds(){
        if UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_REMOVE_ADS) {
            removeAdsBtn.removeFromSuperview()
            bannerView.removeFromSuperview()
        } else {
            
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            
            bannerView.load(GADRequest())
        }
    }

    @IBAction func removeBtnPressed(_ sender: Any) {
        PurchaseManager.instance.purchaseRemoveAds { (success) in
            if success {
                self.bannerView.removeFromSuperview()
                self.removeAdsBtn.removeFromSuperview()
            } else {
                //failed to make the purchase
            }
        }
    }
    
    @IBAction func restoreBtnPressed(_ sender: Any) {
        PurchaseManager.instance.restorePurchases { (success) in
            if success {
                self.setUpAds()
            }
        }
    }
}

