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
var currentUser : User!

class UserHandler: NSObject {
    
    override private init(){}
    static let sharedInstance = UserHandler()
    var user : User? {
        get{
            if let archived = Defaults.objectForKey(currentUserKey) as? NSData{
                if let newUser = NSKeyedUnarchiver.unarchiveObjectWithData(archived) as? User{
                    currentUser = newUser
                    loaded = true
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
                currentUser = object
                let archivedObj = NSKeyedArchiver.archivedDataWithRootObject(object)
                Defaults.setObject(archivedObj, forKey: currentUserKey)
                loaded = true
            }
        }
    }
    dynamic var loaded = false
    func expired(completion:(Bool) -> Void){
        if let token = user?.token{
            let urlString = "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=\(token)"
            if let url = NSURL(string: urlString){
                NSURLSession.sharedSession().dataTaskWithURL(url) { (data, res, error) -> Void in
                    if let data = data{
                        let json = JSON(data: data)
                        if json["error"].string == "invalid_token" {
                            
                            //Expired
                            completion(true)
                        }else{
                            
                            //Hasn't expired
                            completion(false)
                            
                            //Set up timer for fetching new access token when old one expires
                            if let expiresIn = json["expires_in"].string{
                                NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(expiresIn)!, target: self, selector: "updateToken", userInfo: nil, repeats: false)
                            }
                            
                        }
                        print(json)
                        return
                    }
                    error == nil ? completion(true) : completion(false)
                    }.resume()
            }
        }else{
            completion(true)
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

