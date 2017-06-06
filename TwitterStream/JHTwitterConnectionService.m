//
//  JHTwitterConnectionService.m
//  TwitterStream
//
//  Created by dsailer on 5/21/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTwitterConnectionService.h"
#import <Social/Social.h>

@interface JHTwitterConnectionService ()

@property (nonatomic, strong) AFHTTPSessionManager * _Nonnull sessionManager;
@property (nonatomic, strong) JHTwitterStreamParser * _Nonnull parser;
@property (nonatomic, strong) NSURLSessionDataTask * _Nonnull task;

@end

@implementation JHTwitterConnectionService


- (id)initWithSessionManager:(AFHTTPSessionManager *)sessionManager {
    
    self = [super init];
    
    if (self) {
        
        _sessionManager = sessionManager;
    }
    
    return self;
}

- (AFHTTPSessionManager *)sessionManager {
    
    if (!_sessionManager) {
        
        _sessionManager = [AFHTTPSessionManager manager];
    }
    
    return _sessionManager;
}

- (id _Nonnull)initWithParser:(JHTwitterStreamParser * _Nonnull)parser {
    
    self = [super init];
    
    if (self) {
        
        _parser = parser;
    }
    
    return self;
}


- (void)stopStreaming {
    
    [self.task cancel];
}

- (void)initStreamingConnectionForPattern:(NSString *)pattern withAccount:(ACAccount * _Nonnull)account {
    
   self.task = [self.sessionManager dataTaskWithRequest:[self getRequestForPattern:pattern withAccount:account] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
       
       
       if (error) {
           
           NSLog(@"error on connection %@",[error localizedDescription]);
           
           if ([self.delegate respondsToSelector:@selector(twitterServiceConnectionDidLooseConnection)]) {
               [self.delegate twitterServiceConnectionDidLooseConnection];
           }
       }
       
       {
           NSLog(@"Connection completed");
       }
       
    }];

    __weak typeof(self) weakSelf = self;
    
    [self.sessionManager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {

        
        [weakSelf processData:data];

        
    }];
    
    [self.task resume];
}

- (NSURLRequest *)getRequestForPattern:(NSString *)pattern withAccount:(ACAccount *)account {
    
    NSURL *url = [NSURL URLWithString:@"https://stream.twitter.com/1.1/statuses/filter.json"];
    NSDictionary *params = @{@"track" : pattern};
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodPOST
                                                      URL:url
                                               parameters:params];
    
    [request setAccount:account];
    
    return request.preparedURLRequest;
}

- (void)processData:(NSData *)data {
    
    if (data) {
        
        JHTwitterStreamParser *parser = nil;
        
        if (self.parser) {
            parser = self.parser;
        }
        else {
            parser = [[JHTwitterStreamParser alloc] initWithTweetData:data];
        }
        
        NSArray *tweets = [parser tweets];
        if ([tweets count] ) {
            
            if ([self.delegate respondsToSelector:@selector(twitterServiceConnectionDidReceiveTweets:)]) {
                [self.delegate twitterServiceConnectionDidReceiveTweets:tweets];
            }
        }
    }
}

@end
