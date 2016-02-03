//
//  SearchResultsProvider.swift
//  YouTube
//
//  Created by Arturs Derkintis on 12/30/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let kYoutubeKey = "AIzaSyCa6PZpINllRHja2Pac31oYxSLbIqIF3JU"

class SearchResultsProvider: NSObject {
    
    func getSearchResults(string : String, pageToken : String?, completion:(nextPageToken : String?, items : [Item]) -> Void){
        
        let url = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(string)&key=\(kYoutubeKey)&type=video,channel"
        var params = Dictionary<String, AnyObject>()
        params["maxResults"] = 30
        if let pageToken = pageToken{
            params["pageToken"] = pageToken
        }
        
        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
        Alamofire.request(.GET, url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!, parameters : params).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
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
            case "youtube#channel":
                let channelId = object["snippet"]["channelId"].string
                let channel = Channel()
                channel.getChannelDetails(channelId!, completion: { (channelDetails) -> Void in
                    channel.channelDetails = channelDetails
                    item.channel = channel
                    completion (item: item)
                })
                break
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
    
    func getSearchSuggestions(string : String, completion : (strings : [String]) -> Void){
        let url = "https://suggestqueries.google.com/complete/search?client=youtube&ds=yt&client=firefox&q=\(string)"
        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
        Alamofire.request(.GET, url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if let array = json[1].array{
                        var stringArray = [String]()
                        for value in array where value.string != nil{
                            if stringArray.count < 6{
                                stringArray.append(value.string!)
                            }
                        }
                        completion(strings: stringArray)
                    }
                    
                }
            case .Failure(let error):
                print(error)
            }
            
        }
        
    }
    
}



enum ItemType{
    case Video
    case Channel
    case Unrecognized
    case None
    
    //more
}

public class Item : NSObject{
    var channel : Channel?{
        didSet{
            if channel != nil{
                self.type = .Channel
            }
        }
    }
    
    var video   : Video?{
        didSet{
            if video != nil{
                self.type = .Video
            }
        }
    }
    var type : ItemType = .None
}

class Channel : NSObject{
    var channelDetails : ChannelDetails?
    var subscribed : Bool?
    func getChannelDetails(id: String, completion : (channelDetails : ChannelDetails) -> Void){
        let url = "https://www.googleapis.com/youtube/v3/channels?id=\(id)&key=\(kYoutubeKey)&part=snippet,statistics"
        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
        Alamofire.request(.GET, url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if let array = json["items"].array{
                        for object in array{
                            if let channelD = parseChannel(object){
                                completion(channelDetails: channelD)
                                
                            }
                        }
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
}

class Video : NSObject{
    var videoDetails : VideoDetails?
    var channel : ChannelDetails?
    
    func getVideoDetails(id : String, completion : (videoDetails : VideoDetails) -> Void){
        let url = "https://www.googleapis.com/youtube/v3/videos?id=\(id)&key=\(kYoutubeKey)&part=snippet,contentDetails,statistics,status"
        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
        Alamofire.request(.GET, url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if let array = json["items"].array{
                        for object in array{
                            if let channelId = object["snippet"]["channelId"].string{
                                self.getChannelDetails(channelId, completion: { (channelDetails) -> Void in
                                    self.channel = channelDetails
                                })
                            }
                            if let videoDetails = parseVideo(object){
                                completion(videoDetails: videoDetails)
                            }
                        }
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    
    func getChannelDetails(id: String, completion : (channelDetails : ChannelDetails) -> Void){
        let url = "https://www.googleapis.com/youtube/v3/channels?id=\(id)&key=\(kYoutubeKey)&part=snippet,statistics"
        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
        Alamofire.request(.GET, url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if let array = json["items"].array{
                        for object in array{
                            if let channelD = parseChannel(object){
                                completion(channelDetails: channelD)
                                
                            }
                        }
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
       
}

