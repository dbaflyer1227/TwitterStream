//
//  JHSTwitterStreamParser.swift
//  TwitterStream
//
//  Created by dsailer on 4/18/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation

class JHSTwitterStreamParser: NSObject {
    
    var leftover:String?;
    var totatlTweet:String?
    var expectedLength:Int = 0

    override init() {
        super.init()
    }
    
    func tweets (tweetData: Data!) -> Array<JHSTweet> {
        
        var tweets:Array<JHSTweet> = Array<JHSTweet>()
        let rawTweets = String(data: tweetData, encoding: .utf8)
        let rawTweetList = rawTweets?.components(separatedBy: "\r\n")
        
        //print("tweets have arrived \(rawTweetList?.count ?? 0)")
        
        for tweet in rawTweetList! {

            //print(tweet + "\n")
            
            if (!tweet.isEmpty) {
            
                if (tweet.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil) {
                    
                    //  we have a number which should tell me how many characters are in the tweet (including \r\n
                    //
                    expectedLength = Int(tweet)!
                    expectedLength -= 2
                    //print("expected tweet length \(expectedLength)")
                    totatlTweet = nil
                }
                else {
                    
                    //  now we have an actual tweet
                    //
                    var tweetLength = tweet.characters.count
                    //print("tweet length \(tweetLength)")

                    if (totatlTweet != nil) {
                    
                        // We have a previous partial to concatenate to
                        //
                        totatlTweet = totatlTweet! + tweet
                        tweetLength = (totatlTweet?.characters.count)!
                        
                        //print("adjusted tweet length with partial \(tweetLength)")

                    }
                    else {
                        totatlTweet = String.init(stringLiteral: tweet)
                        //print("setting partial tweet")
                    }

                    if (tweetLength == expectedLength) {
                        
                        autoreleasepool {

                            do{
                            
                                if (totatlTweet != nil) {
                                
                                    let tweetDict = try JSONSerialization.jsonObject(with: (totatlTweet!.data(using: .utf8))!, options: .allowFragments) as! [String:Any]
                                
                                    //print("actual processed tweet length \(totatlTweet?.characters.count ?? 0)")
                                
                                    //print(tweetDict)

                                    guard let tweet = JHSTweet(json: tweetDict) else {
                                        //print("json parsing error")
                                        // print("tweet text is missing, possibly a tracking object")
                                        // print(tweetDict)
                                        return
                                    }
                                    
                                    tweets.append(tweet)

                                }

                            }
                            catch let error as NSError {
                                print("error parsing json string to dictionary: \(error)")
                            }
                        }
                    }
                    
                }
            
            }
        }
        
        return tweets
    }
}
