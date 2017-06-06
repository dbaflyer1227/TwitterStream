//
//  JHAccountManager.h
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

@protocol AccountManagerProtocol <NSObject>

- (void)accountManagerAccountAccessNotAvailable;
- (void)accountManagerAccountAccessAvailable;
- (void)accountManagerAccountAccessNotGranted;
- (void)accountManagerAccountAccessFailedWithError:(NSString *_Nonnull)error;

@end

@interface JHAccountManager : NSObject

- (id _Nonnull )initWithAccountStore:(ACAccountStore *_Nonnull)store;

@property (nullable, nonatomic, weak) id <AccountManagerProtocol> delegate;
@property (nonatomic, readonly) ACAccount * _Nonnull account;

- (void)requestAccessToTwitterAccount;
- (BOOL)userHasAccessToTwitter;

@end
