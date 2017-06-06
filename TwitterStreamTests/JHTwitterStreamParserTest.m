//
//  JHTwitterStreamParserTest.m
//  TwitterStream
//
//  Created by dsailer on 5/12/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTwitterStreamBaseTest.h"
#import "JHTwitterStreamParser.h"
#import <Mantle/Mantle.h>
#import "JHTweet.h"

@interface JHTwitterStreamParserTest : JHTwitterStreamBaseTest

@end

@implementation JHTwitterStreamParserTest

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testDataNilNoCrash {
    
    JHTwitterStreamParser *parser = [[JHTwitterStreamParser alloc] initWithTweetData:nil];
    
    NSArray *tweets = [parser tweets];
    
    XCTAssertNotNil(tweets);
    XCTAssertEqual([tweets count], 0);
}

- (void)testSimulateJSONError {
    
    id mockJson = OCMClassMock([NSJSONSerialization class]);

    NSError *theError = [NSError errorWithDomain:@"TweetParser" code:999 userInfo:nil];
    
    NSString *jsonStub = @"This JSON will not parse";
    NSData *jsonData = [jsonStub dataUsingEncoding:NSUTF8StringEncoding];
    
    OCMStub([mockJson JSONObjectWithData:jsonData
                                 options:NSJSONReadingAllowFragments
                                   error:[OCMArg setTo:theError]]);
    
    id mockJSONAdapter = OCMClassMock([MTLJSONAdapter class]);
    
    JHTwitterStreamParser *parser = [[JHTwitterStreamParser alloc] initWithTweetData:jsonData];
    [parser tweets];
    
    OCMReject([mockJSONAdapter modelOfClass:nil fromJSONDictionary:nil error:nil]);
}

- (void)testSimulateActualFailure {

    NSString *jsonStub = @"This JSON will not parse";
    NSData *jsonData = [jsonStub dataUsingEncoding:NSUTF8StringEncoding];
    
    JHTwitterStreamParser *parser = [[JHTwitterStreamParser alloc] initWithTweetData:jsonData];
    NSArray *tweets = [parser tweets];
    
    XCTAssertNotNil(tweets);
    XCTAssertEqual([tweets count], 0);
}

- (void)testSimulateActualSuccess {
    
    NSData *jsonData = [self getTestTweet];
    
    JHTwitterStreamParser *parser = [[JHTwitterStreamParser alloc] initWithTweetData:jsonData];
    NSArray *tweets = [parser tweets];
    
    XCTAssertNotNil(tweets);
    XCTAssertEqual([tweets count], 1);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
