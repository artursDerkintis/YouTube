//
//  VideoPlayerController.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/5/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit

class VideoPlayerController: AVPlayerViewController{
    var operation : XCDYouTubeOperation?
    var qualities = [XCDYouTubeVideoQuality.Small240.rawValue, XCDYouTubeVideoQuality.Medium360.rawValue, XCDYouTubeVideoQuality.HD720.rawValue]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    var videoIndentifier : String = ""
    
    
    func setVideoID(id : String){
        if id == videoIndentifier{return}
        operation?.cancel()
        operation = XCDYouTubeClient.defaultClient().getVideoWithIdentifier(id, completionHandler: { (video, error) -> Void in
    
            if let video = video{
                for q in self.qualities{
                    let number = NSNumber(unsignedInteger: q)
                    if let streamURL = video.streamURLs[number]{
                        self.player = AVPlayer(URL: streamURL)
                    }
                    
                }
                
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
}
