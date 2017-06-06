//
//  JHTweetMedia.h
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface JHTweetMedia : MTLModel <MTLJSONSerializing>

-(id _Nonnull )initWithType:(NSString *_Nullable)type url:(NSString *_Nullable)url;

@property (nonatomic, strong, readonly) NSString *_Nullable type;
@property (nonatomic, strong, readonly) NSString *_Nullable url;

@end
