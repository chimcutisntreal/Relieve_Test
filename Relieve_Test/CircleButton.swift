//
//  CircleButton.swift
//  Relieve_Test
//
//  Created by Chinh on 12/3/18.
//

import UIKit

class CircleButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        titleLabel?.adjustsFontForContentSizeCategory = true
        backgroundColor = UIColor(red: 237/255, green: 239/255, blue: 242/255, alpha: 0.3)
//        self.translatesAutoresizingMaskIntoConstraints = true
        self.layer.cornerRadius = self.frame.width/2
        layer.borderColor = UIColor(red: 237/255, green: 239/255, blue: 242/255, alpha: 0.3).cgColor
    }
}
