//
//  PeerSparkEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/2.
//

import UIKit
import RxSwift
import RxCocoa

class PeerSparkEngageCore: EngageCore {
    
    @IBOutlet weak var peerSparkTableLattice: UITableView!
    @IBOutlet weak var peerSparkCollecLattice: UICollectionView!
    
    let peerSparkCollecLatticeDatas = BehaviorRelay<[KampLiveModel]>(value: [])
    let peerSparkTableLatticeDatas = BehaviorRelay<[UniMateAIContent]>(value: [])
    
    var kampLiveMode:KampLiveModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let kpListItems = KampHelper.sharedHelper.peerSparkDatas.filter { uniMateAIContent in
            if let _  = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.kampUserBlock.title + uniMateAIContent.liverIdentifier) {
                return false
            }else{
                return true
            }
            
        }
        peerSparkTableLatticeDatas.accept(kpListItems)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bindToLattice()
        getClassMatesDatas()
        
        NotificationCenter.default.rx.notification(Notification.Name("peerSparkBlock")).subscribe {[weak self] _ in
            guard let self = self else {return}
            getClassMatesDatas(loading: false)
        }
        .disposed(by: kpRxDisposeBag)
        
    }
    
    private func bindToLattice(){
        peerSparkCollecLatticeDatas.bind(to: peerSparkCollecLattice.rx.items(cellIdentifier: "PeerSparkCollectionLatticeCell", cellType: PeerSparkCollectionLatticeCell.self)){ peerSparkCollectionLatticeCellIndex,peerSparkCollectionLatticeCellItem,peerSparkCollectionLatticeCell in
            peerSparkCollectionLatticeCell.liverImageLattice.image = UIImage(named: peerSparkCollectionLatticeCellItem.kampLiverIdentif)
            peerSparkCollectionLatticeCell.liverName.text = peerSparkCollectionLatticeCellItem.kampLiver
        }
        .disposed(by: kpRxDisposeBag)
        
        peerSparkCollecLattice.rx.itemSelected.subscribe { [weak self] selectKpIndexPath in
            guard let self = self else {return}
            self.kampLiveMode = self.peerSparkCollecLatticeDatas.value[selectKpIndexPath.row]
            self.performSegue(withIdentifier: "PeerSparkDetailEngageCore", sender: self)
        }
        .disposed(by: kpRxDisposeBag)
        
        peerSparkTableLatticeDatas.bind(to: peerSparkTableLattice.rx.items(cellIdentifier: "PeerSparkTableLatticeCell", cellType: PeerSparkTableLatticeCell.self)) { peerSparkTableLatticeCellIndex,peerSparkTableLatticeCellItem,peerSparkTableLatticeCell in
            peerSparkTableLatticeCell.liverImageLattice.image = UIImage(named: peerSparkTableLatticeCellItem.liverIdentifier)
            peerSparkTableLatticeCell.liverName.text = peerSparkTableLatticeCellItem.liverName
            peerSparkTableLatticeCell.peerSparkContent.text = peerSparkTableLatticeCellItem.UniMateAIContentInfo
        }
        .disposed(by: kpRxDisposeBag)
        
        peerSparkTableLattice.rx.itemSelected.subscribe { [weak self] indexPath in
            if let self = self {
                let contentItem = self.peerSparkTableLatticeDatas.value[indexPath.row]
                self.kampLiveMode = KampHelper.sharedHelper.kampLiveDats.first(where: {$0.kampLiverIdentif == contentItem.liverIdentifier})
                self.performSegue(withIdentifier: "PeerSparkDetailEngageCore", sender: self)
            }
        }
        .disposed(by: kpRxDisposeBag)
    }
    
    fileprivate func getClassMatesDatas(loading:Bool = true){
        
        DispatchQueue.global().async {
            var semaphore:DispatchSemaphore?
            var kampItems = KampHelper.sharedHelper.kampLiveDats
            if kampItems.count == 0 {
                semaphore = DispatchSemaphore(value: 0)
                KampHelper.sharedHelper.loadAllConfig {
                    kampItems = KampHelper.sharedHelper.kampLiveDats
                    semaphore!.signal()
                }
                semaphore!.wait()
            }
            
            if loading == true {
                kampItems = kampItems.shuffled()
            }
            
            kampItems.removeAll { liveItems in
                if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.kampUserBlock.title + liveItems.kampLiverIdentif) {
                    return true
                }else if liveItems.kampLiverIdentif == KampHelper.sharedHelper.kampLoginUser.value?.kampLiverIdentif{
                    return true
                }else{
                    return false
                }
            }
            
            DispatchQueue.main.async {
                self.peerSparkCollecLatticeDatas.accept(kampItems)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let kampSegIdentifier = segue.identifier
        if kampSegIdentifier?.isEmpty == false {
            
            if kampSegIdentifier == "PeerSparkDetailEngageCore" {
                let peerSparkDetailEngageCore = segue.destination as! PeerSparkDetailEngageCore
                peerSparkDetailEngageCore.kpLiveModel = self.kampLiveMode
            }
        }
    }
}
