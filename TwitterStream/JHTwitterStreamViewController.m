//
//  JHTwitterStreamViewController.m
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTwitterStreamViewController.h"

#import "JHTwitterService.h"
#import "JHTwitterConnectionService.h"
#import "JHTwitterReportService.h"
#import "JHHash.h"
#import "JHTopItemTableViewController.h"
#import "JHTwitterTopEmojiService.h"

typedef enum {
    TWEET_RATE_PER_HOUR = 0,
    TWEET_RATE_PER_MINUTE = 1,
    TWEET_RATE_PER_SECOND = 2
} TWEET_RATE;

@interface JHTwitterStreamViewController () <TwitterReportServiceProtocol,UIPopoverPresentationControllerDelegate,TwitterServiceConnectionProtocol>

@property (nonatomic, strong) JHTwitterReportService * _Nonnull reportService;
@property (nonatomic, strong) JHTwitterConnectionService * _Nonnull connectionService;
@property (nonatomic, strong) JHTwitterTopEmojiService * _Nonnull topEmojiService;

@property BOOL running;

@property NSUInteger tweetRateChosen;

@end

@implementation JHTwitterStreamViewController

dispatch_queue_t emojiQueue;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    emojiQueue = dispatch_queue_create("net.hscsi.slow.emoji.queue" , DISPATCH_QUEUE_SERIAL);
    
    self.connectionService = [[JHTwitterConnectionService alloc] init];
    self.connectionService.delegate = self;
    
    self.reportService = [[JHTwitterReportService alloc] init];
    self.reportService.delegate = self;
    
    self.tweetRateChosen = TWEET_RATE_PER_SECOND;
    self.tweetRateControl.selectedSegmentIndex = TWEET_RATE_PER_SECOND;
    
    self.topEmojiService = [[JHTwitterTopEmojiService alloc] init];
    
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

}

- (void)initView {
    
    self.twitterUserName.text = self.account.username;
    self.totalTweetsLabel.text = @"0";
    self.averageTweetsLabel.text = @"0";
    self.percentEmojisLabel.text = @"0.0%";
    self.percentUrlLabel.text = @"0.0%";
    self.percentPhotoLabel.text = @"0.0%";
    self.topDomainLabel.text = nil;
    self.topHashTagLabel.text = nil;
    self.topEmojisLabel.text = nil;
    
    self.showDetailListButton.hidden = YES;
}

- (IBAction)startStreaming:(id)sender {
    
    [self.connectionService initStreamingConnectionForPattern:@"at" withAccount:self.account];
    
    self.startButton.enabled = NO;
    self.running = YES;
}

- (IBAction)resetStatistics:(id)sender {
 
    [self.reportService resetStatistics];
    [self.topEmojiService resetStatistics];
    
    [self initView];
}

- (IBAction)stopStreaming:(id)sender {
    
    [self stopStreamingService];
    self.running = NO;
}

- (void)stopStreamingService {
    
    self.startButton.enabled = YES;
    [self.connectionService stopStreaming];
}


#pragma Twitter Service delegate
- (void)twitterServiceDidReceiveTweets:(NSArray *)tweets {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.reportService addTweets:tweets];
    });
    
    dispatch_async(emojiQueue, ^{
        [self.topEmojiService addTweets:tweets];
    });
}

- (void)twitterServiceDidLooseConnection {
    
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Lost Connection"
                               message:@"Would you like to restart?"
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

        [self startStreaming:self];

        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:continueAction];

    UIAlertAction *stopAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

        [self stopStreaming:self];

        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:stopAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma Twitter Report Service Delegate

