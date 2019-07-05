//
//  API.swift
//  Studify-ios
//
//  Created by 이창현 on 05/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation

class API {
    static var baseURL = "http://13.125.252.104:3030"
    
    static var auth = AuthAPI()
    static var ranking = RankingAPI()
    static var study = StudyAPI()
    static var facebook = FacebookAPI()
    
    static var currentUser:User? = nil
}
