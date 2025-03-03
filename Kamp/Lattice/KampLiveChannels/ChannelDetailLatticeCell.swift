//
//  ChannelDetailLatticeCell.swift
//  Kamp
//
//  Created by Kamp on 2024/12/3.
//

import UIKit

class ChannelDetailLatticeCell: UICollectionViewCell {
    
    @IBOutlet weak var kpLiveCover: UIImageView!
    @IBOutlet weak var liverImageLattice: UIImageView!
    @IBOutlet weak var liverName: UILabel!
    @IBOutlet weak var liveKpOnLine: UILabel!
    @IBOutlet weak var liveKpName: UILabel!
    @IBOutlet weak var onlineButton: UIButton!
    
    
    var kampLiveModel:KampLiveModel?{
        didSet{
            if let _kampLiveModel = kampLiveModel {
                if _kampLiveModel.kampLiveCover.count > 0 {
                    kpLiveCover.image = UIImage(named: _kampLiveModel.kampLiveCover)
                }
                liverImageLattice.image = UIImage(named: _kampLiveModel.kampLiverIdentif)
                liverName.text = _kampLiveModel.kampLiver
                liveKpOnLine.text = "\(_kampLiveModel.liveSeeCount)" + " online"
                liveKpName.text = _kampLiveModel.kampLiveTitle
                
                if _kampLiveModel.kampLiverIdentif == KampHelper.sharedHelper.kampLoginUser.value?.kampLiverIdentif {
                    onlineButton.isHidden = true
                }
            }
        }
    }
}
