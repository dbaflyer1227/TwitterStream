//
//  JHTwitterStreamParser.m
//  TwitterStream
//
//  Created by dsailer on 4/10/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTwitterStreamParser.h"
#import "JHTweet.h"

@interface JHTwitterStreamParser ()

@property (nonatomic, strong) NSData *_Nonnull tweetData;

@end

@implementation JHTwitterStreamParser

- (instancetype)initWithTweetData:(NSData *_Nonnull)tweetData {
    
    self = [super init];
    
    if (self) {
        
        _tweetData = tweetData;
    }
    return self;
}

- (NSArray *)tweets {
    
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    
    if (!_tweetData ) {
        return tweets;
    }
    
    @autoreleasepool {

        NSString *rawTweets = [[NSString alloc] initWithData:self.tweetData encoding:NSUTF8StringEncoding];
        
        NSArray *rawTweetList=[rawTweets componentsSeparatedByString:@"\r\n"];
        
       // NSLog(@"raw tweet count %lu",(unsigned long)[rawTweetList count]);

        for (NSString *tmp in rawTweetList) {
            
            // NSLog(@"%@",tmp);
            
            NSError *error = nil;
            NSDictionary *tweetDict = [NSJSONSerialization JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
            if (!error) {
                NSError *tweetError = nil;
                JHTweet *tweet = [MTLJSONAdapter modelOfClass:JHTweet.class fromJSONDictionary:tweetDict error:&tweetError];
                
                if (tweet && !tweetError) {
                    [tweets addObject:tweet];
                }
            }
        }
    }
    
    return tweets;
}

@end
