//
//  ChannelDetailEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/3.
//

import UIKit
import RxSwift
import RxCocoa

class ChannelDetailEngageCore: EngageCore {
    @IBOutlet weak var ChannelDetailCollection: UICollectionView!
    
    var kampLiveDatas = BehaviorRelay<[KampLiveModel]>(value: [])
    
    var kampClickItem:KampLiveModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLattice()
        bingTo()
        
        NotificationCenter.default.rx.notification(Notification.Name("liveBlocked")).subscribe {[weak self] _ in
            guard let self = self else {return}
            var kampLiveDatas = kampLiveDatas.value
            kampLiveDatas.removeAll { liveItems in
                if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.liveBlock.title + liveItems.kampLiveId) {
                    return true
                }else{
                    return false
                }
            }
            self.kampLiveDatas.accept(kampLiveDatas)
        }
        .disposed(by: kpRxDisposeBag)
    }
    
    
    private func bingTo(){
        kampLiveDatas.bind(to: ChannelDetailCollection.rx.items(cellIdentifier: "ChannelDetailLatticeCell", cellType: ChannelDetailLatticeCell.self)){ChannelDetailCollectionIndex,ChannelDetailCollectionItem,channelDetailLatticeCell in
            channelDetailLatticeCell.kampLiveModel = ChannelDetailCollectionItem
        }
        .disposed(by: kpRxDisposeBag)
        
        self.ChannelDetailCollection.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self else {return}
            self.kampClickItem = self.kampLiveDatas.value[indexPath.row]
            self.performSegue(withIdentifier: "KampLivIngEngageCore", sender: self)
        }
        .disposed(by: kpRxDisposeBag)
    }
    
    private func configLattice(){
        let ChannelDetailCollectionLayout = UICollectionViewFlowLayout()
        ChannelDetailCollectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        ChannelDetailCollectionLayout.minimumInteritemSpacing = 10
        ChannelDetailCollectionLayout.minimumLineSpacing = 8
        ChannelDetailCollectionLayout.itemSize = CGSizeMake((UIScreen.main.bounds.size.width - 30)/2, 300)
        
        ChannelDetailCollection.setCollectionViewLayout(ChannelDetailCollectionLayout, animated: true)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let kampSegIdentifier = segue.identifier
        if kampSegIdentifier?.isEmpty == false {
            
            if kampSegIdentifier == "KampLivIngEngageCore" {
                let campLivIngEngageCore = segue.destination as! KampLivIngEngageCore
                campLivIngEngageCore.kampLiveModel.accept(self.kampClickItem)
            }
        }
    }

}
