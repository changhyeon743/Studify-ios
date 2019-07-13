//
//  StudyAPI.swift
//  Studify-ios
//
//  Created by 이창현 on 05/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Studying {
    case start
    case end(amount: Double)
}


class StudyAPI {
    var isStudying: Bool = false {
        didSet {
            //print(API.isStudying)
            if (isStudying != oldValue) {
                guard let user = API.shared.currentUser else { print("non logined"); return}
                //print(API.isStudying)
                
                
                if (isStudying) { //시작했을 경우
                    
                    API.shared.study.start(token: user.token, current: user.current) { (json, err) in
                        //공부를 얼마만에 시작했는지
                        API.shared.channel.broadcast(.start)
                        print("json,", json["amount"].doubleValue)
                    }
                } else {
                    API.shared.study.end(token: user.token) { (json, err) in
                        //공부한 양
                        API.shared.channel.broadcast(.end(amount: json["amount"].doubleValue))

                        print("json,", json["amount"].doubleValue)
                    }
                }
            }
        }
    }
    
    
    func start( token:String, current: String, completion:@escaping (JSON, Error?)->Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "token" : token,
            "current": current
        ]
        
        Alamofire.request( "\(API.shared.baseURL)/user/start", method:.post, parameters:parameters, encoding:URLEncoding.httpBody, headers:headers )
            .responseJSON(completionHandler: { (response) in
                //1. JSON 변환
                //print("result: ", response.debugDescription)
                
                guard let value = response.result.value else {return}
                if (response.result.isSuccess){
                    completion(JSON(value), nil)
                } else if (response.result.isFailure) {
                    completion(JSON(value),response.result.error)
                }
            })
    }
    func end( token:String, completion:@escaping (JSON, Error?)->Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "token" : token
        ]
        
        Alamofire.request( "\(API.shared.baseURL)/user/end", method:.post, parameters:parameters, encoding:URLEncoding.httpBody, headers:headers )
            .responseJSON(completionHandler: { (response) in
                //1. JSON 변환
                //print("result: ", response.debugDescription)
                
                guard let value = response.result.value else {return}
                if (response.result.isSuccess){
                    completion(JSON(value), nil)
                } else if (response.result.isFailure) {
                    completion(JSON(value),response.result.error)
                }
            })
    }
    
    func record( token:String, completion:@escaping (JSON, Error?)->Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "token" : token
        ]
        
        Alamofire.request( "\(API.shared.baseURL)/user/record", method:.post, parameters:parameters, encoding:URLEncoding.httpBody, headers:headers )
            .responseJSON(completionHandler: { (response) in
                //1. JSON 변환
                //print("result: ", response.debugDescription)
                
                guard let value = response.result.value else {return}
                if (response.result.isSuccess){
                    completion(JSON(value), nil)
                } else if (response.result.isFailure) {
                    completion(JSON(value),response.result.error)
                }
            })
    }
}
