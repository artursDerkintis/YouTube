//
//  RatingProvider.swift
//  YouTube
//
//  Created by Arturs Derkintis on 2/6/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RatingProvider: NSObject {
    
    static let sharedInstance = RatingProvider()
    required override init() {}
    
    func rateVideo(id : String, rating : Rating, accessToken : String?, completion:(Bool) -> Void){
        
        
        let url = "https://www.googleapis.com/youtube/v3/videos/rate?id=\(id)&rating=\(rating.rawValue)&key=\(kYoutubeKey)"
        
        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        let req = NSMutableURLRequest(URL: NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!)!)
        req.HTTPMethod = "POST"
        if let token = accessToken{
            req.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        NSURLSession.sharedSession().dataTaskWithRequest(req) { (data, response, error) -> Void in
            if let resp = response as? NSHTTPURLResponse{
                if resp.statusCode == 204{
                    print("DONE")
                    completion(true)
                }else{
                    let json = JSON(data: data!)
                    completion(false)
                    print(json)
                }
            }
            }.resume()
        
    }
    
    func getCurrentRating(id : String, accessToken : String?, completion:(rating : Rating) -> Void){
        let url = "https://www.googleapis.com/youtube/v3/videos/getRating?id=\(id)"
        
        let setCH = NSCharacterSet.URLQueryAllowedCharacterSet()
        
        let req = NSMutableURLRequest(URL: NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(setCH)!)!)
        req.HTTPMethod = "GET"
        if let token = accessToken{
            req.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        NSURLSession.sharedSession().dataTaskWithRequest(req) { (data, response, error) -> Void in
            
            if let data = data{
                let json = JSON(data: data)
                if let items = json["items"].array{
                    if let string = items[0]["rating"].string{
                        if let rating = Rating(rawValue: string){
                            completion(rating: rating)
                        }
                    }
                }
                print(json)
                
            }
            }.resume()
        
        
        
    }
    
    
}

enum Rating : String{
    case Like = "like"
    case Dislike = "dislike"
    case None = "none"
    case Unspecified = "unspecified"
    
}
