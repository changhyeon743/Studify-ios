//
//  API.swift
//  Studify-ios
//
//  Created by 이창현 on 05/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import Rasat


class API {
    static let shared = API()
    
    let baseURL = "http://13.125.252.104:3030"
    
    var auth = AuthAPI()
    var ranking = RankingAPI()
    var study = StudyAPI()
    var facebook = FacebookAPI()
    
    //static var date = DateAPI()
    
    
    var currentUser:User? = nil
    var currentFriends:[User] = []
    var currentFriendsIds: [String] {
        get {
            return currentFriends.map{$0.facebookId}
        }
    }
    
    //static var blackCoverView: BlackCover = BlackCover()
    let channel = Channel<Studying>()

    
}
