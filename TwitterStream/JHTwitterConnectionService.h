//
//  JHTwitterConnectionService.h
//  TwitterStream
//
//  Created by dsailer on 5/21/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Accounts/Accounts.h>
#import "JHTwitterStreamParser.h"
#import <AFNetworking/AFNetworking.h>

@protocol TwitterServiceConnectionProtocol <NSObject>

- (void)twitterServiceConnectionDidReceiveTweets:(NSArray *_Nonnull)tweets;
- (void)twitterServiceConnectionDidLooseConnection;

@end

@interface JHTwitterConnectionService : NSObject

- (id _Nonnull)initWithSessionManager:(AFHTTPSessionManager * _Nonnull)sessionManager;
- (id _Nonnull)initWithParser:(JHTwitterStreamParser * _Nonnull)parser;

- (void)initStreamingConnectionForPattern:(NSString *_Nonnull)pattern withAccount:(ACAccount *_Nonnull)account;
- (void)stopStreaming;

@property (nullable, nonatomic, weak) id <TwitterServiceConnectionProtocol> delegate;

@end
