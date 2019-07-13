//
//  AppDelegate.swift
//  Studify
//
//  Created by 이창현 on 05/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        FBSDKCoreKit.ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if let loggedInUsingFBTokenCheck = AccessToken.current{
            //User is already logged-in. Please do your additional code/task.
            print(loggedInUsingFBTokenCheck)
            API.shared.facebook.getUser(completion: { (json) in
                let name = json["name"].stringValue
                let facebookID = json["id"].stringValue
                let profile = json["picture"]["data"]["url"].stringValue
                API.shared.auth.register(name: name, facebookId: facebookID, profileURL: profile) { (json,err)  in
                    if (err == nil) {
                        print("currentUser json: ",json.debugDescription)
                        API.shared.currentUser = User.transform(fromJSON: json["userModel"])
                        print("currentUser: ",API.shared.currentUser.debugDescription)
                    }
                }
            })
            API.shared.facebook.getFriends(completion: { (json) in
                print("friends..")
                
                API.shared.currentFriends = User.transform(fromFB: json)
                print(API.shared.currentFriends)
                
            })
            if let window = self.window{
                window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
            }
            
        }else{
            //User is not logged-in. Allow the user for login using FB.
            
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId: String = FBSDKCoreKit.Settings.appID
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            
            return FBSDKCoreKit.ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

