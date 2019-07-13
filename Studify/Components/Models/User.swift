//
//  User.swift
//  Studify
//
//  Created by 이창현 on 05/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//


import Foundation
import SwiftyJSON

struct User: Codable {
    var name: String
    var facebookId: String
    var profileURL: String
    var current: String
    var start_time: Double
    var end_time: Double
    var average_time: Double
    var max_time: Double
    var token: String
    var times: Int
}

extension User {
    static func transform(fromJSON json:JSON) -> User? {
        
        let user = User(name: json["name"].stringValue,
                        facebookId: json["facebookId"].stringValue,
                        profileURL: json["profileURL"].stringValue,
                        current: json["current"].stringValue,
                        start_time: json["start_time"].doubleValue,
                        end_time: json["end_time"].doubleValue,
                        average_time: json["average_time"].doubleValue,
                        max_time: json["max_time"].doubleValue,
                        token: json["token"].stringValue,
                        times: json["times"].intValue
                        )
        
        //print(user)
        return user
    }
    
    static func transform(fromFB temp:JSON) -> [User] {
        let json = temp.arrayValue
        let user = json.map{User(name: $0["name"].stringValue,
                                 facebookId: $0["id"].stringValue,
                                 profileURL: $0["picture"]["data"]["url"].stringValue,
                                 current: "",
                                 start_time: -1,
                                 end_time: -1,
                                 average_time: 0,
                                 max_time: 0,
                                 token: "",
                                 times: 0)}
        
        //print(user)
        return user
    }
    
    static func transform(fromRanks temp:JSON) -> [User] {
        let json = temp.arrayValue
        let user = json.map{User(name: $0["name"].stringValue,
                                 facebookId: $0["facebookId"].stringValue,
                                 profileURL: $0["profileURL"].stringValue,
                                 current: $0["current"].stringValue,
                                 start_time: $0["start_time"].doubleValue,
                                 end_time: $0["end_time"].doubleValue,
                                 average_time: $0["average_time"].doubleValue,
                                 max_time: $0["max_time"].doubleValue,
                                 token: $0["token"].stringValue,
                                 times: $0["times"].intValue)}
        
        //print(user)
        return user
    }
}




//{
//    "_id": "5d00f5fbe6b03d31a565d474",
//    "name": "삼창현",
//    "facebookId": "231",
//    "profileURL": "http://",
//    "current": "",
//    "start_time": -1,
//    "end_time": 1560344276408,
//    "average_time": 0,
//    "max_time": 20.901,
//    "token": "B18ceNyM97hR0bwDTrts0B9cWgzyZvIx",
//    "__v": 0
//},
