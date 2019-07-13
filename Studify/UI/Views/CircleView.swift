//
//  CircleView.swift
//  Studify
//
//  Created by 이창현 on 09/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import UIKit

class CircleView: UIView{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}

class CircleImageView: UIImageView{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}
