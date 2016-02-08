//
//  User.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/23/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON

let currentUserKey = "currentUser"

class UserHandler: NSObject {
    private var timer = NSTimer()
    
    override private init(){
        super.init()
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: nil, usingBlock: { (not) -> Void in
            
            //Gets how much time left for accessToken and makes timer
            self.expired({ (expired, expiresIn) -> Void in
                if !expired, let expiresIn = expiresIn{
                    self.timer.invalidate()
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(expiresIn), target: self, selector: "updateToken", userInfo: nil, repeats: false)
                }else{
                    self.updateToken()
                }
            })

        })
        
        //Gets how much time left for accessToken and makes timer
        self.expired({ (expired, expiresIn) -> Void in
            if !expired, let expiresIn = expiresIn{
                self.timer.invalidate()
                self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(expiresIn), target: self, selector: "updateToken", userInfo: nil, repeats: false)
            }else{
                self.updateToken()
            }
        })

    }
    static let sharedInstance = UserHandler()
    var user : User? {
        get{
            if let archived = Defaults.objectForKey(currentUserKey) as? NSData{
                if let newUser = NSKeyedUnarchiver.unarchiveObjectWithData(archived) as? User{
                    return newUser
                }else{
                    return nil
                }
            }else{
                return nil
            }
        }
        set{
            if let object = newValue{
                let archivedObj = NSKeyedArchiver.archivedDataWithRootObject(object)
                Defaults.setObject(archivedObj, forKey: currentUserKey)
                
            }
        }
    }
    func expired(completion:(expired : Bool, expiresIn : Int?) -> Void){
        if let token = user?.token{
            let urlString = "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=\(token)"
            if let url = NSURL(string: urlString){
                NSURLSession.sharedSession().dataTaskWithURL(url) { (data, res, error) -> Void in
                    if let data = data{
                        let json = JSON(data: data)
                        if json["error"].string == "invalid_token" {
                            
                            //Expired
                            completion(expired: true, expiresIn: nil)
                        }else{
                            if let expiresIn = json["expires_in"].int{
                                //Hasn't expired
                                completion(expired: false, expiresIn: expiresIn)
                            }
                        }
                        print(json)
                        return
                    }
                    }.resume()
            }
        }else{
            
        }
    }
    
    func updateToken(){
        YouTubeClient.sharedInstance.login()
    }
}

class User : NSObject, NSCoding{
    var name : String?
    var email : String?
    var token : String?
    var imageURL : String?
    
    required init(coder aDecoder: NSCoder) {
        email = aDecoder.decodeObjectForKey("email") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        token = aDecoder.decodeObjectForKey("token") as? String
        imageURL = aDecoder.decodeObjectForKey("image") as? String
    }
    
    override init() {
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(email, forKey: "email")
        aCoder.encodeObject(token, forKey: "token")
        aCoder.encodeObject(imageURL, forKey: "image")
    }
    
    required init(email : String, name : String, token : String, imageURL : String) {
        super.init()
        self.name = name
        self.email = email
        self.token = token
        self.imageURL = imageURL
    }
}

