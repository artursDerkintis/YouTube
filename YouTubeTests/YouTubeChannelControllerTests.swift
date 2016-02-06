//
//  YouTubeChannelControllerTests.swift
//  YouTube
//
//  Created by Arturs Derkintis on 2/3/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import XCTest
@testable import YouTube

class YouTubeChannelControllerTests: XCTestCase {
    
    var channelsVC : ChannelsViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if channelsVC == nil{
            channelsVC = ChannelsViewController()
            
        }
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    
}
