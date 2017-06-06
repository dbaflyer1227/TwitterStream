//
//  JHTopListHandler.h
//  TwitterStream
//
//  Created by dsailer on 4/9/17.
//  Copyright © 2017 dsailer. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "JHHash.h"

#define MAX_HASH_TAGS_TO_KEEP 5

@interface JHTopListHandler : NSObject

- (void)addItem:(NSString *_Nonnull)text;

- (NSArray<JHHash *> *_Nonnull)topItems;

@end
