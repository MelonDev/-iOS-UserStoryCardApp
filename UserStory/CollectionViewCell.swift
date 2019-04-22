//
//  CollectionViewCell.swift
//  UserStory
//
//  Created by Android on 22/4/2562 BE.
//  Copyright © 2562 MelonDev. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var viewSizeBg: UIView!
    @IBOutlet weak var sizeBg: UIView!
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var asALabel: UILabel!
    @IBOutlet weak var iwantLabel: UILabel!
    @IBOutlet weak var soLabel: UILabel!
    @IBOutlet weak var iknowLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBg.setStyleWithOutShadow(viewLayer: viewBg, cornerRadius: 10)
        
        viewSizeBg.layer.cornerRadius = 10
        viewSizeBg.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        viewContent.layer.cornerRadius = 10
        viewContent.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        sizeBg.setStyleWithOutShadow(viewLayer: viewBg, cornerRadius: 5)

        // Initialization code
    }

}
