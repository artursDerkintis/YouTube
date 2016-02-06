//
//  YouTubeQueries.swift
//  YouTube
//
//  Created by Arturs Derkintis on 2/2/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import XCTest
@testable import YouTube
class YouTubeQueriesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    let videoID = "BAaDZxT7Q-o"
    func testSearchQuery(){
        let expectation = self.expectationWithDescription("Wait")
        let searchProvider = SearchResultsProvider()
        searchProvider.getSearchResults("Swift", pageToken: nil) { (nextPageToken, items) -> Void in
            XCTAssertNotNil(nextPageToken)
            XCTAssertTrue(items.count > 0)//true if returned anything
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1000, handler: nil)
    }
    
    func testSuggestionQuery(){
        let expectation = self.expectationWithDescription("Wait")
        let suggestestions = SearchResultsProvider()
        suggestestions.getSearchSuggestions("Swift") { (strings) -> Void in
            XCTAssertTrue(strings.count > 0)//true if returned anything
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1000, handler: nil)
    }
    
    func testSuggestedVideos(){
        let expectation = self.expectationWithDescription("Wait")
        let suggestedVidProvider = SuggestedVideosProvider()
        suggestedVidProvider.getSuggestionsForID(videoID) { (videos) -> Void in
            XCTAssertTrue(videos.count > 0)//true if returned anything
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1000, handler: nil)
    }
    
    let video = Video()
    func testVideoDetails(){
        let expectation = self.expectationWithDescription("Wait")
        video.getVideoDetails(videoID) { (videoDetails) -> Void in
            XCTAssertTrue(videoDetails.id != nil)
            XCTAssertTrue(videoDetails.duration != nil)
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1000, handler: nil)
    }
    
    func textVideoChannelDetails(){
        let expectation = self.expectationWithDescription("Wait")
        video.getChannelDetails(videoID) { (channelDetails) -> Void in
            XCTAssertTrue(channelDetails.id != nil)
            XCTAssertTrue(channelDetails.subscriberCount != nil)
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1000, handler: nil)
    }
    

    
}
