//
//  JHTopListHandler.m
//  TwitterStream
//
//  Created by dsailer on 4/9/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTopListHandler.h"
#import "JHHash.h"

@interface JHTopListHandler ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, JHHash *>*_Nonnull list;

@end

@implementation JHTopListHandler

- (id)init {
    
    self = [super init];
    if (self) {
        
        _list = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)addItem:(NSString *)text {
    
    if (!text) {
        return;
    }
    
    JHHash *hash = [self.list objectForKey:text];
    if (!hash) {
        hash = [[JHHash alloc] init];
        hash.text = [text copy];
        hash.count = [NSNumber numberWithInt:0];
    }
    
    int hashCount = [hash.count intValue];
    hashCount++;
    hash.count = [NSNumber numberWithInt:hashCount];
    
    [self.list setObject:hash forKey:text];
}

- (NSArray<JHHash *> *_Nonnull)topItems {
    
    //
    //  sort and return top limit
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self.count" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortedArray = [[self.list allValues] sortedArrayUsingDescriptors:sortDescriptors];
    
    NSUInteger keep = 0;
    NSMutableArray *topHash = [[NSMutableArray alloc] init];
    for (JHHash *hash in sortedArray) {
        
        if (keep < MAX_HASH_TAGS_TO_KEEP) {
            
            [topHash addObject:hash];
            keep++;
        }
        else {
            
            //  no reason to keep these around
            //
            [self.list removeObjectForKey:hash.text];
        }
    }
    
    return topHash;
}

@end
