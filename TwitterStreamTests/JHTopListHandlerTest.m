//
//  JHTopListHandlerTest.m
//  TwitterStream
//
//  Created by dsailer on 4/11/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTwitterStreamBaseTest.h"

#import "JHTopListHandler.h"
#import "JHHash.h"

@interface JHTopListHandlerTest : JHTwitterStreamBaseTest

@end

@implementation JHTopListHandlerTest

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testAddNilNoCrash {
    
    JHTopListHandler *topListHandler = [[JHTopListHandler alloc] init];
    [topListHandler addItem:nil];

    NSArray *items = [topListHandler topItems];
    
    XCTAssertNotNil(items);
    XCTAssertEqual([items count], 0);
}

- (void)testAddOneCountIsOne {
    
    JHTopListHandler *topListHandler = [[JHTopListHandler alloc] init];
    [topListHandler addItem:@"Test"];
    
    NSArray *items = [topListHandler topItems];
    
    XCTAssertNotNil(items);
    XCTAssertEqual([items count], 1);
    JHHash *hash = [items lastObject];
    XCTAssertEqual([hash.count intValue],1);
    
}

- (void)testMyTopItemComesFirst {
    
    JHTopListHandler *topListHandler = [[JHTopListHandler alloc] init];
    [topListHandler addItem:@"Test"];
    [topListHandler addItem:@"Test"];
    [topListHandler addItem:@"Test2"];
    
    NSArray *items = [topListHandler topItems];
    
    XCTAssertNotNil(items);
    XCTAssertEqual([items count], 2);
    JHHash *hash = [items firstObject];
    XCTAssertEqual([hash.count intValue],2);
    XCTAssertEqual(hash.text, @"Test");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
