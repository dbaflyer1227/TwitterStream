//
//  JHTwitterService.h
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import "JHTwitterStreamParser.h"

@protocol TwitterServiceProtocol <NSObject>

- (void)twitterServiceDidReceiveTweets:(NSArray *_Nonnull)tweets;
- (void)twitterServiceDidLooseConnection;

@end

@interface JHTwitterService : NSObject

- (id _Nonnull)initWithSessionManager:(NSURLSession * _Nonnull)sessionManager;
- (id _Nonnull)initWithParser:(JHTwitterStreamParser * _Nonnull)parser;

- (void)initStreamingConnectionForPattern:(NSString *_Nonnull)pattern withAccount:(ACAccount *_Nonnull)account;
- (void)stopStreaming;

@property (nullable, nonatomic, weak) id <TwitterServiceProtocol> delegate;

@end
