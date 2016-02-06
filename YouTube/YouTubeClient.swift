//
//  YouTubeClient.swift
//  YouTube
//
//  Created by Arturs Derkintis on 1/23/16.
//  Copyright © 2016 Starfly. All rights reserved.
//

import UIKit

class YouTubeClient: NSObject, GIDSignInDelegate, GIDSignInUIDelegate  {
    static let sharedInstance = YouTubeClient()
    private override init() {}
    
    func login(){
        UserHandler.sharedInstance.expired { (expired) -> Void in
            if expired{
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    //Have expired - request new one
                    GIDSignIn.sharedInstance().delegate = self
                    GIDSignIn.sharedInstance().uiDelegate = self
                    GIDSignIn.sharedInstance().scopes = ["https://www.googleapis.com/auth/youtubepartner",
                        "https://www.googleapis.com/auth/youtube", "https://www.googleapis.com/auth/youtube.force-ssl"]
                    GIDSignIn.sharedInstance().signIn()
                }
            }else{
                //Havent expired
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    UserHandler.sharedInstance.loaded = true
                }
            }
        }
    }
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let token = user.authentication.accessToken // Safe to send to the server
            let name = user.profile.name
            let email = user.profile.email
            let imageURL = user.profile.imageURLWithDimension(100).absoluteString
            UserHandler.sharedInstance.user = User(email: email, name: name, token: token, imageURL: imageURL)
            
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
        
    }
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        UIApplication.sharedApplication().delegate?.window??.rootViewController?.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        UIApplication.sharedApplication().delegate?.window??.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
    }

}