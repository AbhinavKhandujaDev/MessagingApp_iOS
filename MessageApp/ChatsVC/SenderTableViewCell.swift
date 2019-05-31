//
//  SenderTableViewCell.swift
//  MessageApp
//
//  Created by abhinav khanduja on 20/09/18.
//  Copyright © 2018 abhinav khanduja. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    @IBOutlet var senderBubbleBgView: UIView!
    
    @IBOutlet var senderBubbleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        senderBubbleBgView.layer.cornerRadius = 10
        senderBubbleBgView.layer.masksToBounds = true
    }


}
