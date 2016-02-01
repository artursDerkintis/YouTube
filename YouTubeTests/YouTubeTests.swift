//
//  YouTubeTests.swift
//  YouTubeTests
//
//  Created by Arturs Derkintis on 12/31/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import XCTest
@testable import YouTube
class YouTubeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchQuery(){
        let expectation = self.expectationWithDescription("Wait")
        let provider = SearchResultsProvider()
        provider.getSuggestions("Swift")
        self.waitForExpectationsWithTimeout(1000, handler: nil)
        
    }
}
