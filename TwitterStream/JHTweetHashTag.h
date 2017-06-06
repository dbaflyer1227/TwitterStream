//
//  JHTweetHashTag.h
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface JHTweetHashTag : MTLModel <MTLJSONSerializing>

-(id _Nonnull )initWithText:(NSString *_Nullable)text;

@property (nonatomic, strong, readonly) NSString *_Nullable text;

@end
