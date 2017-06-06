//
//  JHTweetMedia.m
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTweetMedia.h"

@interface JHTweetMedia()

@property (nonatomic, strong, readwrite) NSString *_Nullable type;
@property (nonatomic, strong, readwrite) NSString *_Nullable url;

@end

@implementation JHTweetMedia

-(id _Nonnull )initWithType:(NSString *_Nullable)type url:(NSString *_Nullable)url {
 
    self = [super init];
    
    if (self) {
        
        _type = type;
        _url = url;
    }
    
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"type": @"type",
             @"url": @"url"
             };
}

@end
