//
//  ShowRoomLiveReusableLattice.swift
//  Kamp
//
//  Created by Kamp on 2024/12/5.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class ShowRoomLiveReusableLattice: UICollectionReusableView ,UICollectionViewDelegate,UICollectionViewDataSource{
    let kpLiveMode = BehaviorRelay<KampLiveModel?>(value: nil)
    var rxDisposeBag = DisposeBag()
    @IBOutlet weak var liveCollectionLattice: UICollectionView!
    @IBOutlet weak var noKpDatasLattice: UILabel!
    @IBOutlet weak var mommentsKpLattice: UIView!
    
    var clickLive:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ChannelDetailCollectionLayout = UICollectionViewFlowLayout()
        ChannelDetailCollectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        ChannelDetailCollectionLayout.minimumInteritemSpacing = 10
        ChannelDetailCollectionLayout.itemSize = CGSizeMake(173, 300)
        ChannelDetailCollectionLayout.scrollDirection = .horizontal
        liveCollectionLattice.setCollectionViewLayout(ChannelDetailCollectionLayout, animated: true)
        liveCollectionLattice.delegate = self
        liveCollectionLattice.dataSource = self
        
        kpLiveMode.compactMap{$0}.subscribe {[weak self] kampLiveModel in
            guard let self = self else {return}
            self.noKpDatasLattice.isHidden = true
            if kampLiveModel.liverInfo == "-" {
                self.liveCollectionLattice.isHidden = true
                self.noKpDatasLattice.isHidden = false
                self.mommentsKpLattice.isHidden = true
            }else{
                self.liveCollectionLattice.reloadData()
            }
        }
        .disposed(by: rxDisposeBag)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rxDisposeBag = DisposeBag()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let channelDetailLatticeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelDetailLatticeCell", for: indexPath) as! ChannelDetailLatticeCell
        channelDetailLatticeCell.kampLiveModel = self.kpLiveMode.value
        channelDetailLatticeCell.layer.borderColor = UIColor(red: 0.73, green: 0.03, blue: 0.64, alpha: 1).cgColor
        if self.kpLiveMode.value?.kampLiverIdentif == KampHelper.sharedHelper.kampLoginUser.value?.kampLiverIdentif {
            channelDetailLatticeCell.layer.borderWidth = 0
        }else{
            channelDetailLatticeCell.layer.borderWidth = 1
        }
        return channelDetailLatticeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.kpLiveMode.value?.kampLiverIdentif == KampHelper.sharedHelper.kampLoginUser.value?.kampLiverIdentif {
            SVProgressHUD.showInfo(withStatus: process("Luijvmeg zbzruoaawdycjaesstj phkaesl oernadoerd"))
        }else{
            clickLive?()
        }
    }
}
