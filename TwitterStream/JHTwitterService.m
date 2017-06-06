//
//  JHTwitterService.m
//  TwitterStream
//
//  Created by dsailer on 4/8/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTwitterService.h"

#import <Social/Social.h>

@interface JHTwitterService() <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSessionDataTask * _Nonnull task;
@property (nonatomic, strong) NSURLSession * _Nonnull sessionManager;
@property (nonatomic, strong) JHTwitterStreamParser * _Nonnull parser;

@end

@implementation JHTwitterService

- (id _Nonnull)initWithSessionManager:(NSURLSession * _Nonnull)sessionManager {
    
    self = [super init];
    
    if (self) {
        
        _sessionManager = sessionManager;
    }
    
    return self;
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

- (NSURLSession *)sessionManager {
    
    if (!_sessionManager) {
        _sessionManager =  [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration delegate:self delegateQueue:nil];
    }
    return _sessionManager;
}

- (void)initStreamingConnectionForPattern:(NSString *)pattern withAccount:(ACAccount * _Nonnull)account {
    
    self.task =  [self.sessionManager dataTaskWithRequest:[self getRequestForPattern:pattern withAccount:account]];

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

#pragma mark - NSURLSession delegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {

    NSLog(@"Connection failed: %@", [error localizedDescription]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(twitterServiceDidLooseConnection)]) {
            [self.delegate twitterServiceDidLooseConnection];
        }
    });
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {

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
            
            if ([self.delegate respondsToSelector:@selector(twitterServiceDidReceiveTweets:)]) {
                [self.delegate twitterServiceDidReceiveTweets:tweets];
            }
        }
    }
}

@end
