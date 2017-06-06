//
//  JHSTwitterReportService.swift
//  TwitterStream
//
//  Created by dsailer on 4/19/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation

protocol TwitterReportServiceDelegate: class {
    
    func twitterReportServiceDidUpdateData()
}

class JHSTwitterReportService {

    weak var delegate:TwitterReportServiceDelegate?
    var tweetCount:Int32 = 0
    var tweetsWithUrlCount:Int32 = 0
    var tweetsWithPhotoCount:Int32 = 0
    private var whenStarted:Date!
    private var topHashTagHandler:JHSTopListHandler = JHSTopListHandler()
    private var topDomainHandler:JHSTopListHandler = JHSTopListHandler()
    private var priorInterval:Int32 = 0;
    
    init(withStartDate startDate:Date!) {
        
        self.whenStarted = startDate
    }
    
    func addTweets (tweets:Array<JHSTweet>) {
        
        for tweet in tweets {
            
            self.tweetCount+=1
        
            if ((tweet.urls?.count)! > 0) {
                self.tweetsWithUrlCount+=1
            }
            
            var stop = false
            tweet.media?.forEach({ (media) in
            
                if (!stop && media.type == "photo") {
                    self.tweetsWithPhotoCount+=1
                    stop = true
                }
            })

            tweet.hashTags?.forEach({ (hashTag) in
                
                self.topHashTagHandler.addItem(text: hashTag.text)
            })
        
            if let host = tweet.domainUrl?.host {
                self.topDomainHandler.addItem(text: host)
            }
        }
        
        self.delegate?.twitterReportServiceDidUpdateData()
        
    }

    func topDomains () -> Array<JHSHash> {
 
        return self.topDomainHandler.topItems();
    }
 
    func topHashTags () -> Array<JHSHash> {
 
        return self.topHashTagHandler.topItems();
    }
 
    func averageTweetsPerSecond () -> Int32 {
 
        let elapsed = round(Date().timeIntervalSince(self.whenStarted))
        
        if (elapsed > 0) {
            return self.tweetCount / (Int32(elapsed) + self.priorInterval)
        }
        else {
            return 0
        }
    }

    func averageTweetsPerMinute () -> Int32 {

        return self.averageTweetsPerSecond() * 60
    }
    
    func averageTweetsPerHour () -> Int32 {
        
        return self.averageTweetsPerMinute() * 60
    }
  
    func pauseTime() {
        
        let elapsed = round(Date().timeIntervalSince(self.whenStarted))
        self.priorInterval += Int32(elapsed)
    }
    
    func resetTime() {

        self.whenStarted = Date()        
    }
    
    func resetStatistics () {
        
        self.whenStarted = Date()
        self.priorInterval = 0
        self.tweetCount = 0
        self.tweetsWithUrlCount = 0
        self.tweetsWithPhotoCount = 0
        self.topHashTagHandler = JHSTopListHandler()
        self.topDomainHandler = JHSTopListHandler()
    }
    
    
    func percentOfTweetsWithUrl() -> Double {

        return Double(self.tweetsWithUrlCount) / Double(self.tweetCount)
    }
    
    func percentOfTweetsWithPhoto() -> Double {
        
        return Double(self.tweetsWithPhotoCount) / Double(self.tweetCount)
    }
    
}
