//
//  JHHash.m
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHHash.h"

@implementation JHHash

- (NSString *)getEmojiForDisplay {

    unichar utf8char = [self.text intValue];
    
    NSString *hexChar = [NSString stringWithFormat:@"0x%02x",utf8char];
    
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:hexChar];
    [scanner scanHexInt:&outVal];
    
    return [[NSString alloc] initWithBytes:&outVal length:sizeof(outVal) encoding:NSUTF32LittleEndianStringEncoding];
}

@end
