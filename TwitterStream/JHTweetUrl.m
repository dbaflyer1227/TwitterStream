//
//  JHTweetUrl.m
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTweetUrl.h"

@interface JHTweetUrl ()

@property (nonatomic, strong, readwrite) NSString *_Nullable displayUrl;
@property (nonatomic, strong, readwrite) NSString *_Nullable url;

@end

@implementation JHTweetUrl

- (id)initWithDisplayUrl:(NSString *)displayUrl url:(NSString *)url {
    
    self = [super init];
    
    if (self) {
        
        _displayUrl = displayUrl;
        _url = url;
    }
    
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"url": @"url",
             @"displayUrl": @"display_url",
             };
}

@end
