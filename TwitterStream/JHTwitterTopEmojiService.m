//
//  JHTwitterTopEmojiService.m
//  TwitterStream
//
//  Created by dsailer on 4/10/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTwitterTopEmojiService.h"
#import "JHTopListHandler.h"
#import "JHEmoji.h"
#import "NSString+Emoji.h"

@interface JHTwitterTopEmojiService ()

@property (nonatomic, strong) JHTopListHandler *_Nonnull topEmojiHandler;
@property NSUInteger tweetsWithEmojiCount;
@property NSUInteger totalTweets;

@end

@implementation JHTwitterTopEmojiService

- (id) init {
    
    self = [super init];
    if (self) {
        
        [self resetStatistics];
    }
    return self;
}

- (void)addTweets:(NSArray *)tweets {
    
    for (JHTweet * tweet in tweets) {
    
        self.totalTweets++;
        
        NSArray *emojis = [tweet.text Emojis];

        if ([emojis count] > 0) {
            self.tweetsWithEmojiCount++;
        }

        for (NSString *emoji in emojis) {
            
            [self.topEmojiHandler addItem:emoji];
        }
    }
}

- (NSArray<JHHash *> *_Nonnull)topEmojis {
    
    return [self.topEmojiHandler topItems];
}

- (NSUInteger)tweetCount {
    
    return  self.tweetsWithEmojiCount;
}

- (NSUInteger)totalTweetCount {
    
    return self.totalTweets;
}

- (void)resetStatistics {

    _tweetsWithEmojiCount = 0;
    _totalTweets = 0;
    self.topEmojiHandler = [[JHTopListHandler alloc] init];
}


@end
