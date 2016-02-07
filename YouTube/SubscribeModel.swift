//
//  SubscribeModel.swift
//  YouTube
//
//  Created by Arturs Derkintis on 2/4/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SubscribeModel: NSObject {
    
    static let sharedInstance = SubscribeModel()
    required override init(){}
    
    func subscibeToChannel(channelId : String, accessToken : String?, completion: (success : Bool) -> Void){
        let url = "https://www.googleapis.com/youtube/v3/subscriptions&key=\(kYoutubeKey)&access_token=\(accessToken!)"
        var params = Dictionary<String, AnyObject>()
        
        let snippet : [String : AnyObject] = ["resourceId" : ["kind" : "youtube#channel", "channelId" : channelId]]
        params["snippet"] = snippet
        
        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()

    }
    
    func updateSubcriptionList(){
        NSNotificationCenter.defaultCenter().postNotificationName(subUpdate, object: nil)
    }
    
    func unsubscribeToChannel(subscriptionId : String, accessToken : String?, completion: (success : Bool) -> Void){
        let url = "https://www.googleapis.com/youtube/v3/subscriptions&key=\(kYoutubeKey)"
        var params = Dictionary<String, AnyObject>()
        params["id"] = subscriptionId
        if let token = accessToken{
            params["access_token"] = token
        }
        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
        Alamofire.request(.DELETE, url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!, parameters : params).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    self.updateSubcriptionList()
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
}
