//
//  KampLiveChannelLattice.swift
//  Kamp
//
//  Created by Kamp on 2024/12/2.
//

import UIKit

class KampLiveChannelLattice: UITableViewCell {
    
    @IBOutlet weak var kampLiveChannelLatticeBackgroundLattice: UIImageView!
    @IBOutlet weak var liveImageLattice: UIImageView!
    @IBOutlet weak var liveChannelName: UILabel!
    @IBOutlet weak var liveNowNumber: UILabel!
    
    
    var kampLiveModel:KampLiveModel?{
        didSet{
            if let _kampLiveModel = kampLiveModel {
                liveImageLattice.image = UIImage(named: _kampLiveModel.kampLiveCover)
                liveNowNumber.text = "\(_kampLiveModel.liveSeeCount)" + " live now"
                
                var tag = 200
                let kampTempNewArray =  KampHelper.sharedHelper.kampLiveDats.shuffled()
                for kampLiveItem in kampTempNewArray {
                    if kampLiveItem.kampLiverIdentif != _kampLiveModel.kampLiverIdentif {
                        if let liverImageLattice = self.viewWithTag(tag) as? UIImageView {
                            liverImageLattice.image = UIImage(named: kampLiveItem.kampLiverIdentif)
                            tag += 1
                            if tag > 203 {
                                break
                            }
                        }
                    }
                }
            }
        }
    }

}
