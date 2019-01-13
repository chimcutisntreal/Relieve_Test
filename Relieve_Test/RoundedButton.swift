//
//  RoundedButton.swift
//  Relieve_Test
//
//  Created by Chinh on 12/3/18.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 1/UIScreen.main.nativeScale
        contentEdgeInsets = UIEdgeInsets(top: 3.5, left: 43, bottom: 3.5, right: 43)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.adjustsFontForContentSizeCategory = true
        backgroundColor = UIColor(red: 237/255, green: 239/255, blue: 242/255, alpha: 0.3)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.borderColor = UIColor(red: 237/255, green: 239/255, blue: 242/255, alpha: 0.3).cgColor
    }
}
