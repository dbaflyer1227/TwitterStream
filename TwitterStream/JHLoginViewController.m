//
//  JHLoginViewController.m
//  TwitterStream
//
//  Created by dsailer on 4/9/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHLoginViewController.h"
#import "JHAccountManager.h"
#import "JHTwitterStreamViewController.h"

@interface JHLoginViewController () <AccountManagerProtocol>

@property (nonatomic, strong) JHAccountManager * _Nonnull accountManager;

@end

@implementation JHLoginViewController

- (id)initWithAccountManager:(JHAccountManager *)accountManager {
    
    self = [super init];
    if (self) {
        _accountManager = accountManager;
    }
    return self;
}

- (JHAccountManager *)accountManager {
    
    if (!_accountManager) {
        _accountManager = [[JHAccountManager alloc] init];
    }
    return _accountManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.accountManager.delegate = self;
    
    self.twitterHandleLabel.text = nil;
    self.tryAgain.hidden = YES;
    self.continueButton.hidden = YES;
    [self.accountManager requestAccessToTwitterAccount];
}

- (IBAction)tryAgain:(id)sender {
    
    [self.accountManager requestAccessToTwitterAccount];
    self.tryAgain.hidden = YES;
}

#pragma Account Manager delegate

- (void)accountManagerAccountAccessAvailable {
    
    self.twitterHandleLabel.text = [NSString stringWithFormat:@"Welcome  %@", self.accountManager.account.username];
    
    self.continueButton.hidden = NO;
}

- (void)accountManagerAccountAccessFailedWithError:(NSString *)error {
    
    self.tryAgain.hidden = NO;

    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Twitter Account Access Failed"
                               message:error
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)accountManagerAccountAccessNotAvailable {
    
    self.tryAgain.hidden = NO;

    // User must give us access to their twitter account
    //
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Twitter Account Required"
                               message:@"Goto Settings and create a Twitter Account"
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)accountManagerAccountAccessNotGranted {
    
    self.tryAgain.hidden = NO;
    
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Twitter Account Required"
                               message:@"Goto Settings and allow access to your Twitter account"
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([@"showTwitterFeed" isEqualToString:segue.identifier]) {
        
        JHTwitterStreamViewController *vc = segue.destinationViewController;
        vc.account = self.accountManager.account;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
