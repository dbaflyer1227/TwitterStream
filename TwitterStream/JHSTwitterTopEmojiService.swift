//
//  JHSTwitterTopEmojiService.swift
//  TwitterStream
//
//  Created by dsailer on 4/19/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation

class JHSTwitterTopEmojiService {

    private var topEmojiHandler:JHSTopListHandler = JHSTopListHandler()
    private var tweetsWithEmojiCount:Int = 0
    private var totalTweets:Int = 0
    

    func topEmojis () -> Array<JHSHash> {

        return self.topEmojiHandler.topItems();
    }
    
    func addTweets (tweets:Array<JHSTweet>) {

        for tweet in tweets {
            
            self.totalTweets+=1
            
            let emojis:Array<String> = (tweet.text.emojis())
            
            if (emojis.count > 0) {
                self.tweetsWithEmojiCount+=1
            }
            
            for emoji in emojis {
                self.topEmojiHandler.addItem(text: emoji)
            }
        }
    }
 
    func resetStatistics () {
 
        self.tweetsWithEmojiCount = 0
        self.totalTweets = 0
        self.topEmojiHandler = JHSTopListHandler();
    }
    
    func tweetCount () -> Int {
        
        return self.tweetsWithEmojiCount
    }

    func totalTweetCount () -> Int {
        
        return self.totalTweets
    }
    
    func percentWithEmojis () -> Double {
        
        return Double(self.tweetsWithEmojiCount) / Double(self.totalTweets)        
    }
    
}
