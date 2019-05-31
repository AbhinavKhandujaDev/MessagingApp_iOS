//
//  CustomChatsTableViewCell.swift
//  MessageApp
//
//  Created by abhinav khanduja on 13/09/18.
//  Copyright © 2018 abhinav khanduja. All rights reserved.
//

import UIKit

class CustomChatsTableViewCell: UITableViewCell {
    @IBOutlet weak var bubbleBgView: UIView!
    
    @IBOutlet weak var msgLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleBgView.layer.cornerRadius = 10
        bubbleBgView.layer.masksToBounds = true
    }
    
}
