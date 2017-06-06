//
//  JHEmoji.m
//  TwitterStream
//
//  Created by dsailer on 4/9/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHEmoji.h"

@interface JHEmoji ()

@property (nonatomic, strong, readwrite) NSString *_Nullable name;
@property (nonatomic, strong, readwrite) NSString *_Nullable unified;

@end

@implementation JHEmoji

- (id)initWithName:(NSString *)name unified:(NSString *)unified {
    
    self = [super init];
    
    if (self) {
        
        _name = name;
        _unified = unified;
    }
    
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"unified": @"unified"
             };
}

@end
