//
//  SubscriptionsProvider.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/24/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SubscriptionsProvider: NSObject {
    func getMySubscribedChannels(token : String, completion: (subscriptions : [Subscription]) -> Void){
        print("toke \(token)")
        var subscriptions = [Subscription]()
        let url = "https://www.googleapis.com/youtube/v3/subscriptions?part=snippet,contentDetails&mine=true&access_token=\(token)&maxResults=50"
        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
        Alamofire.request(.GET, url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    if let array = json["items"].array{
                        for object in array{
                            self.parseSubscription(object, completion: { (subscription) -> Void in
                                subscriptions.append(subscription)
                                if array.count == subscriptions.count{
                                    completion(subscriptions: subscriptions)
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
    
    func parseSubscription(object : JSON, completion:(subscription : Subscription) -> Void){
        
        if let title = object["snippet"]["title"].string,
            thumbnail = object["snippet"]["thumbnails"]["high"]["url"].string,
            totalItemCount = object["contentDetails"]["totalItemCount"].int,
            newItemCount = object["contentDetails"]["newItemCount"].int,
            channelId = object["snippet"]["resourceId"]["channelId"].string{
                completion(subscription: Subscription(title: title, totalItemCount: String(totalItemCount), newItemCount: String(newItemCount), thumbnail: thumbnail, channelId: channelId))
        }
        
        
        
    }

}

