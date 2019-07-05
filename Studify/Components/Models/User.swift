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
                        token: json["token"].stringValue)
        
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
