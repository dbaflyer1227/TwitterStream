//
//  NSString+Emoji.h
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)

-(NSArray *_Nonnull)EmojisFromList:(NSArray *_Nonnull)emojiList;
-(NSArray *_Nonnull)Emojis;

@end
