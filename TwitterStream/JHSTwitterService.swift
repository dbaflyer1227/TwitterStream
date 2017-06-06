//
//  JHSTwitterService.swift
//  TwitterStream
//
//  Created by dsailer on 4/19/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation
import Accounts
import Alamofire
import Social

protocol TwitterServiceDelegate: class {
    
    func twitterServiceDidReceive(tweets: Array<JHSTweet>)
    func twitterServiceDidLooseConnection()
}

class JHSTwitterService : NSObject, URLSessionDataDelegate, URLSessionTaskDelegate {
    
    weak var delegate:TwitterServiceDelegate?

    private let tweetDispatchQueue = DispatchQueue(label: "net.hscsi.tweet.queue")
    private var task:URLSessionDataTask!
    private var parser:JHSTwitterStreamParser = JHSTwitterStreamParser()
    
    func initStreamingConnectionFor(pattern:String!,account:ACAccount!) {
        
        let url = URL(string: "https://stream.twitter.com/1.1/statuses/filter.json")
        let params:Dictionary<String,String> = ["track": pattern, "delimited": "length"]

        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, url: url, parameters: params)
        request?.account = account
        self.startRequest(request: (request?.preparedURLRequest())!)
        self.parser = JHSTwitterStreamParser()
    
    }
 
    func startRequest(request:URLRequest) {
        
        let sessionConfig = URLSessionConfiguration.default
        
        let manager = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        
        self.task = manager.dataTask(with: request)
        self.task.resume()

    }
 
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        tweetDispatchQueue.async {

            let tweets:Array<JHSTweet> = self.parser.tweets(tweetData: data)
            
            if (tweets.count > 0) {
                
                // print("tweet count \(tweets.count)")
                self.delegate?.twitterServiceDidReceive(tweets: tweets)
                
                //if let rawTweets = String(data: data, encoding: .utf8) {
                //print(rawTweets)
                //}
            }
        }

    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
       // print("error getting xml string: " + (error?.localizedDescription)!)
       // self.delegate?.twitterServiceDidLooseConnection()
    }
    
    func suspendStreaming() {
        
        self.task.suspend()
    }
     
    func stopStreaming() {
 
       self.task.cancel()
    }
}
