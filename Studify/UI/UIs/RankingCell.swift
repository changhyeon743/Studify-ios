//
//  RankingCell.swift
//  Studify
//
//  Created by 이창현 on 09/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit
import SDWebImage

class RankingCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: CircleImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var statusView: CircleView!
    
    @IBOutlet weak var timeLabelRightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDatas(profileURL: String, name: String, current: String, time: String, status: Bool) {
        profileImageView.sd_setImage(with: URL(string: profileURL), completed: nil)
        nameLabel.text = name
        timeLabel.text = current + " | " + time;
        if (status) {
            statusView.backgroundColor = UIColor.green
        } else {
            statusView.backgroundColor = UIColor.gray
        }
        
    }
    
    func setDatas(profileURL: String, name: String, time: String) {
        profileImageView.sd_setImage(with: URL(string: profileURL), completed: nil)
        nameLabel.text = name
        timeLabel.text = time;
        statusView.isHidden = true
        
    }
}

