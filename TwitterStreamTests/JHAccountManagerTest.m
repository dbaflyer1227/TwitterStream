//
//  JHAccountManagerTest.m
//  TwitterStream
//
//  Created by dsailer on 5/14/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTwitterStreamBaseTest.h"
#import "JHAccountManager.h"
#import <Social/Social.h>

@interface JHAccountManagerTest : JHTwitterStreamBaseTest

@end

@implementation JHAccountManagerTest

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {

    [super tearDown];
}

- (void)testAccessToTwitterAccountNotAvailable {
    
    JHAccountManager *manager = [[JHAccountManager alloc] init];
    
    id mockDelegate = OCMProtocolMock(@protocol(AccountManagerProtocol));
    manager.delegate = mockDelegate;
    OCMExpect([mockDelegate accountManagerAccountAccessNotAvailable]);
    
    id managerMock = OCMPartialMock(manager);
    OCMStub([managerMock userHasAccessToTwitter]).andReturn(NO);
    
    [manager requestAccessToTwitterAccount];
    
    OCMVerify(mockDelegate);
}

- (void)testAccessToTwitterAccountFailedWithError {

    NSError *theError = [NSError errorWithDomain:@"AccountManager" code:999 userInfo:nil];

    id mockAccountStore = OCMClassMock([ACAccountStore class]);
    JHAccountManager *manager = [[JHAccountManager alloc] initWithAccountStore:mockAccountStore];
    
    id mockDelegate = OCMProtocolMock(@protocol(AccountManagerProtocol));
    manager.delegate = mockDelegate;
    OCMExpect([mockDelegate accountManagerAccountAccessFailedWithError:[theError localizedDescription]]);
    
    id managerMock = OCMPartialMock(manager);
    OCMStub([managerMock userHasAccessToTwitter]).andReturn(YES);
    
    OCMExpect([mockAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter]);
    OCMStub([mockAccountStore requestAccessToAccountsWithType:OCMOCK_ANY options:nil completion:([OCMArg invokeBlockWithArgs:[NSNumber numberWithBool:NO], theError, nil])]);
    
    [manager requestAccessToTwitterAccount];
    
    OCMVerify(mockDelegate);
    OCMVerify(mockAccountStore);
}

- (void)testAccessToTwitterAccountNotGranted {

    id mockAccountStore = OCMClassMock([ACAccountStore class]);
    JHAccountManager *manager = [[JHAccountManager alloc] initWithAccountStore:mockAccountStore];
    
    id mockDelegate = OCMProtocolMock(@protocol(AccountManagerProtocol));
    manager.delegate = mockDelegate;
    OCMExpect([mockDelegate accountManagerAccountAccessNotGranted]);
    
    id managerMock = OCMPartialMock(manager);
    OCMStub([managerMock userHasAccessToTwitter]).andReturn(YES);
    
    OCMExpect([mockAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter]);
    OCMStub([mockAccountStore requestAccessToAccountsWithType:OCMOCK_ANY options:nil completion:([OCMArg invokeBlockWithArgs:[NSNumber numberWithBool:NO], [NSNull null], nil])]);
    
    [manager requestAccessToTwitterAccount];
    
    OCMVerify(mockDelegate);
    OCMVerify(mockAccountStore);
}

- (void)testAccessToTwitterAccountSuccess {
    
    id mockAccountStore = OCMClassMock([ACAccountStore class]);
    JHAccountManager *manager = [[JHAccountManager alloc] initWithAccountStore:mockAccountStore];
    
    id mockDelegate = OCMProtocolMock(@protocol(AccountManagerProtocol));
    manager.delegate = mockDelegate;
    OCMExpect([mockDelegate accountManagerAccountAccessAvailable]);
    
    id managerMock = OCMPartialMock(manager);
    OCMStub([managerMock userHasAccessToTwitter]).andReturn(YES);
    
    
    NSArray *twitterAccounts = [NSArray arrayWithObject:OCMOCK_ANY];
    OCMStub([mockAccountStore accountsWithAccountType:OCMOCK_ANY]).andReturn(twitterAccounts);
    
    OCMExpect([mockAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter]);
    OCMStub([mockAccountStore requestAccessToAccountsWithType:OCMOCK_ANY options:nil completion:([OCMArg invokeBlockWithArgs:[NSNumber numberWithBool:YES], [NSNull null], nil])]);
    
    [manager requestAccessToTwitterAccount];
    
    OCMVerify(mockDelegate);
    OCMVerify(mockAccountStore);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
