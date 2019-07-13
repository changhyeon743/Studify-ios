//
//  DateAPI.swift
//  Studify
//
//  Created by 이창현 on 10/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation

extension Double {
    func convertToDate () -> (Int, Int, Int) {
        let seconds = Int.init(self)
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func calculateDifference(time: Double) -> (Int, Int, Int) {
        return (floor(self - time)/1000).convertToDate()
    }
}

