//
//  JHSAccountManager.swift
//  TwitterStream
//
//  Created by dsailer on 4/18/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation
import Social
import Accounts

protocol AccountManagerDelegate: class {
  
    func accountManagerAccountAccessNotAvailable()
    func accountManagerAccountAccessAvailable()
    func accountManagerAccountAccessNotGranted()
    func accountManagerAccountAccessFailed(error: String!)
}

public class JHSAccountManager : NSObject {
    
    var account: ACAccount = ACAccount()
    weak var delegate:AccountManagerDelegate?


    func requestAccessToTwitterAccount() {
    
        if (userHasAccessToTwiter()) {
         
            let store:ACAccountStore = ACAccountStore()
            let twitterAccountType = store.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
            
            store.requestAccessToAccounts(with: twitterAccountType, options: nil, completion: { (granted, error) in
                
                if let myError = error {
                    
                    DispatchQueue.main.async {
                        self.delegate?.accountManagerAccountAccessFailed(error: myError.localizedDescription)
                    }
                }
                else if (!granted) {
                    DispatchQueue.main.async {
                        self.delegate?.accountManagerAccountAccessNotGranted()
                    }
                }
                else {
                    
                    let twitterAccounts:Array = store.accounts(with: twitterAccountType)
                    if (twitterAccounts.count > 0) {
                        
                        self.account = twitterAccounts[0] as! ACAccount;
                        DispatchQueue.main.async {
                            self.delegate?.accountManagerAccountAccessAvailable()
                        }
                    }
                }
            })
        }
        else {
 
            DispatchQueue.main.async {
                self.delegate?.accountManagerAccountAccessNotAvailable()
            }
        }
 
    }
 
    private func userHasAccessToTwiter() -> Bool {
 
        return SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
    }
}
