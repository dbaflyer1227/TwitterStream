//
//  JHTwitterReportService.m
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTwitterReportService.h"

#import "JHTweetMedia.h"
#import "JHTweetHashTag.h"
#import "NSString+Emoji.h"
#import "JHHash.h"
#import "JHTopListHandler.h"

@interface JHTwitterReportService()

@property NSUInteger tweetCount;
@property NSUInteger tweetsWithUrlCount;
@property NSUInteger tweetsWithPhotoCount;

@property (nonatomic,strong) NSDate *_Nonnull whenStarted;
@property (nonatomic, strong) JHTopListHandler *_Nonnull topHashTagHandler;
@property (nonatomic, strong) JHTopListHandler *_Nonnull topDomainHandler;

@property NSUInteger updatesDone;

@end


@implementation JHTwitterReportService

- (id) init {
    
    self = [super init];
    if (self) {
        
        [self resetStatistics];
    }
    return self;
}

- (id)initWithStartDate:(NSDate *)startDate {
    
    self = [super init];
    if (self) {
        
        [self resetStatistics];
        _whenStarted = startDate;
    }
    return self;
}

- (void)addTweets:(NSArray *)tweets {
 
    if (!tweets) {
        return;
    }
    
    for (JHTweet *tweet in tweets) {
        
        self.tweetCount++;
        
        if ([tweet.urls count]) {
            
            self.tweetsWithUrlCount++;
        }
        
        for (JHTweetMedia *media in tweet.media) {
            
            if ([@"photo" isEqualToString:media.type]) {
                
                self.tweetsWithPhotoCount++;
                break;
            }
        }
        
        for (JHTweetHashTag *hashTag in tweet.hashTags) {
            
            if (hashTag.text) {
                
                [self.topHashTagHandler addItem:hashTag.text];
            }
        }
        
        if ([tweet.domainUrl host]) {
            
            [self.topDomainHandler addItem:[tweet.domainUrl host]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(twitterReportServiceDidUpdateData)]) {
        
        [self.delegate twitterReportServiceDidUpdateData];
    }
}

-(NSUInteger)totalTweetCount {
    
    return self.tweetCount;
}

-(NSUInteger)averageTweetsPerHour {
    
    return [self averageTweetsPerMinute] * 60;
}

-(NSUInteger)averageTweetsPerMinute {
    
    return [self averageTweetsPerSecond] * 60;
}

-(NSUInteger)averageTweetsPerSecond {
    
    NSTimeInterval timeInterval = [self.whenStarted timeIntervalSinceNow];
    
    return self.tweetCount / (timeInterval * -1);
}

-(double)percentOfTweetsWithUrl {
    
    return (double)self.tweetsWithUrlCount / self.tweetCount;
}

-(double)percentOfTweetsWithPhoto {

    return (double)self.tweetsWithPhotoCount / self.tweetCount;
}

- (NSArray<JHHash *> *_Nonnull)topHashTags {
    
    return [self.topHashTagHandler topItems];
}

- (NSArray<JHHash *> *_Nonnull)topDomains {

    return [self.topDomainHandler topItems];
}


- (void)resetStatistics {
    
    _whenStarted = [NSDate date];
    _tweetCount = 0;
    _tweetsWithUrlCount = 0;
    _tweetsWithPhotoCount = 0;
    
    self.topHashTagHandler = [[JHTopListHandler alloc] init];
    self.topDomainHandler = [[JHTopListHandler alloc] init];
}


@end
