//
//  ShowRoomInfoReusableLattice.swift
//  Kamp
//
//  Created by Kamp on 2024/12/5.
//

import UIKit
import RxSwift
import RxCocoa

class ShowRoomInfoReusableLattice: UICollectionReusableView {
    let kpLiveMode = BehaviorRelay<KampLiveModel?>(value: nil)
    var rxDisposeBag = DisposeBag()
    
    @IBOutlet weak var liverImageLattice: UIImageView!
    @IBOutlet weak var liverFollowButton: UIButton!
    @IBOutlet weak var liverName: UILabel!
    @IBOutlet weak var liverKpInfo: UILabel!
    @IBOutlet weak var myKpFollow: UILabel!
    @IBOutlet weak var muKpFollowing: UILabel!  // fans
    @IBOutlet weak var infoKpTop: NSLayoutConstraint!
    @IBOutlet weak var liverBackGround: UIImageView!
    
    var roomInfoCallBack:((Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        kpLiveMode
            .compactMap ({$0})
            .subscribe {[weak self] kampLiveModel in
                guard let self = self else {return}
                self.liverImageLattice.image = UIImage(named: kampLiveModel.kampLiverIdentif)
                self.liverBackGround.image = UIImage(named: kampLiveModel.kampLiverIdentif)
                self.liverName.text = kampLiveModel.kampLiver
                self.liverKpInfo.text = kampLiveModel.liverInfo
                self.myKpFollow.text = "\(kampLiveModel.liverFollow)"
                self.muKpFollowing.text = "\(kampLiveModel.liverFollowIng)"
                
                if kampLiveModel.kampLiverIdentif == KampHelper.sharedHelper.kampLoginUser.value?.kampLiverIdentif {
                    self.liverFollowButton.isHidden = true
                    self.infoKpTop.constant = 15
                    self.liverBackGround.isHidden = true
                }else{
                    self.liverFollowButton.isHidden = true
                    self.liverBackGround.isHidden = false
                    if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.liverKpFollow.title + kampLiveModel.kampLiveId){
                        self.liverFollowButton.setBackgroundImage(nil, for: .normal)
                        self.liverFollowButton.setImage(nil, for: .normal)
                        self.liverFollowButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                        self.liverFollowButton.setTitle("  " + process("Fcotlblzowwbidnug") + "  ", for: .normal)
                        self.liverFollowButton.backgroundColor = UIColor(red: 0.43, green: 0.4, blue: 0.5, alpha: 1)
                        self.liverFollowButton.isSelected = true
                    }else{
                        self.liverFollowButton.setBackgroundImage(UIImage(named: "kampFollowBackground"), for: .normal)
                        self.liverFollowButton.setImage(UIImage(named: "KpMomentItemFollowIcon"), for: .normal)
                        self.liverFollowButton.setTitleColor(UIColor.white, for: .normal)
                        self.liverFollowButton.setTitle("  " + process("Fnodlglsopw"), for: .normal)
                        self.liverFollowButton.backgroundColor = UIColor.clear
                    }
                }
            }
            .disposed(by: rxDisposeBag)
        
    }
    
    @IBAction func showRoomCamerRelay(_ sender: UIButton) {
        roomInfoCallBack?(0)
    }
    
    @IBAction func showRoomPeerSpark(_ sender: UIButton) {
        roomInfoCallBack?(1)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rxDisposeBag = DisposeBag()
    }
}
