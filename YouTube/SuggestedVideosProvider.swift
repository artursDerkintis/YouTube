//
//  SuggestedVideosProvider.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/9/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SuggestedVideosProvider: NSObject {
    func getSuggestionsForID(id: String, completion :(videos : [Video]) -> Void){
        let url = "https://www.googleapis.com/youtube/v3/search?key=\(kYoutubeKey)&type=video&relatedToVideoId=\(id)&part=snippet"
        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
        var videoArray = [Video]()
        var params = Dictionary<String, AnyObject>()
        params["maxResults"] = 30
        Alamofire.request(.GET, url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!, parameters : params).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if let array = json["items"].array{
                        for object in array{
                            self.parseItem(object, completion: { (video) -> Void in
                                videoArray.append(video)
                                if array.last == object{
                                    completion(videos: videoArray)
                                }
                            })
                        }
                    }
                }
            case .Failure(let error):
                print(error)
            }
            
        }

        
    }
    
    
    func parseItem(object : JSON, completion : (video : Video) -> Void){
       
        if let kind = object["id"]["kind"].string{
            if kind == "youtube#video"{
                let videoId = object["id"]["videoId"].string
                let video = Video()
                video.getVideoDetails(videoId!, completion: { (videoDetails) -> Void in
                    video.videoDetails = videoDetails
                    completion(video: video)
                })
                
            }
        }
    }

}
