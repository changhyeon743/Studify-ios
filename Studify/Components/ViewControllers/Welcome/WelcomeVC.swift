//
//  ViewController.swift
//  Studify-ios
//
//  Created by 이창현 on 05/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore

class WelcomeVC: UIViewController {
    
    var indicator: IndicatorView = IndicatorView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        indicator = IndicatorView(uiView: self.view)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Login"
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        API.shared.facebook.login(self) { (name, facebookId, profileURL) in
            //print("login: ",name,facebookId,profileURL)
            
            API.shared.auth.register(name: name, facebookId: facebookId, profileURL: profileURL) { (json,err)  in
                self.indicator.stop()
                if (err == nil) {
                    print("currentUser json: ",json.debugDescription)
                    API.shared.currentUser = User.transform(fromJSON: json["userModel"])
                    print("currentUser: ",API.shared.currentUser.debugDescription)
                }
            }
            
            API.shared.facebook.getFriends(completion: { (json) in
                print("friends..")
                
                API.shared.currentFriends = User.transform(fromFB: json)
                print(API.shared.currentFriends)
                
                //UIWindow().window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
                
                self.present(UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController, animated: false, completion: nil)
            })
        }
    }
    


}

