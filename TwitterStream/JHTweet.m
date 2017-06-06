//
//  JHTweet.m
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTweet.h"

#import "JHTweetMedia.h"
#import "JHTweetUrl.h"
#import "JHTweetHashTag.h"

@interface JHTweet ()

@property (nonatomic, strong, readwrite) NSArray<JHTweetUrl *> *_Nullable urls;
@property (nonatomic, strong, readwrite) NSString *_Nullable text;
@property (nonatomic, strong, readwrite) NSString *_Nullable source;
@property (nonatomic, strong, readwrite) NSURL *_Nullable domainUrl;
@property (nonatomic, strong, readwrite) NSArray<JHTweetMedia *> *_Nullable media;
@property (nonatomic, strong, readwrite) NSArray<JHTweetHashTag *> *_Nullable hashTags;


@end

@implementation JHTweet

- (id)initWithUrls:(NSArray<JHTweetUrl *> *)urls text:(NSString *)text source:(NSString *)source domainUrl:(NSURL *)domainUrl media:(NSArray *)media hashTags:(NSArray<JHTweetHashTag *> *)hashTags {

    self = [super init];
    
    if (self) {
        
        _urls = urls;
        _text = text;
        _source = source;
        _domainUrl = domainUrl;
        _media = media;
        _hashTags = hashTags;
    }
    
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"text": @"text",
             @"source": @"source",
             @"urls": @"entities.urls",
             @"media": @"entities.media",
             @"hashTags": @"entities.hashtags",
             @"domainUrl": @"user.url"
             };
}

+ (NSValueTransformer *)urlsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:JHTweetUrl.class];
}

+ (NSValueTransformer *)mediaJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:JHTweetMedia.class];
}

+ (NSValueTransformer *)hashTagsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:JHTweetHashTag.class];
}

+ (NSValueTransformer *)domainUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
