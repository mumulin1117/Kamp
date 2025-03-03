//
//  KampChestEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/5.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class KampChestEngageCore: EngageCore {

    @IBOutlet weak var kampChestCollectionLattice: UICollectionView!
    @IBOutlet weak var starKpTip: UILabel!
    @IBOutlet weak var starKpQuantity: UILabel!
    @IBOutlet weak var opeartionKpTip: UILabel!
    
    var kampChestCollectionLatticeIndex:Int?
     
    let kampChestCollectionLatticeDatas = BehaviorRelay<[StarItem]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configLattice()
        bindToLattice()
    }
    
    private func configLattice(){
        let liveCollectionKpSpace = 16.0
        let liveCollectionKpItemWidth = 80.0
        let liveCollectionLatticeLayout = UICollectionViewFlowLayout()
        liveCollectionLatticeLayout.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        if liveCollectionKpSpace > 0 {
            liveCollectionLatticeLayout.minimumInteritemSpacing = liveCollectionKpSpace
            liveCollectionLatticeLayout.minimumLineSpacing = liveCollectionKpSpace
            liveCollectionLatticeLayout.itemSize = CGSizeMake((UIScreen.main.bounds.size.width - 76)/3, liveCollectionKpItemWidth)
        }
        
        if liveCollectionKpItemWidth < 100 {
            kampChestCollectionLattice.setCollectionViewLayout(liveCollectionLatticeLayout, animated: true)
        }
        
        starKpTip.text = process("Myyi zGxodlgdq-eCeofikn")
        opeartionKpTip.text = process("Rwebclhfaurpgye")
        
        KampHelper.sharedHelper.getStarConfig()
        
    }
    
    private func bindToLattice(){
        kampChestCollectionLatticeDatas.bind(to: kampChestCollectionLattice.rx.items(cellIdentifier: "KampChestCollectionLatticeCell", cellType: KampChestCollectionLatticeCell.self)){ [weak self] kampChestCollectionLatticeIndex,kampChestCollectionLatticeItem,kampChestCollectionLatticeCell in
            if let self = self {
                kampChestCollectionLatticeCell.starKpPrice.text = kampChestCollectionLatticeItem.starKpName
                kampChestCollectionLatticeCell.starKpQuantity.setTitle(kampChestCollectionLatticeItem.starKpQuantity, for: .normal)
                if self.kampChestCollectionLatticeIndex == nil {
                    kampChestCollectionLatticeCell.starItemBackgroundImage.isHidden = true
                }else{
                    kampChestCollectionLatticeCell.starItemBackgroundImage.isHidden = kampChestCollectionLatticeIndex != self.kampChestCollectionLatticeIndex
                }
            }
            
        }
        .disposed(by: kpRxDisposeBag)
        
        kampChestCollectionLattice.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if let self = self {
                self.kampChestCollectionLatticeIndex = indexPath.row
                self.kampChestCollectionLattice.reloadData()
            }
        }).disposed(by: kpRxDisposeBag)
        
        KampHelper.sharedHelper.starConfigDatas.subscribe { [weak self] starConfigDatas in
            if let self = self {
                self.kampChestCollectionLatticeDatas.accept(starConfigDatas)
            }
        }
        .disposed(by: kpRxDisposeBag)
        
        KampHelper.sharedHelper.kampLoginUser
            .compactMap{$0}
            .subscribe { KampLiveModel in
                self.starKpQuantity.text = "\(KampLiveModel.kampStar)"
            }
            .disposed(by: kpRxDisposeBag)
    }
    
    @IBAction func kampConfirmRelay(_ sender: Any) {
        if let kampSelectIndex = self.kampChestCollectionLatticeIndex {
            let kampSelectData = self.kampChestCollectionLatticeDatas.value
            let kampSelectStarItem = kampSelectData[kampSelectIndex]
            TalentHive.shared.peerKpSyncCallBack = {(kpError,peerSyncTransActionKpId,kampIdeas) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    
                    if kampIdeas?.count ?? 0 > 0 {
                        if let loginLiveModel = KampHelper.sharedHelper.kampLoginUser.value {
                            if peerSyncTransActionKpId?.count ?? 0 > 0 {
                                TalentHive.shared.peerKpSyncFinish()
                                loginLiveModel.kampStar += Int(kampSelectStarItem.starKpQuantity)!
                                KampHelper.sharedHelper.kampLoginUser.accept(loginLiveModel)
                            }
                        }
                    }else{
                        SVProgressHUD.showInfo(withStatus: kpError?.localizedDescription)
                    }
                }
            }
            SVProgressHUD.show()
            TalentHive.shared.connectWithGlobalCohortOfStudents(peerIdentifier: kampSelectStarItem.starKpIdentifuer)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
