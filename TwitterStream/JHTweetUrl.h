//
//  JHTweetUrl.h
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface JHTweetUrl : MTLModel <MTLJSONSerializing>

-(id _Nonnull )initWithDisplayUrl:(NSString *_Nullable)displayUrl url:(NSString *_Nullable)url;

@property (nonatomic, strong, readonly) NSString *_Nullable displayUrl;
@property (nonatomic, strong, readonly) NSString *_Nullable url;

@end
