//
//  CustomSegmentControl.swift
//  CustomSegmentControl
//
//  Created by abhinav khanduja on 01/09/18.
//  Copyright © 2018 abhinav khanduja. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSegmentControl: UIControl {
    
    var buttons = [UIButton]()
    
    var selector : UIView!
    
    var selectedSegmentIndex = 0
    
    var selectedSegmentTitle = ""
    
    @IBInspectable var selectorColor : UIColor = UIColor.darkGray {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var selectorTextColor : UIColor = UIColor.white {
        didSet{
            updateView()
        }
    }

    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var buttonTitles : String = "" {
        didSet{
            updateView()
        }
    }
    
    func updateView() {
        buttons.removeAll()
        subviews.forEach { (button) in
            button.removeFromSuperview()
        }
        
        let titles = buttonTitles.components(separatedBy: ",")
        
        for title in titles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            button.titleLabel?.textAlignment = .center
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        let selectorWidth = frame.width / CGFloat(titles.count)
        selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selector.layer.cornerRadius = frame.height/2
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillProportionally
        addSubview(sv)
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        sv.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sv.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        layer.cornerRadius = frame.height/2
    }
    
    @objc func buttonTapped(sender: UIButton) {
        for (buttonIndex,btn) in buttons.enumerated() {
            btn.setTitleColor(self.tintColor, for: .normal)
            if btn == sender {
                selectedSegmentTitle = (btn.titleLabel?.text)!
                selectedSegmentIndex = buttonIndex
                let selectorStartPos = frame.width/CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.2, animations: {
                    self.selector.frame.origin.x = selectorStartPos
                })
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        sendActions(for: .valueChanged)
    }

}

















