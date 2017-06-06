//
//  JHSLoginViewController.swift
//  TwitterStream
//
//  Created by dsailer on 4/18/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation
import UIKit

class JHSLoginViewController: UIViewController, AccountManagerDelegate {
    
    @IBOutlet weak var twitterName: UILabel!
    @IBOutlet weak var streamButton: UIButton!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    var accountManager:JHSAccountManager = JHSAccountManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.accountManager.delegate = self
        self.twitterName.text = nil
        self.tryAgainButton.isHidden = true
        self.streamButton.isHidden = true
        self.accountManager.requestAccessToTwitterAccount()
    }
    
    @IBAction func afterSuccess(_ sender: Any) {
    
        let viewController = JHSTwitterStreamViewController(nibName: "JHSTwitterStreamView", bundle: nil)
        
        viewController.account = self.accountManager.account
        self.present(viewController, animated: true, completion: nil)
    }
 
    @IBAction func tryAgain(_ sender: Any) {
    
        self.accountManager.requestAccessToTwitterAccount()
        self.tryAgainButton.isHidden = true;
    }
    
    func accountManagerAccountAccessAvailable() {
        
        self.twitterName.text = String(format: "Welcome %@", self.accountManager.account.username)
        self.streamButton.isHidden = false
        self.tryAgainButton.isHidden = true
    }
    
    func accountManagerAccountAccessNotAvailable() {
     
        self.tryAgainButton.isHidden = false
        self.presentFailureAlert(title: "Twitter Account Required", message: "Goto Settings and allow access to your twitter account")
    }
    
    func accountManagerAccountAccessNotGranted() {
        
        self.tryAgainButton.isHidden = false
        self.presentFailureAlert(title: "Twitter Account Required", message: "Goto Settings and allow access to your twitter account")
    }
 
    func accountManagerAccountAccessFailed(error: String!) {

        self.tryAgainButton.isHidden = false
        self.presentFailureAlert(title: "Twitter Account Failed", message: error)
    }
    
    func presentFailureAlert (title: String!, message: String!) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let continueAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(continueAction)
        
        show(alert, sender: self)
        
    }
 
}
