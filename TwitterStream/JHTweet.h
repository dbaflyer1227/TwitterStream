//
//  JHTweet.h
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "JHTweetUrl.h"
#import "JHTweetMedia.h"
#import "JHTweetHashTag.h"

@interface JHTweet : MTLModel <MTLJSONSerializing>

-(id _Nonnull )initWithUrls:(NSArray<JHTweetUrl *> *_Nullable)urls text:(NSString *_Nullable)text source:(NSString *_Nullable)source domainUrl:(NSURL *_Nullable)domainUrl media:(NSArray<JHTweetMedia*> *_Nullable)media hashTags:(NSArray<JHTweetHashTag *> *_Nullable)hashTags;

@property (nonatomic, strong, readonly) NSArray<JHTweetUrl *> *_Nullable urls;
@property (nonatomic, strong, readonly) NSString *_Nullable text;
@property (nonatomic, strong, readonly) NSString *_Nullable source;
@property (nonatomic, strong, readonly) NSURL *_Nullable domainUrl;
@property (nonatomic, strong, readonly) NSArray<JHTweetMedia *> *_Nullable media;
@property (nonatomic, strong, readonly) NSArray<JHTweetHashTag *> *_Nullable hashTags;

@end
