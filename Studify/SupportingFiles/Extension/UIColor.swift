//
//  UIColor.swift
//  Studify
//
//  Created by 이창현 on 05/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgbValue: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    static let mainColor = UIColor(r:235,g:180,b:44)
}
