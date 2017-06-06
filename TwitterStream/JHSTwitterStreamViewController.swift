//
//  JHSTwitterStreamViewController.swift
//  TwitterStream
//
//  Created by dsailer on 4/18/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

import Foundation
import UIKit
import Accounts

class JHSTwitterStreamViewController: UIViewController, TwitterServiceDelegate, TwitterReportServiceDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var twitterName: UILabel!
    @IBOutlet weak var totalTweets: UILabel!
    @IBOutlet weak var averageTweets: UILabel!
    @IBOutlet weak var percentWithEmojis: UILabel!
    @IBOutlet weak var percentWithPhoto: UILabel!
    @IBOutlet weak var percentWithUrl: UILabel!
    @IBOutlet weak var topEmoji: UILabel!
    @IBOutlet weak var topHashTag: UILabel!
    @IBOutlet weak var topDomain: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var showDetailButton: UIButton!
    @IBOutlet weak var tweetRateChanger: UISegmentedControl!
    
    
    @IBOutlet weak var totalTweetsLabel: UILabel!
    @IBOutlet weak var averageTweetsLabel: UILabel!
    @IBOutlet weak var percentWithEmojiLabel: UILabel!
    @IBOutlet weak var percentWithUrlLabel: UILabel!
    @IBOutlet weak var percentWithPhotoLabel: UILabel!
    
    enum TweetRate: Int {
        case Hour = 0,
        Minute,
        Second
    }
    
    var twitterService:JHSTwitterService = JHSTwitterService()
    var reportService:JHSTwitterReportService = JHSTwitterReportService(withStartDate: Date())

    var topEmojiService:JHSTwitterTopEmojiService = JHSTwitterTopEmojiService()

    
    var running:Bool = false
    var tweetRateChosen:TweetRate!
    
    var account: ACAccount!

    private let tweetDispatchQueue = DispatchQueue(label: "net.hscsi.tweet.queue")

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillResignActive, object: nil, queue: nil, using: appHasGoneBackground(notification:))
        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: nil, using: appHasBecomeActive(notification:))
        
        self.tweetRateChosen = TweetRate.Second
        self.tweetRateChanger.selectedSegmentIndex = self.tweetRateChosen.rawValue
 
        self.twitterService.delegate = self
        self.reportService.delegate = self

        self.initView()
    }
 
    private func initView() {
        
        self.twitterName.text = self.account.username
        self.totalTweets.text = "0"
        self.averageTweets.text = "0"
        self.percentWithPhoto.text = "0%"
        self.percentWithUrl.text = "0%"
        self.percentWithEmojis.text = "0%"
        self.topDomain.text = nil
        self.topEmoji.text = nil
        self.topHashTag.text = nil
        
        self.showDetailButton.isHidden = true
    }
    
    
    private func updateStatistics () {
        
        DispatchQueue.main.async {

            self.updateAverageTweets()

            let totalTweetText = NSNumber.init(value: self.reportService.tweetCount)
            self.totalTweets.text = NumberFormatter.localizedString(from: totalTweetText, number: .decimal)
            
            if (self.topEmojiService.percentWithEmojis() > 0 || self.reportService.percentOfTweetsWithPhoto() > 0 || self.reportService.percentOfTweetsWithUrl() > 0) {
           
                self.percentWithEmojis.text = NumberFormatter.localizedString(from: NSNumber(value: self.topEmojiService.percentWithEmojis()), number: .percent)
                self.percentWithUrl.text = NumberFormatter.localizedString(from: NSNumber(value: self.reportService.percentOfTweetsWithUrl()), number: .percent)
                self.percentWithPhoto.text = NumberFormatter.localizedString(from: NSNumber(value: self.reportService.percentOfTweetsWithPhoto()), number: .percent)
            
                self.showDetailButton.isHidden = false
            }
            
            if let topDomain = self.reportService.topDomains().first {

                self.topDomain.text = topDomain.text + " (" + String(describing: topDomain.count) + ")";
            }

            if let topEmoji = self.topEmojiService.topEmojis().first {
                
                self.topEmoji.text = topEmoji.text + " (" + String(describing: topEmoji.count) + ")";
            }
            
            if let topHashTag = self.reportService.topHashTags().first {
                
                self.topHashTag.text = topHashTag.text + " (" + String(describing: topHashTag.count) + ")";
            }
 
        }
    }
 
    private func updateAverageTweets () {
 
        let totalTweetText = NSNumber.init(value: self.reportService.tweetCount)
        self.totalTweets.text = NumberFormatter.localizedString(from: totalTweetText, number: .decimal)
 
        if (self.tweetRateChosen == TweetRate.Second) {

            let tweetPerSecond = NSNumber.init(value: self.reportService.averageTweetsPerSecond())
            self.averageTweets.text = NumberFormatter.localizedString(from: tweetPerSecond, number: .decimal) + " / second"
        }
        else if (self.tweetRateChosen == TweetRate.Minute) {
            
            let tweetPerMinute = NSNumber.init(value: self.reportService.averageTweetsPerMinute())
            self.averageTweets.text = NumberFormatter.localizedString(from: tweetPerMinute, number: .decimal) + " / minute"
        }
        else {
            let tweetPerHour = NSNumber.init(value: self.reportService.averageTweetsPerHour())
            self.averageTweets.text = NumberFormatter.localizedString(from: tweetPerHour, number: .decimal) + " / hour"
        }
    }
 
    private func stopStreamingService() {
 
        self.startButton.isEnabled = true
        self.twitterService.stopStreaming()
        self.reportService.pauseTime()
    }
 
    @IBAction func startStreaming(_ sender: Any) {
 
        self.twitterService.initStreamingConnectionFor(pattern: "at", account: self.account)
        self.reportService.resetTime()
        self.startButton.isEnabled = false
        self.running = true
    }
 
    @IBAction func stopStreaming(_ sender: Any) {
   
        self.stopStreamingService()
        self.running = false
    }
    
    @IBAction func resetStatistics(_ sender: Any) {
    
        self.reportService.resetStatistics()
        self.topEmojiService.resetStatistics()
        self.initView()
    }
 
    @IBAction func tweetRateChange(_ sender: Any) {
     
        self.tweetRateChosen = TweetRate(rawValue: (sender as! UISegmentedControl).selectedSegmentIndex)
        self.updateAverageTweets()
    }
    
    @IBAction func showDetail(_ sender: Any) {
        
        let viewController = JHSTopItemTableViewController(nibName: "JHSTopItemTableView", bundle: nil)
       
        viewController.topEmojis = self.topEmojiService.topEmojis()
        viewController.topHashTags = self.reportService.topHashTags()
        viewController.topDomains = self.reportService.topDomains()

        let nav = UINavigationController.init(rootViewController: viewController)
        
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        nav.preferredContentSize = CGSize.init(width: 360, height: 640)
        
        let popoverMenuVc = nav.popoverPresentationController
        popoverMenuVc?.permittedArrowDirections = .any
        popoverMenuVc?.delegate = self
        popoverMenuVc?.sourceView = self.view
        popoverMenuVc?.sourceRect = CGRect.init(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        self.present(nav, animated: false, completion: nil)
        
    }
 
    func twitterReportServiceDidUpdateData() {
        
        self.updateStatistics()
    }
    
    func twitterServiceDidReceive(tweets: Array<JHSTweet>) {
        
        tweetDispatchQueue.async {
            self.reportService.addTweets(tweets: tweets)
        }
        
        tweetDispatchQueue.async {
            self.topEmojiService.addTweets(tweets: tweets)
        }
    }
 
    func twitterServiceDidLooseConnection() {
        
        DispatchQueue.main.async {

            let alert = UIAlertController(title: "Lost Connection", message: "Would you like to restart?", preferredStyle: UIAlertControllerStyle.alert)
            
            let continueAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (UIAlertAction) in
            
                self.startStreaming(self)
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(continueAction)
            
            let stopAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) { (UIAlertAction) in
                
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(stopAction)
        
            self.show(alert, sender: self)
        }
    }
 
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
 
        return modalPresentationStyle
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        
        let doneButton = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(dismissDetail))
        
        let nav = controller.presentedViewController as! UINavigationController
        nav.topViewController?.navigationItem.leftBarButtonItem = doneButton
        
        return controller.presentedViewController
    }
    
    func dismissDetail () {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func appHasGoneBackground(notification:Notification) -> Void {
     
        if (self.running) {
            self.stopStreamingService()
        }
    }
    
    func appHasBecomeActive(notification:Notification) -> Void {
        
        if (self.running) {
            self.startStreaming(self)
        }
    }
}
