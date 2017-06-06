//
//  JHTwitterReportServiceTest.m
//  TwitterStream
//
//  Created by dsailer on 4/11/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTwitterStreamBaseTest.h"

#import "JHTwitterReportService.h"
#import "JHTopListHandler.h"

@interface JHTwitterReportServiceTest : JHTwitterStreamBaseTest

@end

@implementation JHTwitterReportServiceTest

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testAddTWeetDelegateGetsCalled {

    JHTwitterReportService *reportService = [[JHTwitterReportService alloc] init];

    id mockDelegate = OCMProtocolMock(@protocol(TwitterReportServiceProtocol));
    reportService.delegate = mockDelegate;
    OCMExpect([mockDelegate twitterReportServiceDidUpdateData]);
    
    JHTweet *tweet = [[JHTweet alloc] init];
    
    [reportService addTweets:[NSArray arrayWithObject:tweet]];
    
    OCMVerify(mockDelegate);
}

- (void)testAddTWeetDelegateDoesNotGetCalled {
    
    JHTwitterReportService *reportService = [[JHTwitterReportService alloc] init];

    id mockDelegate = OCMProtocolMock(@protocol(TwitterReportServiceProtocol));
    //reportService.delegate = mockDelegate;
    OCMReject([mockDelegate twitterReportServiceDidUpdateData]);

    JHTweet *tweet = [[JHTweet alloc] init];
    
    [reportService addTweets:[NSArray arrayWithObject:tweet]];
    
    OCMVerify(mockDelegate);
}

- (void)testAddTWeetWithTopDomain {
    
    JHTwitterReportService *reportService = [[JHTwitterReportService alloc] init];
    
    id mockTopHandler = OCMClassMock([JHTopListHandler class]);
    OCMStub([mockTopHandler addItem:OCMOCK_ANY]);
    
    NSString *urlString = @"http://www.timely.net";
    JHTweet *tweet = [[JHTweet alloc] initWithUrls:nil text:@"Tweet" source:nil domainUrl:[NSURL URLWithString:urlString] media:nil hashTags:nil];
    
    [reportService addTweets:[NSArray arrayWithObject:tweet]];
    
    //JHTopListHandler
    OCMExpect([mockTopHandler addItem:OCMOCK_ANY]);
    
    OCMVerify(mockTopHandler);
}

- (void)testAddTWeetWithTopHashTag {
    
    JHTwitterReportService *reportService = [[JHTwitterReportService alloc] init];
    
    id mockTopHandler = OCMClassMock([JHTopListHandler class]);
    OCMStub([mockTopHandler addItem:OCMOCK_ANY]);
    
    JHTweetHashTag *hashTag = [[JHTweetHashTag alloc] initWithText:@"Go Warriors"];
    JHTweet *tweet = [[JHTweet alloc] initWithUrls:nil text:@"Tweet" source:nil domainUrl:nil media:nil hashTags:[NSArray arrayWithObject:hashTag]];
    
    [reportService addTweets:[NSArray arrayWithObject:tweet]];
    
    //JHTopListHandler
    OCMExpect([mockTopHandler addItem:OCMOCK_ANY]);
    
    OCMVerify(mockTopHandler);
}

- (void)testAddTWeetWithUrl {
    
    JHTwitterReportService *reportService = [[JHTwitterReportService alloc] init];

    JHTweet *tweet = [[JHTweet alloc] initWithUrls:[NSArray arrayWithObject:OCMOCK_ANY] text:@"Tweet" source:nil domainUrl:nil media:nil hashTags:nil];
    
    [reportService addTweets:[NSArray arrayWithObject:tweet]];
    
    XCTAssertEqual([reportService percentOfTweetsWithUrl], 1.0);
}

- (void)testAddTWeetWithPhoto {
    
    JHTwitterReportService *reportService = [[JHTwitterReportService alloc] init];

    JHTweetMedia *media = [[JHTweetMedia alloc] initWithType:@"photo" url:nil];
    JHTweet *tweet = [[JHTweet alloc] initWithUrls:nil text:@"Tweet" source:nil domainUrl:nil media:[NSArray arrayWithObject:media] hashTags:nil];
    [reportService addTweets:[NSArray arrayWithObject:tweet]];
    
    XCTAssertEqual([reportService percentOfTweetsWithPhoto], 1.0);
}

- (void)testTweetsPerSecond {

    id mockDate = OCMClassMock([NSDate class]);
    OCMStub([mockDate timeIntervalSinceNow]).andReturn(-1);
    
    JHTwitterReportService *reportService = [[JHTwitterReportService alloc] initWithStartDate:mockDate];

    JHTweet *tweet = [[JHTweet alloc] initWithUrls:nil text:@"Tweet" source:nil domainUrl:nil media:nil hashTags:nil];
    [reportService addTweets:[NSArray arrayWithObject:tweet]];
    
    XCTAssertEqual([reportService averageTweetsPerSecond], 1.0);
}

- (void)testTweetsPerMinute {
    
    id mockDate = OCMClassMock([NSDate class]);
    OCMStub([mockDate timeIntervalSinceNow]).andReturn(-1);
    
    JHTwitterReportService *reportService = [[JHTwitterReportService alloc] initWithStartDate:mockDate];
    
    JHTweet *tweet = [[JHTweet alloc] initWithUrls:nil text:@"Tweet" source:nil domainUrl:nil media:nil hashTags:nil];
    [reportService addTweets:[NSArray arrayWithObject:tweet]];
    
    XCTAssertEqual([reportService averageTweetsPerMinute], 60.0);
}


- (void)testTweetsPerHour {
    
    id mockDate = OCMClassMock([NSDate class]);
    OCMStub([mockDate timeIntervalSinceNow]).andReturn(-1);
    
    JHTwitterReportService *reportService = [[JHTwitterReportService alloc] initWithStartDate:mockDate];
    
    JHTweet *tweet = [[JHTweet alloc] initWithUrls:nil text:@"Tweet" source:nil domainUrl:nil media:nil hashTags:nil];
    [reportService addTweets:[NSArray arrayWithObject:tweet]];
    
    XCTAssertEqual([reportService averageTweetsPerHour], 3600.0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
