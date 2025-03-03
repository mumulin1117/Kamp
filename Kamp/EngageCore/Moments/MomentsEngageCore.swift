//
//  MomentsEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/2.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class MomentsEngageCore: EngageCore ,UIScrollViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var momentCollectionLattice: UICollectionView!
    @IBOutlet weak var momentCollectionLatticeHeight: NSLayoutConstraint!
    
    var momentCollectionLatticeDatas:[KampLiveModel]?
    
    var momentCollectionIdx:KampLiveModel?
    
    var giftViewMaskControl:UIControl?
    
    var kampReportLattice:KampReportLattice?
    
    var selectKampLattice:KampReportOrBlockLattice?
    
    var isKampReport = 0
    var mommentSeleceKpButton:UIButton?
    
    var isMenuFollow = false
    
    @IBOutlet weak var mommentFirstButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        momentCollectionLatticeHeight.constant = UIScreen.main.bounds.size.height - 84 - 59 - 21 - (self.tabBarController?.tabBar.bounds.height)!

        let momentCollectionLatticeLayout = UICollectionViewFlowLayout()
        momentCollectionLatticeLayout.scrollDirection = .horizontal
        momentCollectionLatticeLayout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        momentCollectionLatticeLayout.minimumInteritemSpacing = 10
        momentCollectionLatticeLayout.itemSize = CGSizeMake(305 * (UIScreen.main.bounds.size.width / 375.0),(UIScreen.main.bounds.size.height - 84 - 59 - 21 - (self.tabBarController?.tabBar.bounds.height)!))
        mommentSeleceKpButton = mommentFirstButton
        momentCollectionLattice.setCollectionViewLayout(momentCollectionLatticeLayout, animated: true)
        momentCollectionLattice.delegate = self
        momentCollectionLattice.dataSource = self
        
        NotificationCenter.default.rx.notification(Notification.Name("timeLineListUpdate")).subscribe {[weak self] _ in
            guard let self = self else {return}
            self.momentCollectionLattice.reloadData()
        }
        .disposed(by: kpRxDisposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name("timeLineChanged")).subscribe {[weak self] _ in
            guard let self = self else {return}
            self.getTimeLineDatas(loading: false)
        }
        .disposed(by: kpRxDisposeBag)
        
        getTimeLineDatas()
    }
    
    @IBAction func mommentMenuSwitch(_ sender: UIButton) {
        guard mommentSeleceKpButton != sender else {return}
        sender.isSelected = true
        mommentSeleceKpButton?.isSelected = false
        
        mommentSeleceKpButton = sender
        
        if sender.tag == 102 {
            isMenuFollow = true
        }else{
            isMenuFollow = false
        }
        
        getTimeLineDatas()
    }
    
    
    fileprivate func getTimeLineDatas(loading:Bool = true){
        if loading {
            SVProgressHUD.show()
        }
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
                if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.timeLineBlock.title + liveItems.timelineId) {
                    return true
                }else{
                    return false
                }
            }
            
            if self.isMenuFollow == true {
                kampItems.removeAll { liveItems in
                    if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.liverKpFollow.title + liveItems.kampLiveId) {
                        return false
                    }else{
                        return true
                    }
                }
            }
            
            if loading == true {
                sleep(2)
            }
            
            DispatchQueue.main.async {
                if loading{
                    SVProgressHUD.dismiss()
                }
                self.momentCollectionLatticeDatas = kampItems
                self.momentCollectionLattice.reloadData()
                if kampItems.count > 0 {
                    self.momentCollectionLattice.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
                }
            }
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = momentCollectionLattice.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let currentOffset = scrollView.contentOffset.x
        var targetIndex = round(currentOffset / cellWidthIncludingSpacing)
        if velocity.x > 0 {
            targetIndex = floor(targetIndex + 1)
        } else if velocity.x < 0 {
            targetIndex = ceil(targetIndex - 1)
        }

        targetIndex = max(0, min(targetIndex, CGFloat(momentCollectionLattice.numberOfItems(inSection: 0) - 1)))
        targetContentOffset.pointee.x = targetIndex * cellWidthIncludingSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return momentCollectionLatticeDatas?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let momentCollectionLatticeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MomentCollectionLatticeCell", for: indexPath) as! MomentCollectionLatticeCell
        momentCollectionLatticeCell.reportButtonCallBack = { [weak self] in
            guard let self = self else {return}
            self.navigationKampRightRelay(kampPageModel: momentCollectionLatticeDatas![indexPath.row])
        }
        momentCollectionLatticeCell.kampModel = momentCollectionLatticeDatas![indexPath.row]
        return momentCollectionLatticeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        momentCollectionIdx = momentCollectionLatticeDatas![indexPath.row]
        self.performSegue(withIdentifier: "MomentsDetailEngageCore", sender: self)
    }
    
    fileprivate func navigationKampRightRelay(kampPageModel:KampLiveModel) {
        isKampReport = 2
        if giftViewMaskControl == nil {
            giftViewMaskControl = UIControl()
            giftViewMaskControl!.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            giftViewMaskControl!.addTarget(self, action: #selector(giftViewMaskControlClick), for: .touchUpInside)
        }
        
        if selectKampLattice == nil {
            selectKampLattice = Bundle.main.loadNibNamed("KampReportOrBlockLattice", owner: nil)?.last as? KampReportOrBlockLattice
            selectKampLattice?.reportOrBlockCallBack = { [weak self] kampFlag in
                if let self = self {
                    self.giftViewMaskControlClick()
                    
                    if kampFlag < 0 {
                        return
                    }
                    
                    if kampFlag == 0 {
                        SVProgressHUD.show()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            SVProgressHUD.dismiss()
                            SVProgressHUD.showInfo(withStatus: process("Bilgoccckiexd"))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                KampHelper.sharedHelper.currentMMKV?.set(kampPageModel.kampLiveId, forKey: LiveOperation.timeLineBlock.title + kampPageModel.timelineId)
                                self.getTimeLineDatas(loading: false)
                            }
                        }
                    }else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.kpShowBlockOrReportLattice()
                        }
                    }
                }
            }
        }
        
        if let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first {
            rootViewController.view.addSubview(giftViewMaskControl!)
        }
        
        giftViewMaskControl!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first {
            rootViewController.view.addSubview(self.selectKampLattice!)
        }
        
        self.selectKampLattice!.snp.removeConstraints()
        selectKampLattice!.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(270)
            make.bottom.equalToSuperview().offset(270)
        }
        
        if let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first {
            rootViewController.view.layoutIfNeeded()
        }
        
        selectKampLattice!.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2) {
            
            if let rootViewController = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
                .first {
                rootViewController.view.layoutIfNeeded()
            }
        }
    }
    
    fileprivate func kpShowBlockOrReportLattice(){
        isKampReport = 1
        if giftViewMaskControl == nil {
            giftViewMaskControl = UIControl()
            giftViewMaskControl!.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            giftViewMaskControl!.addTarget(self, action: #selector(giftViewMaskControlClick), for: .touchUpInside)
        }
        
        if kampReportLattice == nil {
            kampReportLattice = Bundle.main.loadNibNamed("KampReportLattice", owner: nil)?.last as? KampReportLattice
            kampReportLattice?.configLattice()
            kampReportLattice?.operationButtonCallBack = { [weak self] kampFlag in
                if let self = self {
                    if kampFlag == 1 {
                        
                    }
                    self.giftViewMaskControlClick()
                }
            }
        }
        
        var rootViewController:UIViewController? = nil
        if let rootController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first {
            rootViewController = rootController
        }
        
        rootViewController!.view.addSubview(giftViewMaskControl!)
        giftViewMaskControl!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rootViewController!.view.addSubview(self.kampReportLattice!)
        self.kampReportLattice!.snp.removeConstraints()
        kampReportLattice!.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(570)
            make.bottom.equalToSuperview().offset(570)
        }
        rootViewController!.view.layoutIfNeeded()
        
        kampReportLattice!.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2) {
            rootViewController!.view.layoutIfNeeded()
        }
    }
    
    @objc private func giftViewMaskControlClick(){
        
        if isKampReport == 1 {
            kampReportLattice?.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(570)
            }
        }else if isKampReport == 2 {
            selectKampLattice?.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(270)
            }
        }
        
        UIView.animate(withDuration: 0.25) {
            if let rootViewController = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
                .first {
                rootViewController.view.layoutIfNeeded()
            }
        } completion: { _ in
            self.giftViewMaskControl?.removeFromSuperview()
            self.kampReportLattice?.removeFromSuperview()
            self.selectKampLattice?.removeFromSuperview()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let kampSegIdentifier = segue.identifier
        if kampSegIdentifier?.isEmpty == false {
            
            if kampSegIdentifier == "MomentsDetailEngageCore" {
                let momentsDetailEngageCore = segue.destination as! MomentsDetailEngageCore
                momentsDetailEngageCore.timelineKpModel.accept(self.momentCollectionIdx)
            }
        }
    }

}