- (void)twitterReportServiceDidUpdateData {
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [self updateAverageTweets];
        
        if ([self.topEmojiService totalTweetCount] > 0) {
            
            double percentWithEmojis = (double)[self.topEmojiService tweetCount] / [self.topEmojiService totalTweetCount];
            NSString *display = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:percentWithEmojis]
                                                                 numberStyle:NSNumberFormatterPercentStyle];
            self.percentEmojisLabel.text = [NSString stringWithFormat:@"%@",display];
        }
        
        self.percentUrlLabel.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:[self.reportService percentOfTweetsWithUrl]]
                                                                     numberStyle:NSNumberFormatterPercentStyle];
        self.percentPhotoLabel.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:[self.reportService percentOfTweetsWithPhoto]]
                                                                     numberStyle:NSNumberFormatterPercentStyle];
        
        JHHash *topDomain = [[self.reportService topDomains] firstObject];
        if (topDomain) {
            self.topDomainLabel.text = [NSString stringWithFormat:@"%@ (%@)",topDomain.text,topDomain.count];
            self.showDetailListButton.hidden = NO;
        }

        JHHash *topHash = [[self.reportService topHashTags] firstObject];
        if (topHash) {
            self.topHashTagLabel.text = [NSString stringWithFormat:@"%@ (%@)",topHash.text,topHash.count];
            self.showDetailListButton.hidden = NO;
        }
        

        JHHash *topEmoji = [[self.topEmojiService topEmojis] firstObject];
        if (topEmoji) {
            
            if (topEmoji.text) {
                self.topEmojisLabel.text = [NSString stringWithFormat:@"%@ (%@)",topEmoji.text,topEmoji.count];
                self.showDetailListButton.hidden = NO;
            }
        }
                
    });

}

- (void)updateAverageTweets {
    
    self.totalTweetsLabel.text = [NSNumberFormatter localizedStringFromNumber:@([self.reportService totalTweetCount])
                                                                  numberStyle:NSNumberFormatterDecimalStyle];
    
    if (self.tweetRateChosen == TWEET_RATE_PER_SECOND) {
        
        NSString *display = [NSNumberFormatter localizedStringFromNumber:@([self.reportService averageTweetsPerSecond])
                                                             numberStyle:NSNumberFormatterDecimalStyle];
        self.averageTweetsLabel.text = [NSString stringWithFormat:@"%@ %@",display,@"/ Second"];
    }
    else if (self.tweetRateChosen == TWEET_RATE_PER_MINUTE) {
        NSString *display = [NSNumberFormatter localizedStringFromNumber:@([self.reportService averageTweetsPerMinute])
                                                             numberStyle:NSNumberFormatterDecimalStyle];
        self.averageTweetsLabel.text = [NSString stringWithFormat:@"%@ %@",display,@"/ Minute"];
    }
    else {
        NSString *display = [NSNumberFormatter localizedStringFromNumber:@([self.reportService averageTweetsPerHour])
                                                             numberStyle:NSNumberFormatterDecimalStyle];
        self.averageTweetsLabel.text = [NSString stringWithFormat:@"%@ %@",display,@"/ Hour"];
    }
}

- (IBAction)tweetRateChanged:(UISegmentedControl *)sender {
    
    self.tweetRateChosen = sender.selectedSegmentIndex;
    [self updateAverageTweets];
}

- (void)appHasGoneInBackground:(NSNotification *)notification {

    if (self.running) {
        
        [self stopStreamingService];
    }
}

- (void)appHasBecomeActive:(NSNotification *)notification {
    
    //  only restart if I was previously running
    //
    if (self.running) {
        
        [self startStreaming:notification];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([@"showTopItemDetails" isEqualToString:segue.identifier]) {
        
        UINavigationController *nav = segue.destinationViewController;
        nav.popoverPresentationController.delegate = self;

        JHTopItemTableViewController *topItemVc = (JHTopItemTableViewController *)[nav topViewController];
        topItemVc.topEmojis = [self.topEmojiService topEmojis];
        topItemVc.topHashTags = [self.reportService topHashTags];
        topItemVc.topDomains = [self.reportService topDomains];
    }
    
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationFormSheet;
}

- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style {

    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    UINavigationController *nc = (UINavigationController *)controller.presentedViewController;
    nc.topViewController.navigationItem.leftBarButtonItem = bbi;
    return controller.presentedViewController;
}
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


- (void)twitterServiceConnectionDidReceiveTweets:(NSArray *)tweets {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.reportService addTweets:tweets];
    });
    
    dispatch_async(emojiQueue, ^{
        [self.topEmojiService addTweets:tweets];
    });
}

- (void)twitterServiceConnectionDidLooseConnection {
    
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Lost Connection"
                               message:@"Would you like to restart?"
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [self startStreaming:self];
        
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:continueAction];
    
    UIAlertAction *stopAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [self stopStreaming:self];
        
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:stopAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
