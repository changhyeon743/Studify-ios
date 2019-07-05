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
class ViewController: UIViewController {
    
    var indicator: IndicatorView = IndicatorView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        indicator = IndicatorView(uiView: self.view)
        let button = UIButton(frame: CGRect(x: self.view.frame.size.width - 60, y: 60, width: 50, height: 50))
        button.backgroundColor = UIColor(r: 35, g: 88, b: 155)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("페이스북으로 로그인하기", for: .normal)
        view.addSubview(button)
    }
    
    
    @objc func login() {
        API.facebook.login(self) { (name, facebookId, profileURL) in
            //print("login: ",name,facebookId,profileURL)
            
            API.auth.register(name: name, facebookId: facebookId, profileURL: profileURL) { (json,err)  in
                self.indicator.stop()
                if (err == nil) {
                    print("currentUser json: ",json.debugDescription)
                    API.currentUser = User.transform(fromJSON: json["userModel"])
                    print("currentUser: ",API.currentUser.debugDescription)
                }
                
            }
        }
    }
    


}

