//
//  RankingAPI.swift
//  Studify-ios
//
//  Created by 이창현 on 05/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RankingAPI {
    func friends( ids:[String], completion:@escaping (JSON, Error?)->Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "ids" : ids.joined(separator: ",")
        ]
        
        Alamofire.request( "\(API.shared.baseURL)/user/friend/ranking", method:.post, parameters:parameters, encoding:URLEncoding.httpBody, headers:headers )
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
    
    func wide( completion:@escaping (JSON, Error?)->Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "": ""
        ]
        Alamofire.request( "\(API.shared.baseURL)/user/ranking", method:.post, parameters:nil, encoding:URLEncoding.httpBody, headers:headers )
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
