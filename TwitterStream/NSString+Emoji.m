//
//  NSString+Emoji.m
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "NSString+Emoji.h"

@implementation NSString (Emoji)

- (NSArray *)EmojisFromList:(NSArray *)emojiList {
    
    NSMutableArray *list = [[NSMutableArray alloc] init];

    for (int i=0; i<[self length]; i++) {

        unichar letter = [self characterAtIndex:i];
        
        if (letter >= 9728 && letter <= 9983) {
            
            [list addObject:[NSNumber numberWithInt:letter]];
        }
    }
    
    return list;
}

- (NSArray *)Emojis {
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        if (substring && [[substring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
            
            NSRange r = [substring rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet]];
            NSRange r2 = [substring rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]];
            NSRange r3 = [substring rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
            
            if (r.location == NSNotFound && r2.location == NSNotFound && r3.location == NSNotFound) {
                //NSLog(@"%@",substring);
                [list addObject:substring];
            }
        }
        
    }];
    
    return list;
}

@end
