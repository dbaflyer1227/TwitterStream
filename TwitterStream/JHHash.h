//
//  JHHash.h
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHHash : NSObject

@property (nonatomic, strong) NSString *_Nullable text;
@property (nonatomic, strong) NSNumber *_Nullable count;

- (NSString *_Nullable)getEmojiForDisplay;

@end
