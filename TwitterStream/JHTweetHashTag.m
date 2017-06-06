//
//  JHTweetHashTag.m
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTweetHashTag.h"

@interface JHTweetHashTag ()

@property (nonatomic, strong, readwrite) NSString *_Nullable text;

@end

@implementation JHTweetHashTag

- (id)initWithText:(NSString *)text {
    
    self = [super init];

    if (self) {

        _text = text;
    }
    
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"text": @"text",
             };
}

@end
