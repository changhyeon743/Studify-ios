//
//  Study.swift
//  Studify
//
//  Created by 이창현 on 13/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
 "date": "20190713",
 "amount": 6.259,
 "userToken": "lg8vJ2Ax7sOmFJl3OElZo5ZO00zUDtit",
 "token": "ywefkQ3AAJqJAw7FI8OHVRTcvqRzHmut",
 */

struct Study: Codable {
    var date: String
    var amount: Double
    var userToken: String
    var token: String
}

extension Study {
    
    static func transform(fromFB temp:JSON) -> [Study] {
        let json = temp.arrayValue
        let study = json.map{Study(date: $0["date"].stringValue,
                                   amount: $0["amount"].doubleValue,
                                   userToken: $0["userToken"].stringValue,
                                   token: $0["token"].stringValue)}
        
        //print(user)
        return study
    }
}

