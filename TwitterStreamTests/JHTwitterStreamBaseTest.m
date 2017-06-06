//
//  JHTwitterStreamBaseTest.m
//  TwitterStream
//
//  Created by dsailer on 4/11/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTwitterStreamBaseTest.h"

@implementation JHTwitterStreamBaseTest

- (NSData *)getTestTweet {

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:@"tweet" ofType:@"json"];
    return [NSData dataWithContentsOfFile:filePath];
}

@end
