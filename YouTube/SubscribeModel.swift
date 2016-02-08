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
        let url = "https://www.googleapis.com/youtube/v3/subscriptions?id=\(channelId)&key=\(kYoutubeKey)&part=snippet"
        
        //let snippet = "{\"snippet\": {    \"resourceId\": {    \"kind\": \"youtube#channel\",    \"channelId\": \"\(channelId)\""
        
        let httpBody : [String : AnyObject] = ["snippet" : ["resourceId" : ["kind" : "youtube#channel", "channelId" : channelId]]]

        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
        let req = NSMutableURLRequest(URL: NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!)!)
        req.HTTPMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = accessToken{
            req.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        if NSJSONSerialization.isValidJSONObject(httpBody){
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(httpBody, options: [])
                req.HTTPBody = data
            }catch _{
                
            }
        }
        NSURLSession.sharedSession().dataTaskWithRequest(req) { (data, response, error) -> Void in
            if let resp = response as? NSHTTPURLResponse{
                if resp.statusCode == 200{
                    onMainThread({ () -> () in
                        self.updateSubcriptionList()
                        completion(success: true)
                    })
                }
            }
        }.resume()

    }
    
    func updateSubcriptionList(){
        NSNotificationCenter.defaultCenter().postNotificationName(subUpdate, object: nil)
    }
    
    func unsubscribeToChannel(subscriptionId : String, accessToken : String?, completion: (success : Bool) -> Void){
        let url = "https://www.googleapis.com/youtube/v3/subscriptions?id=\(subscriptionId)&key=\(kYoutubeKey)"
       
        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
        let req = NSMutableURLRequest(URL: NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!)!)
        req.HTTPMethod = "DELETE"
        if let token = accessToken{
            req.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        NSURLSession.sharedSession().dataTaskWithRequest(req) { (data, response, error) -> Void in
            if let resp = response as? NSHTTPURLResponse{
                print(resp.statusCode)
                let json = JSON(data: data!)
                print(json)
                if resp.statusCode == 204{
                    onMainThread({ () -> () in
                        self.updateSubcriptionList()
                        print("success")
                        completion(success: true)
                    })
                }
            }
        }.resume()

    }
    
}
