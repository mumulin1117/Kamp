//
//  SkillShowroomEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/2.
//

import UIKit

class SkillShowroomEngageCore: EngageCore,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var showroomCollectionLattice: UICollectionView!
    
    @IBOutlet weak var nabigationKampHeight: NSLayoutConstraint!
    
    @IBOutlet weak var starBaseLattice: UIView!
    
    @IBOutlet weak var starKpQuantity: UILabel!
    
    var kpLiveModel:KampLiveModel?
    
    var isMyShowKpRoom = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isMyShowKpRoom {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }else{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if kpLiveModel == nil {
            KampHelper.sharedHelper.kampLoginUser
                .compactMap{$0}
                .subscribe { [weak self] kampLiveModel in
                    if let self = self {
                        self.kpLiveModel = kampLiveModel
                        self.showroomCollectionLattice.reloadData()
                    }
                }
                .disposed(by: kpRxDisposeBag)
            isMyShowKpRoom = true
        }else{
            nabigationKampHeight.constant = 0
        }
        
        configLattice()
        bingToLattice()
    }
    
    private func bingToLattice(){
        KampHelper.sharedHelper.kampLoginUser
            .compactMap{$0}
            .subscribe { KampLiveModel in
                self.starKpQuantity.text = "\(KampLiveModel.kampStar)"
            }
            .disposed(by: kpRxDisposeBag)
    }
    
    private func configLattice(){
        let showroomCollectionLatticeLayout = UICollectionViewFlowLayout()
        showroomCollectionLatticeLayout.minimumLineSpacing = 2
        showroomCollectionLatticeLayout.minimumInteritemSpacing = 2
        showroomCollectionLatticeLayout.sectionInset = UIEdgeInsets(top: 0, left: 3, bottom: 3, right: 3)
        showroomCollectionLatticeLayout.itemSize = CGSizeMake((UIScreen.main.bounds.size.width - 10)/3, (UIScreen.main.bounds.size.width - 10)/3)
        showroomCollectionLattice.setCollectionViewLayout(showroomCollectionLatticeLayout, animated: true)
        
        let starBaseLatticeTap = UITapGestureRecognizer(target: self, action: #selector(starBaseLatticeTapRalay))
        starBaseLattice.addGestureRecognizer(starBaseLatticeTap)
    }
    
    @objc private func starBaseLatticeTapRalay(){
        self.performSegue(withIdentifier: "KampChestEngageCore", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let showRoomCollectionLatticeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowRoomCollectionLatticeCell", for: indexPath) as! ShowRoomCollectionLatticeCell
        showRoomCollectionLatticeCell.kampImageLattice.image = UIImage(named: kpLiveModel!.timelinePictures[indexPath.row])
        return showRoomCollectionLatticeCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.kpLiveModel == nil ? 0 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section > 0 ? kpLiveModel!.timelinePictures.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            
            return CGSize(width: UIScreen.main.bounds.size.width, height: isMyShowKpRoom ? 654 - 414 : 654)
        }else{
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 431)
        }else{
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 0 {
                let showRoomInfoReusableLattice = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ShowRoomInfoReusableLattice", for: indexPath) as! ShowRoomInfoReusableLattice
                showRoomInfoReusableLattice.roomInfoCallBack = { [weak self] kpType in
                    guard let self = self else {return}
                    if kpType == 0 {
                        self.performSegue(withIdentifier: "KampLiveLinkEngageCore", sender: self)
                    }else{
                        self.performSegue(withIdentifier: "PeerSparkDetailEngageCore", sender: self)
                    }
                }
                showRoomInfoReusableLattice.kpLiveMode.accept(self.kpLiveModel)
                return showRoomInfoReusableLattice
            }
        }
        
        if kind == UICollectionView.elementKindSectionFooter {
            if indexPath.section == 0 {
                let showRoomLiveReusableLattice = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ShowRoomLiveReusableLattice", for: indexPath) as! ShowRoomLiveReusableLattice
                showRoomLiveReusableLattice.kpLiveMode.accept(self.kpLiveModel)
                showRoomLiveReusableLattice.clickLive = { [weak self] in
                    guard let self = self else {return}
                    self.performSegue(withIdentifier: "KampLivIngEngageCore", sender: self)
                }
                return showRoomLiveReusableLattice
            }
        }
        
        return UICollectionReusableView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let kampSegIdentifier = segue.identifier
        if kampSegIdentifier?.isEmpty == false {
            
            if kampSegIdentifier == "KampLivIngEngageCore" {
                let campLivIngEngageCore = segue.destination as! KampLivIngEngageCore
                campLivIngEngageCore.kampLiveModel.accept(self.kpLiveModel)
            }
            
            if kampSegIdentifier == "KampLiveLinkEngageCore" {
                let campLivIngEngageCore = segue.destination as! KampLiveLinkEngageCore
                campLivIngEngageCore.kpLiveModel = self.kpLiveModel
            }
            
            if kampSegIdentifier == "PeerSparkDetailEngageCore" {
                let campLivIngEngageCore = segue.destination as! PeerSparkDetailEngageCore
                campLivIngEngageCore.kpLiveModel = self.kpLiveModel
            }
            
        }
        
    }

}
