//
//  JHSTopListHandler.swift
//  TwitterStream
//
//  Created by dsailer on 4/18/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation


public class JHSTopListHandler: NSObject {

    private var list:Dictionary<String, JHSHash> = Dictionary<String, JHSHash>()
    
    let kMaxHashTagsToKeep:Int = 5

    func addItem (text: String) {
    
        objc_sync_enter(self)
        
        if let hash = self.list[text] {
            
            var hashCount:Int = (hash.count.intValue)
            hashCount+=1
            hash.count = NSNumber.init(value: hashCount)
            self.list.updateValue(hash, forKey: text)
        }
        else {
            
            let myHash:JHSHash = JHSHash(text: text, count: NSNumber.init(integerLiteral: 1))
            self.list.updateValue(myHash, forKey: text)
        }
        
        objc_sync_exit(self)

    }

    func topItems () -> Array<JHSHash>! {
        
        objc_sync_enter(self)
        
        let byValue = {
            (elem1:(key: String, val: JHSHash), elem2:(key: String, val: JHSHash))->Bool in
            if (elem1.val.count.intValue) > (elem2.val.count.intValue) {
                return true
            } else {
                return false
            }
        }
        
        let sortedDict = self.list.sorted(by: byValue)  // getting EXC_BAD_INSTRUCTION for emojis ????
        
        var keep:Int = 0
        var topHash:Array<JHSHash> = Array<JHSHash>()
        
        for (key, value) in sortedDict {

            if (keep <= kMaxHashTagsToKeep) {
                
                topHash.append(value)
            }
            else {
                self.list.removeValue(forKey: key)
            }
            
            keep+=1
            
        }
        
        objc_sync_exit(self)

 
        return topHash
    }

}
