//
//  JHEmoji.h
//  TwitterStream
//
//  Created by dsailer on 4/9/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface JHEmoji : MTLModel <MTLJSONSerializing>

-(id _Nonnull )initWithName:(NSString *_Nonnull)name unified:(NSString * _Nonnull)unified;

@property (nonatomic, strong, readonly) NSString *_Nullable name;
@property (nonatomic, strong, readonly) NSString *_Nullable unified;

@end
