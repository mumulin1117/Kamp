//
//  KampLivIngGiftLattice.swift
//  Kamp
//
//  Created by Kamp on 2024/12/3.
//

import UIKit
import RxSwift
import RxCocoa

class KampLivIngGiftLattice: UIView {

    @IBOutlet weak var giftCollectionLattice: UICollectionView!
    var giftCollectionLatticeDatas = BehaviorRelay<[Int]>(value: [80,120,50,200,300,150,400,909])
    @IBOutlet weak var kampStarQuantity: UILabel!
    
    var kampLivePageModel:KampLiveModel?
    
    let kpRxDisposeBag = DisposeBag()
    
    var backTouchIdx:((Int,Int)->())?
    
    var selectGifIndex:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 24
        self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.layer.masksToBounds = true
        
        giftCollectionLattice.register(UINib(nibName: "KampLivIngGiftLatticeCell", bundle: nil), forCellWithReuseIdentifier: "KampLivIngGiftLatticeCell")
        
        let giftCollectionLatticeLayout = UICollectionViewFlowLayout()
        giftCollectionLatticeLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        giftCollectionLatticeLayout.minimumInteritemSpacing = 0
        giftCollectionLatticeLayout.minimumLineSpacing = 20
        giftCollectionLatticeLayout.itemSize = CGSizeMake(UIScreen.main.bounds.size.width/4, 114)
        giftCollectionLattice.setCollectionViewLayout(giftCollectionLatticeLayout, animated: true)
        
        bindToLattice()
        
    }
    @IBAction func liverSendGift(_ sender: UIButton) {
        
        if let kampLivePageModel = kampLivePageModel {
            if let selectGifIndex = selectGifIndex ,kampLivePageModel.kampStar > giftCollectionLatticeDatas.value[selectGifIndex] {
                kampLivePageModel.kampStar -= giftCollectionLatticeDatas.value[selectGifIndex]
                KampHelper.sharedHelper.kampLoginUser.accept(kampLivePageModel)
                self.backTouchIdx?(1,selectGifIndex)
            }else {
                self.backTouchIdx?(2,0)
            }
        }
    }
    
    private func bindToLattice(){
        giftCollectionLatticeDatas.bind(to: giftCollectionLattice.rx.items(cellIdentifier: "KampLivIngGiftLatticeCell", cellType: KampLivIngGiftLatticeCell.self)){ [weak self] kampLivIngGiftLatticeCellIndex,KampLivIngGiftLatticeCellItem,kampLivIngGiftLatticeCell in
            
            guard let self = self else {return}
            kampLivIngGiftLatticeCell.giftImageLattice.image = UIImage(named: "giftItem" + "\(kampLivIngGiftLatticeCellIndex)")
            kampLivIngGiftLatticeCell.kampStarQuantity.text = "\(KampLivIngGiftLatticeCellItem)"
            
            if let selectGifIndex = self.selectGifIndex, kampLivIngGiftLatticeCellIndex == selectGifIndex{
                kampLivIngGiftLatticeCell.layer.borderWidth = 1
            }else{
                kampLivIngGiftLatticeCell.layer.borderWidth = 0
            }
            
        }
        .disposed(by: kpRxDisposeBag)
        
        giftCollectionLattice.rx.itemSelected.subscribe { [weak self] indexPth in
            guard let self = self else {return}
            self.selectGifIndex = indexPth.row
            self.giftCollectionLatticeDatas.accept(giftCollectionLatticeDatas.value)
        }
        .disposed(by: kpRxDisposeBag)
        
        KampHelper.sharedHelper.kampLoginUser.subscribe { [weak self] kampLiveModel in
            guard let self = self else {return}
            self.kampLivePageModel = kampLiveModel
            if let _kampLiveModel = kampLiveModel {
                self.kampStarQuantity.text = "\(_kampLiveModel.kampStar)"
            }
        }
        .disposed(by: kpRxDisposeBag)
    }
    
    @IBAction func chargeKampClick(_ sender: UIButton) {
        self.backTouchIdx?(0,0)
    }
    
    
}
