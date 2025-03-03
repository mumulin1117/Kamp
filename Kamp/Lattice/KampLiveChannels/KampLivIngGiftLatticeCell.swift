//
//  KampLivIngGiftLatticeCell.swift
//  Kamp
//
//  Created by Kamp on 2024/12/3.
//

import UIKit

class KampLivIngGiftLatticeCell: UICollectionViewCell {

    @IBOutlet weak var giftImageLattice: UIImageView!
    
    @IBOutlet weak var kampStarQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.init(red: 220/255.0, green: 104/255.0, blue: 85/255.0, alpha: 1).cgColor
    }

}
