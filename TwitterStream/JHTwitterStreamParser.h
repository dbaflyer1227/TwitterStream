//
//  JHTwitterStreamParser.h
//  TwitterStream
//
//  Created by dsailer on 4/10/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHTwitterStreamParser : NSObject

- (id _Nonnull )initWithTweetData:(NSData *_Nonnull)tweetData;

- (NSArray *_Nonnull)tweets;

@end
