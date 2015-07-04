//
//  What_to_watchTests.m
//  What to watchTests
//
//  Created by Artem Podustov on 2/14/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "WTWNetworkingService.h"

@interface What_to_watchTests : XCTestCase

@property (strong, nonatomic) WTWNetworkingService *service;

@end

@implementation What_to_watchTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.service = [WTWNetworkingService new];
}

- (void)tearDown {
    self.service = nil;
    
    [super tearDown];
}

- (void)testMovieListAPI {
    // This is an example of a functional test case.
    
    XCTestExpectation *exHTTP = [self expectationWithDescription:@"HTTP exeption"];
    
    [self.service mostPopularMoviesWithSuccessBlock:^(NSArray *items) {
        
        [exHTTP fulfill];
        
        XCTAssertTrue([items count] > 0);
        
    } andFailureBlock:^(NSError *error) {
        [exHTTP fulfill];
        
        XCTFail(@"some error occurred: %@", error);
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"timeout error: %@", error);
        }
    }];
}

@end
