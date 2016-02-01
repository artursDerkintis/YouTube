//
//  Models.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/20/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import Foundation
import SwiftyJSON

class VideoDetails{
    
    var id : String?
    var title : String?
    var thumbnail : String?
    var duration : String?
    
    var channelTitle : String?
    var channelId : String?
    
    var viewCount : String?
    var likeCount : String?
    var dislikeCount : String?
    var publishedAt : String?
    var videoDescription : String?
    
    lazy var shortViewCount : String = {
        if let viewCount = self.viewCount{
            return abbreviateNumber(NSNumber(integer: Int(viewCount)!)) as String
        }
        return ""
    }()
    lazy var shortLikesCount : String = {
        if let likeCount = self.likeCount{
            return abbreviateNumber(NSNumber(integer: Int(likeCount)!)) as String
        }
        return ""
    }()
    lazy var shortDislikesCount : String = {
        if let dislikeCount = self.dislikeCount{
            return abbreviateNumber(NSNumber(integer: Int(dislikeCount)!)) as String
        }
        return ""
    }()
    
    lazy var publishedAtFormated : String = {
        if let publishedAt = self.publishedAt{
            return DateFormatter.sharedInstance.simpleDate(publishedAt)
        }
        return ""
    }()
    
    lazy var durationFormated : String = {
        if let duration = self.duration{
            return parseDuration(duration)
        }
        return ""
    }()
    
}

func parseVideo(object : JSON) -> VideoDetails?{
    
    if let kind = object["kind"].string{
        switch kind{
        case "youtube#video":
            let channelTitle = object["snippet"]["channelTitle"].string
            let channelId = object["snippet"]["channelId"].string
            let videoId     = object["id"].string
            let thumbnail   = object["snippet"]["thumbnails"]["high"]["url"].string
            let videoTitle  = object["snippet"]["title"].string
            let publishedAt = object["snippet"]["publishedAt"].string
            
            let duration = object["contentDetails"]["duration"].string
            
            let views = object["statistics"]["viewCount"].string
            let likes = object["statistics"]["likeCount"].string
            let dislikes = object["statistics"]["dislikeCount"].string
            let description = object["snippet"]["description"].string
            
            let videoDetails = VideoDetails()
            videoDetails.id = videoId
            videoDetails.channelTitle = channelTitle
            videoDetails.channelId = channelId
            videoDetails.duration = duration
            videoDetails.dislikeCount = dislikes
            videoDetails.likeCount = likes
            videoDetails.publishedAt = publishedAt
            videoDetails.viewCount = views
            videoDetails.videoDescription = description
            videoDetails.thumbnail = thumbnail
            videoDetails.title = videoTitle
            
            return videoDetails
        default:
            break
        }
    }
    return nil
}

class ChannelDetails{
    var id : String?
    var title : String?
    var thumbnail : String?
    var subscriberCount : String?
    var publishedAt : String?
    
    lazy var publishedAtFormated : String = {
        if let publishedAt = self.publishedAt{
            return DateFormatter.sharedInstance.simpleDate(publishedAt)
        }
        return ""
    }()
    
    lazy var shortSubscriberCount : String = {
        if let subscriberCount = self.subscriberCount{
            return abbreviateNumber(NSNumber(integer: Int(subscriberCount)!)) as String
        }
        return ""
    }()
}

func parseChannel(object : JSON) -> ChannelDetails?{
    
    if let kind = object["kind"].string{
        switch kind{
        case "youtube#channel":
            
            let channelTitle = object["snippet"]["title"].string
            let channelId     = object["id"].string
            let thumbnail   = object["snippet"]["thumbnails"]["high"]["url"].string
            let publishedAt = object["snippet"]["publishedAt"].string
            
            let subscriberCount = object["statistics"]["subscriberCount"].string
            let channelDetails = ChannelDetails()
            channelDetails.id = channelId
            channelDetails.publishedAt = publishedAt
            channelDetails.subscriberCount = subscriberCount
            channelDetails.thumbnail = thumbnail
            channelDetails.title = channelTitle
            
            return channelDetails
        default:
            break
        }
    }
    return nil
}


class DateFormatter : NSObject {
    override init() {}
    static let sharedInstance = DateFormatter()
    let dateFormater = NSDateFormatter()
    let originalFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let simpleFormat   = "MMM d, yyyy"
    func simpleDate(string : String) -> String {
        dateFormater.dateFormat = originalFormat
        let date = dateFormater.dateFromString(string)
        dateFormater.dateFormat = simpleFormat
        let dateString = dateFormater.stringFromDate(date!)
        return dateString
    }
}
public func parseDuration(duration: String) -> String {
    
    var days = 0
    var hours = 0
    var minutes = 0
    var seconds = 0
    
    var decisionMaker = 0
    var factor = 1
    
    let specifiers: [Character] = ["M", "H", "T", "P"]
    
    let length = duration.characters.count
    
    for i in 1...length {
        
        let index = duration.startIndex.advancedBy(length - i)
        let char = duration[index]
        
        for specifier in specifiers {
            if char == specifier {
                decisionMaker++
                factor = 1
            }
        }
        
        if let value = Int(String(char)) {
            
            switch decisionMaker {
            case 0:
                seconds += value * factor
                factor *= 10
            case 1:
                minutes += value * factor
                factor *= 10
            case 2:
                hours += value * factor
                factor *= 10
            case 4:
                days += value * factor
                factor *= 10
            default:
                break
            }
        }
        
    }
    let strSeconds = seconds > 9 ? String(seconds) : "0" + String(seconds)
    if hours > 0{
        let strMinutes = minutes > 9 ? String(minutes) : "0" + String(minutes)
        return "\(hours):\(strMinutes):\(strSeconds)"
    }else{
        return "\(minutes):\(strSeconds)"
    }
}

class Subscription : NSObject{
    var title : String?
    var totalItemCount : String?
    var newItemCount : String?
    var thumbnail : String?
    var channelId : String?
    override init() {
        super.init()
    }
    required init(title : String, totalItemCount : String, newItemCount : String, thumbnail: String, channelId : String) {
        super.init()
        self.title = title
        self.totalItemCount = totalItemCount
        self.newItemCount = newItemCount
        self.thumbnail = thumbnail
        self.channelId = channelId
    }
}



public func abbreviateNumber(num: NSNumber) -> NSString {
    var ret: NSString = ""
    let abbrve: [String] = ["K", "M", "B"]
    
    let floatNum = num.floatValue
    
    if floatNum > 1000 {
        
        for i in 0..<abbrve.count {
            let size = pow(10.0, (Float(i) + 1.0) * 3.0)
            
            if (size <= floatNum) {
                let num = floatNum / size
                let str = floatToString(num)
                ret = NSString(format: "%@%@", str, abbrve[i])
            }
        }
    } else {
        ret = NSString(format: "%d", Int(floatNum))
    }
    
    return ret
}

func floatToString(val: Float) -> NSString {
    var ret = NSString(format: "%.1f", val)
    var c = ret.characterAtIndex(ret.length - 1)
    
    while c == 48 {
        ret = ret.substringToIndex(ret.length - 1)
        c = ret.characterAtIndex(ret.length - 1)
        
        
        if (c == 46) {
            ret = ret.substringToIndex(ret.length - 1)
        }
    }
    return ret
}