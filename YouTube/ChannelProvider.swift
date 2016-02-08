//
//  ChannelProvider.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/28/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChannelProvider: NSObject {
    func getVideosOfChannel(channelId: String, accessToken : String?, pageToken : String?, completion: (nextPageToken: String?, items : [Item]) -> Void){
        
        let url = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=\(channelId)&key=\(kYoutubeKey)&order=date&type=video"
        var params = Dictionary<String, AnyObject>()
        params["maxResults"] = 30
        if let pageToken = pageToken{
            params["pageToken"] = pageToken
        }
        if let token = accessToken{
            params["access_token"] = token
        }
        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
        Alamofire.request(.GET, url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!, parameters : params).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    //print("JSON: \(json)")
                    if let array = json["items"].array{
                        self.parseItems(array, completion: { (items) -> Void in
                            let nextpagetoken = json["nextPageToken"].string
                            completion(nextPageToken: nextpagetoken, items: items)
                        })
                        
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    func parseItems(objects : [JSON], completion : (items : [Item]) -> Void){
        var items = [Item]()
        for object in objects{
            let item = Item()
            items.append(item)
            
            self.parseItem(object, item: item, completion: { (item) -> Void in
                let amount = items.filter({ (item) -> Bool in
                    return item.type != .None
                })
                if amount.count == objects.count{
                    completion(items: items)
                }
                
            })
        }
    }
    
    func parseItem(object : JSON, item : Item, completion : (item : Item) -> Void){
        if let kind = object["id"]["kind"].string{
            switch kind{
            case "youtube#video":
                let videoId = object["id"]["videoId"].string
                let video = Video()
                video.getVideoDetails(videoId!, completion: { (videoDetails) -> Void in
                    video.videoDetails = videoDetails
                    item.video = video
                    completion(item: item)
                })
                break
            default:
                item.type = .Unrecognized
                break
            }
        }
    }
    
    
}
func haveISubscribedToChannel(id: String, token : String, completion : (Bool) -> Void){
    let url = "https://www.googleapis.com/youtube/v3/subscriptions?part=snippet&mine=true&access_token=\(token)&forChannelId=\(id)"
    let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
    Alamofire.request(.GET, url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!).validate().responseJSON { response in
        switch response.result {
        case .Success:
            if let value = response.result.value {
                let json = JSON(value)
                print(json)
                if let array = json["items"].array{
                    print(array.count == 0 ? "empty" : "full")
                    completion(array.count == 0 ? false : true)
                }
            }
        case .Failure(let error):
            print(error)
        }
    }
    
}
func getSubscritionId(channelId : String, token : String?, completion:(subscriptionId : String) -> Void){
    let url = "https://www.googleapis.com/youtube/v3/subscriptions?part=snippet&mine=true&access_token=\(token ?? "")&forChannelId=\(channelId)"
    
    let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
    Alamofire.request(.GET, url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!).validate().responseJSON { response in
        switch response.result {
        case .Success:
            if let value = response.result.value {
                let json = JSON(value)
                print(json)
                if let array = json["items"].array{
                    if let id = array[0]["id"].string{
                        completion(subscriptionId: id)
                    }
                }
            }
            break
            
        case .Failure(let error):
            print(error)
            break
            
        }
    }
    
    
}