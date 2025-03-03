//
//  KampChestCollectionLatticeCell.swift
//  Kamp
//
//  Created by Kamp on 2024/12/5.
//

import UIKit

class KampChestCollectionLatticeCell: UICollectionViewCell {
    
    @IBOutlet weak var starKpQuantity: UIButton!
    @IBOutlet weak var starKpPrice: UILabel!
    @IBOutlet weak var starItemBackgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 72/255.0, green: 64/255.0, blue: 92/255.0, alpha: 1).cgColor
    }
}
