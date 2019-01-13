//
//  CustomCollectionViewCell.swift
//  Relieve_Test
//
//  Created by Chinh on 11/24/18.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var volSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        volSlider.setThumbImage(UIImage(named: "audio"), for: .normal)
        volSlider.setThumbImage(UIImage(named: "audio"), for: .highlighted)
        volSlider.isHidden = true
    }
}
