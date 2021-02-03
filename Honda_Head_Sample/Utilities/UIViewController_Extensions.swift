//
//  UIViewController_Extensions.swift
//  HondaHead
//
//  Created by Ryan Sady on 11/16/20.
//

import Foundation
import UIKit
import GoogleMobileAds

extension UIViewController {
    
    /// Shows an error message.
    /// - Parameter message: The error to display to the user.
    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// Loads a banner ad.
    /// - Parameter banner: The banner to load an ad for.
    func setupAdBanner(for banner: GADBannerView) {
        banner.adUnitID = AdMob_Client.adIdentifier
        banner.rootViewController = self
        banner.adSize = kGADAdSizeBanner
        banner.load(GADRequest())
    }

}
