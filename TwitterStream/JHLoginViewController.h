//
//  JHLoginViewController.h
//  TwitterStream
//
//  Created by dsailer on 4/9/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAccountManager.h"

@interface JHLoginViewController : UIViewController

- (id)initWithAccountManager:(JHAccountManager *)accountManager;

@property (weak, nonatomic) IBOutlet UILabel *twitterHandleLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *tryAgain;

@property (nonatomic, strong, readonly) JHAccountManager *accountManager;

@end
