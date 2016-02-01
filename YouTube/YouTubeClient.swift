//
//  YouTubeClient.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/23/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit
import OAuthSwift



let clientId    = "1013698024374-dpak3l4sg2s4qpr4v4u4o7unnekftb1l.apps.googleusercontent.com"
let clientSecrect = "HXR4U5IFXbEMAE5UAqFKa6uq"
let callback    = "http://localhost:8080/youtubestarfly"
let response    = "code"
let scope       = "https://www.googleapis.com/auth/youtube"
let url         = "https://accounts.google.com/o/oauth2/auth"

class YouTubeClient: NSObject {
    static let sharedInstance = YouTubeClient()
    private override init() {}
    
    func loginWithCompletion(completion : (user : User) -> Void){
        let oauth = OAuth2Swift(consumerKey: clientId, consumerSecret:  clientSecrect, authorizeUrl: url, responseType: response)
        oauth.authorizeWithCallbackURL(NSURL(string: callback)!, scope: scope, state:  "name=value", success: { (credential, response, parameters) -> Void in
            print(credential.oauth_token)
            print(response)
            }) { (error) -> Void in
                print(error.localizedDescription)
        }
        
    }
}