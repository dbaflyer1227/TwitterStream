//
//  JHTwitterStreamViewController.h
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface JHTwitterStreamViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *twitterUserName;
@property (weak, nonatomic) IBOutlet UILabel *totalTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentEmojisLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentUrlLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentPhotoLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tweetRateControl;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *topDomainLabel;
@property (weak, nonatomic) IBOutlet UILabel *topHashTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *topEmojisLabel;
@property (weak, nonatomic) IBOutlet UIButton *showDetailListButton;

@property (strong,nonatomic) ACAccount *account;

- (IBAction)startStreaming:(id )sender;
- (IBAction)resetStatistics:(id)sender;
- (IBAction)stopStreaming:(id)sender;

@end
