//
//  JHAccountManager.m
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHAccountManager.h"
#import <Social/Social.h>

@interface JHAccountManager ()

@property (nonatomic, strong, readwrite) ACAccount * _Nullable account;
@property (nonatomic, strong) ACAccountStore * _Nonnull store;

- (BOOL)userHasAccessToTwitter;

@end

@implementation JHAccountManager

- (id _Nonnull )initWithAccountStore:(ACAccountStore *_Nonnull)store {
    
    self = [super init];
    if (self) {
        
        _store = store;
    }
    return self;
}


- (BOOL)userHasAccessToTwitter {
    
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (ACAccountStore *)store {
    
    if (!_store) {
        _store =  [[ACAccountStore alloc] init];
    }
    return _store;
}

- (void)requestAccessToTwitterAccount {
    
    self.account = nil;
    
    if ([self userHasAccessToTwitter]) {
        
        ACAccountType *twitterAccountType = [self.store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Request permission to access the twitter account
        //
        [self.store requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
            
            if (error) {
                
                // Requesting access to Twitter failed.
                //
                if ([self.delegate respondsToSelector:@selector(accountManagerAccountAccessFailedWithError:)]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate accountManagerAccountAccessFailedWithError:[error localizedDescription]];
                    });
                }
                
            } else if (!granted) {
                    
                //  Twitter access was denied
                //
                if ([self.delegate respondsToSelector:@selector(accountManagerAccountAccessNotGranted)]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate accountManagerAccountAccessNotGranted];
                    });
                }
            }
            else {
                
                NSArray *twitterAccounts = [self.store accountsWithAccountType:twitterAccountType];
                if ([twitterAccounts count] > 0) {
                    
                    // We take the last account available (we only need it to get access to the API)
                    self.account = [twitterAccounts lastObject];
                    if ([self.delegate respondsToSelector:@selector(accountManagerAccountAccessAvailable)]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate accountManagerAccountAccessAvailable];
                        });
                    }
                }
            }
        }];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(accountManagerAccountAccessNotAvailable)]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate accountManagerAccountAccessNotAvailable];
            });
        }
    }
}

@end
