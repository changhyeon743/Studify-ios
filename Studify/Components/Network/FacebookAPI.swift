//
//  FacebookAPI.swift
//  Studify-ios
//
//  Created by 이창현 on 05/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import FacebookCore
import FBSDKLoginKit
import SwiftyJSON

class FacebookAPI {
    func login(_ vc: ViewController, completion: @escaping (String,String,String)->Void) {
        let fbLogin : LoginManager = LoginManager()
        
        fbLogin.logIn(permissions: ["public_profile","email","user_friends"], from: vc) { (result, error) in
            if (error == nil) {
                vc.indicator.start()
                let result : LoginManagerLoginResult = result!
                if (result.isCancelled) { vc.indicator.stop(); return }
                if(result.grantedPermissions.contains("user_friends")) {
                    //API.facebook.getFBfriendData()
                }
                if(result.grantedPermissions.contains("public_profile")) {
                    API.shared.facebook.getUser(completion: { (json) in
                        let name = json["name"].stringValue
                        let facebookID = json["id"].stringValue
                        let profile = json["picture"]["data"]["url"].stringValue
                        completion(name,facebookID,profile)
                    })
                }
            }
        }
    }
    
    
    func getUser(completion: @escaping(JSON)->Void) {
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id,name,picture"])
                .start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //print("getUser: ",result.debugDescription)
                    //everything works print the user data
                    guard let data = result else {return}
                    completion(JSON(data))
                }
            })
        }
    }
    
    func getFriends(completion: @escaping(JSON)->Void) {
        GraphRequest(graphPath: "me/friends", parameters: ["fields": "id,name,picture"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                //everything works print the user data
                guard let data = result else {return}
                completion(JSON(data)["data"])
            }
        })
    }
}
