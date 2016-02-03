//
//  AppDelegate.swift
//  YouTube
//
//  Created by Arturs Derkintis on 12/29/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import UIKit
import AVFoundation
import OAuthSwift
@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    var window: UIWindow?
    let dateFormater = NSDateFormatter()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
     

        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print("Audio session setCategory failed")
        }
        UserHandler.sharedInstance.expired { (expired) -> Void in
            if expired{
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    var configureError: NSError?
                    GGLContext.sharedInstance().configureWithError(&configureError)
                    assert(configureError == nil, "Error configuring Google services: \(configureError)")
                    
                    GIDSignIn.sharedInstance().delegate = self
                    GIDSignIn.sharedInstance().uiDelegate = self
                    GIDSignIn.sharedInstance().scopes = ["https://www.googleapis.com/auth/youtube"]
                    GIDSignIn.sharedInstance().signIn()
                }
            }else{
                //Havent expired
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    UserHandler.sharedInstance.loaded = true
                }
            }
        }
        
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        let app = options[UIApplicationOpenURLOptionsSourceApplicationKey]
        let ann = options[UIApplicationOpenURLOptionsAnnotationKey]
        return GIDSignIn.sharedInstance().handleURL(url,
            sourceApplication: app as! String,
            annotation: ann )
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let options: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,
            UIApplicationOpenURLOptionsAnnotationKey: annotation]
        return self.application(application,
            openURL: url,
            options: options)
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
        self.window?.rootViewController?.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
    }
}

