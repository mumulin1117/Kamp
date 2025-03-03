//
//  MomentCollectionLattice.swift
//  Kamp
//
//  Created by Kamp on 2024/12/3.
//

import UIKit

class MomentCollectionLatticeCell: UICollectionViewCell {
    
    @IBOutlet weak var timelineImageLattice: UIImageView!
    @IBOutlet weak var timelinerImageLattice: UIImageView!
    @IBOutlet weak var timelinerLattice: UILabel!
    @IBOutlet weak var kpFollowBbutton: UIButton!
    @IBOutlet weak var timelineContent: UILabel!
    @IBOutlet weak var timelineKpLike: UIButton!
    
    var reportButtonCallBack:(()->())?
    
    var kampModel:KampLiveModel?{
        didSet{
            if let kampModel = kampModel {
                timelineImageLattice.image = UIImage(named: kampModel.timelinePictures.first!)
                timelinerImageLattice.image = UIImage(named: kampModel.kampLiverIdentif)
                timelinerLattice.text = kampModel.kampLiver
                if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.liverKpFollow.title + kampModel.kampLiveId){
                    kpFollowBbutton.setBackgroundImage(nil, for: .normal)
                    kpFollowBbutton.setImage(nil, for: .normal)
                    kpFollowBbutton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                    kpFollowBbutton.setTitle("  " + process("Fcotlblzowwbidnug") + "  ", for: .normal)
                    kpFollowBbutton.backgroundColor = UIColor(red: 0.43, green: 0.4, blue: 0.5, alpha: 1)
                    kpFollowBbutton.isSelected = true
                }else{
                    kpFollowBbutton.setBackgroundImage(UIImage(named: "kampFollowBackground"), for: .normal)
                    kpFollowBbutton.setImage(UIImage(named: "KpMomentItemFollowIcon"), for: .normal)
                    kpFollowBbutton.setTitleColor(UIColor.white, for: .normal)
                    kpFollowBbutton.setTitle("  " + process("Fnodlglsopw"), for: .normal)
                    kpFollowBbutton.backgroundColor = UIColor.clear
                }
                
                if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.timeLineLike.title + kampModel.timelineId){
                    timelineKpLike.isSelected = true
                }else{
                    timelineKpLike.isSelected = false
                }
                
                timelineContent.text = kampModel.timelineInfo
            }
        }
    }
    
    @IBAction func reportButtonRelay(_ sender: UIButton) {
        reportButtonCallBack?()
    }
    
    @IBAction func kampCollectLiving(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if let kampPageModel = kampModel {
            if sender.isSelected == true {
                KampHelper.sharedHelper.currentMMKV?.set(kampPageModel.kampLiveId, forKey: LiveOperation.liverKpFollow.title + kampPageModel.kampLiveId)
            }else{
                KampHelper.sharedHelper.currentMMKV?.removeValue(forKey: LiveOperation.liverKpFollow.title + kampPageModel.kampLiveId)
            }
            
            kampModel = kampPageModel
//            NotificationCenter.default.post(name: NSNotification.Name("timeLineListUpdate"), object: nil)
        }
    }
    
    @IBAction func kampLivingLike(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if let kampPageModel = kampModel {
            if sender.isSelected == true {
                KampHelper.sharedHelper.currentMMKV?.set(kampPageModel.kampLiveId, forKey: LiveOperation.timeLineLike.title + kampPageModel.timelineId)
                kampPageModel.liveLikeCount += 1
            }else{
                KampHelper.sharedHelper.currentMMKV?.removeValue(forKey: LiveOperation.timeLineLike.title + kampPageModel.timelineId)
                kampPageModel.liveLikeCount -= 1
            }
            
            
        }
    }
}
