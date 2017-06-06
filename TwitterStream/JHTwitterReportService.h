//
//  JHTwitterReportService.h
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHHash.h"
#import "JHTweet.h"

@protocol TwitterReportServiceProtocol <NSObject>

- (void)twitterReportServiceDidUpdateData;

@end

@interface JHTwitterReportService : NSObject

- (void)addTweets:(NSArray *_Nonnull)tweets;

-(NSUInteger)totalTweetCount;

@property (nullable, nonatomic, weak) id <TwitterReportServiceProtocol> delegate;

- (id _Nonnull )initWithStartDate:(NSDate *_Nonnull)startDate;

-(NSUInteger)averageTweetsPerHour;
-(NSUInteger)averageTweetsPerMinute;
-(NSUInteger)averageTweetsPerSecond;

-(double)percentOfTweetsWithUrl;
-(double)percentOfTweetsWithPhoto;

- (NSArray<JHHash *> *_Nonnull)topHashTags;
- (NSArray<JHHash *> *_Nonnull)topDomains;

- (void)resetStatistics;

@end
