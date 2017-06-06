//
//  JHTwitterServiceTest.m
//  TwitterStream
//
//  Created by dsailer on 5/14/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTwitterStreamBaseTest.h"
#import "JHTwitterService.h"
#import "JHTwitterStreamParser.h"

@interface JHTwitterService (TestingMethods)
- (NSURLRequest *)getRequestForPattern:(NSString *)pattern withAccount:(ACAccount *)account;
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error;
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data;
@end

@interface JHTwitterServiceTest : JHTwitterStreamBaseTest

@end

@implementation JHTwitterServiceTest

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testResumeIsCalled {

    id mockSession =  OCMClassMock([NSURLSession class]);
    id mockDataTask = OCMClassMock([NSURLSessionDataTask class]);
    
    OCMStub([mockSession dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://whocares.net"]]]).andReturn(mockDataTask);

    JHTwitterService *service = [[JHTwitterService alloc] initWithSessionManager:mockSession];
    id mockService = OCMPartialMock(service);
    OCMStub([mockService getRequestForPattern:@"at" withAccount:OCMOCK_ANY]);

    [service initStreamingConnectionForPattern:@"at" withAccount:OCMOCK_ANY];
    
    OCMExpect([mockDataTask resume]);
    
    OCMVerify(mockSession);
    OCMVerify(mockService);
}

- (void)testLostConnection {

    JHTwitterService *service = [[JHTwitterService alloc] initWithSessionManager:OCMOCK_ANY];

    id mockDelegate = OCMProtocolMock(@protocol(TwitterServiceProtocol));
    service.delegate = mockDelegate;
    OCMExpect([mockDelegate twitterServiceDidLooseConnection]);
    
    NSError *theError = [NSError errorWithDomain:@"TwitterService" code:999 userInfo:nil];
    [service URLSession:OCMOCK_ANY task:OCMOCK_ANY didCompleteWithError:theError];

    OCMVerify(mockDelegate);
}

- (void)testSuccessNoData {
    
    JHTwitterService *service = [[JHTwitterService alloc] initWithSessionManager:OCMOCK_ANY];
    
    id mockDelegate = OCMProtocolMock(@protocol(TwitterServiceProtocol));
    service.delegate = mockDelegate;
    OCMExpect([mockDelegate twitterServiceDidReceiveTweets:OCMOCK_ANY]);
    
    [service URLSession:OCMOCK_ANY dataTask:OCMOCK_ANY didReceiveData:nil];
    
    OCMReject(mockDelegate);
}


- (void)testSuccessData {

    id mockParser = OCMClassMock([JHTwitterStreamParser class]);
    OCMStub([mockParser tweets]).andReturn([NSArray arrayWithObject:OCMOCK_ANY]);

    JHTwitterService *service = [[JHTwitterService alloc] initWithParser:mockParser];
    
    id mockDelegate = OCMProtocolMock(@protocol(TwitterServiceProtocol));
    service.delegate = mockDelegate;
    OCMExpect([mockDelegate twitterServiceDidReceiveTweets:OCMOCK_ANY]);
    
    [service URLSession:OCMOCK_ANY dataTask:OCMOCK_ANY didReceiveData:OCMOCK_ANY];
    
    OCMReject(mockDelegate);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
