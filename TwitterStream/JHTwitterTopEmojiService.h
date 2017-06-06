//
//  JHTwitterTopEmojiService.h
//  TwitterStream
//
//  Created by dsailer on 4/10/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHHash.h"
#import "JHTweet.h"

@interface JHTwitterTopEmojiService : NSObject

- (NSArray<JHHash *> *_Nonnull)topEmojis;
- (void)resetStatistics;
- (void)addTweets:(NSArray *_Nonnull)tweets;
- (NSUInteger)tweetCount;
- (NSUInteger)totalTweetCount;

@end
