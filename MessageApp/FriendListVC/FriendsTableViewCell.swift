//
//  FriendsTableViewCell.swift
//  MessageApp
//
//  Created by abhinav khanduja on 14/09/18.
//  Copyright © 2018 abhinav khanduja. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lastChatMessage: UILabel!
    @IBOutlet weak var frndEmail: UILabel!
    
    @IBOutlet var cellBlurView: UIVisualEffectView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBlurView.layer.cornerRadius = 21
        cellBlurView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
