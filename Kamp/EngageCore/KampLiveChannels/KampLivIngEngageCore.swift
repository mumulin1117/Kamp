//
//  KampLivIngEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/3.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

struct KpLiveGifModel{
    var index = 0
    var giftCount = 1
    var timeKpSpan:Double = 0
}

class KampLivIngEngageCore: EngageCore ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var kampCommentTable: UITableView!
    @IBOutlet weak var kampGigtTable: UITableView!
    @IBOutlet weak var liverImageLattice: UIImageView!
    @IBOutlet weak var liverKpName: UILabel!
    @IBOutlet weak var liveLikeNumber: UIButton!
    @IBOutlet weak var livePersonNumber: UIButton!
    @IBOutlet weak var liverKpFollowButton: UIButton!
    @IBOutlet weak var liveCommentField: UITextField!
    @IBOutlet weak var liveKpFavoriteButton: UIButton!
    @IBOutlet weak var monmentSTableLattice: UITableView!
    @IBOutlet weak var giftTableLattice: UITableView!
    @IBOutlet weak var liveKpCoverLattice: UIImageView!
    
    
    @IBOutlet weak var liveReportButton: UIButton!
    @IBOutlet weak var liveCollecButton: UIButton!
    @IBOutlet weak var kpGiftButton: UIButton!
    @IBOutlet weak var giftRight: NSLayoutConstraint!
    
    var liveCoverImage:UIImage?
    
    var monmentSDatas:[String] = [String]()
    var kpSelectGiftDatas:[KpLiveGifModel] = [KpLiveGifModel]()
    
    let kampLiveModel = BehaviorRelay<KampLiveModel?>(value: nil)
    
    var kampPageModel:KampLiveModel?
    
    lazy var kampGiftView:KampLivIngGiftLattice = {
        if let kampGiftView = Bundle.main.loadNibNamed("KampLivIngGiftLattice", owner: nil)?.last as? KampLivIngGiftLattice {
            kampGiftView.backTouchIdx = { [weak self] kpSelectType,kpSelectIndex in
                guard let self = self else {return}
                self.giftViewMaskControlClick()
                
                if kpSelectType == 1 {
                    
                    if let giftKpIndex = self.kpSelectGiftDatas.firstIndex(where: {$0.index == kpSelectIndex}) {
                        var giftKpItem = self.kpSelectGiftDatas[giftKpIndex]
                        self.kpSelectGiftDatas.remove(at: giftKpIndex)
                        giftKpItem.giftCount += 1
                        giftKpItem.timeKpSpan = Date().timeIntervalSince1970
                        self.kpSelectGiftDatas.insert(giftKpItem, at: 0)
                    }else{
                        let giftKpModel = KpLiveGifModel.init(index: kpSelectIndex,timeKpSpan: Date().timeIntervalSince1970)
                        self.kpSelectGiftDatas.insert(giftKpModel, at: 0)
                    }
                    self.giftTableLattice.reloadData()
                    
                }else{
                    // recharge
                    self.performSegue(withIdentifier: "KampChestEngageCore", sender: self)
                }
            }
            return kampGiftView
        }
        return KampLivIngGiftLattice()
    }()
    
    lazy var giftViewMaskControl:UIControl = {
        let giftViewMaskControl = UIControl()
        giftViewMaskControl.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        giftViewMaskControl.addTarget(self, action: #selector(giftViewMaskControlClick), for: .touchUpInside)
        return giftViewMaskControl
    }()
    
    
    var kampReportLattice:KampReportLattice?
    var selectKampLattice:KampReportOrBlockLattice?
    var isKampReport = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bindToLattice()
        monmentSTableLattice.transform = CGAffineTransformMakeScale(1, -1);
        giftTableLattice.transform = CGAffineTransformMakeScale(1, -1);
        monmentSTableLattice.delegate = self
        monmentSTableLattice.dataSource = self
    }
    
    private func bindToLattice(){
        
        kampLiveModel.subscribe { [weak self] kampLiveModel in
            if let self = self , let _kampLiveModel = kampLiveModel {
                self.kampPageModel = _kampLiveModel
                self.liverImageLattice.image = UIImage(named: _kampLiveModel.kampLiverIdentif)
                if self.liveCoverImage != nil {
                    self.liveKpCoverLattice.image = self.liveCoverImage
                    self.giftRight.constant = 16
                    self.liveReportButton.isHidden = true
                    self.liveCollecButton.isHidden = true
                    self.kpGiftButton.isHidden = true
                }else{
                    self.liveKpCoverLattice.image = UIImage(named: _kampLiveModel.kampLiveCover)
                }
                self.liverKpName.text = _kampLiveModel.kampLiver
                self.liveLikeNumber.setTitle("\(_kampLiveModel.liveLikeCount)", for: .normal)
                self.livePersonNumber.setTitle("\(_kampLiveModel.liveSeeCount)", for: .normal)
                
                if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.liverKpFollow.title + _kampLiveModel.kampLiveId) {
                    self.liverKpFollowButton.isSelected = true
                }else{
                    self.liverKpFollowButton.isSelected = false
                }
                
                if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.liveLike.title + _kampLiveModel.kampLiveId) {
                    self.liveKpFavoriteButton.isSelected = true
                }else{
                    self.liveKpFavoriteButton.isSelected = false
                }
            }
        }
        .disposed(by: kpRxDisposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] count in
                guard let self = self else {return}
                
                let timeKpNow = Date().timeIntervalSince1970
                self.kpSelectGiftDatas = self.kpSelectGiftDatas.filter({ kpLiveGifModel in
                    return timeKpNow - kpLiveGifModel.timeKpSpan <  5
                })
                self.giftTableLattice.reloadData()
            })
            .disposed(by: kpRxDisposeBag)
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
        } else{
            kampGiftView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(400)
            }
        }
        
        
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.giftViewMaskControl.removeFromSuperview()
            self.kampGiftView.removeFromSuperview()
            self.kampReportLattice?.removeFromSuperview()
            self.selectKampLattice?.removeFromSuperview()
        }

    }
    
    @IBAction func kampCloseLiving(_ sender: UIButton) {
        
        KampHelper.showKampAlert(on: self, message: process("Etnddp jtghfew xlricvdeq psutarreoahmc?")) {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    /// 关注
    @IBAction func kampCollectLiving(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if let kampPageModel = kampPageModel {
            if sender.isSelected == true && self.kampPageModel != nil {
                KampHelper.sharedHelper.currentMMKV?.set(kampPageModel.kampLiveId, forKey: LiveOperation.liverKpFollow.title + kampPageModel.kampLiveId)
            }else{
                KampHelper.sharedHelper.currentMMKV?.removeValue(forKey: LiveOperation.liverKpFollow.title + kampPageModel.kampLiveId)
            }
            
            kampLiveModel.accept(kampPageModel)
            NotificationCenter.default.post(name: NSNotification.Name("timeLineListUpdate"), object: nil)
        }
    }
    
    
    @IBAction func kampReportLiving(_ sender: UIButton) {
        isKampReport = 2
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
                                if let kampPageModel = self.kampPageModel {
                                    KampHelper.sharedHelper.currentMMKV?.set(kampPageModel.kampLiveId, forKey: LiveOperation.liveBlock.title + kampPageModel.kampLiveId)
                                    NotificationCenter.default.post(name: NSNotification.Name("liveBlocked"), object: nil)
                                    self.navigationController?.popViewController(animated: true)
                                }
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
        
        self.view.addSubview(giftViewMaskControl)
        giftViewMaskControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.selectKampLattice!)
        self.selectKampLattice!.snp.removeConstraints()
        selectKampLattice!.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(270)
            make.bottom.equalToSuperview().offset(270)
        }
        self.view.layoutIfNeeded()
        
        selectKampLattice!.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func kpShowBlockOrReportLattice(){
        isKampReport = 1
        
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
        
        self.view.addSubview(giftViewMaskControl)
        giftViewMaskControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.kampReportLattice!)
        self.kampReportLattice!.snp.removeConstraints()
        kampReportLattice!.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(570)
            make.bottom.equalToSuperview().offset(570)
        }
        self.view.layoutIfNeeded()
        
        kampReportLattice!.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func openKampGiftView(_ sender: UIButton) {
        isKampReport = 3
        self.view.addSubview(self.giftViewMaskControl)
        self.giftViewMaskControl.snp.removeConstraints()
        self.giftViewMaskControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.kampGiftView)
        self.kampGiftView.snp.removeConstraints()
        kampGiftView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(400)
            make.bottom.equalToSuperview().offset(400)
        }
        self.view.layoutIfNeeded()
        
        kampGiftView.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func kampLivingLike(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        
        if let kampPageModel = kampPageModel {
            if sender.isSelected == true && self.kampPageModel != nil {
                KampHelper.sharedHelper.currentMMKV?.set(kampPageModel.kampLiveId, forKey: LiveOperation.liveLike.title + kampPageModel.kampLiveId)
                kampPageModel.liveLikeCount += 1
            }else{
                KampHelper.sharedHelper.currentMMKV?.removeValue(forKey: LiveOperation.liveLike.title + kampPageModel.kampLiveId)
                kampPageModel.liveLikeCount -= 1
            }
            
            kampLiveModel.accept(kampPageModel)
        }
    }
    
    @IBAction func kampCommtenLiving(_ sender: UIButton) {
        if self.liveCommentField.text?.count ?? 0 > 0 {
            self.liveCommentField.resignFirstResponder()
            
            let kpEditText = self.liveCommentField.text!
            
            monmentSDatas.insert(kpEditText, at: 0)
            
            monmentSTableLattice.reloadData()
            self.liveCommentField.text = nil
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return tableView == monmentSTableLattice ? monmentSDatas.count : kpSelectGiftDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == monmentSTableLattice {
            let kpLiveMommentsLatticeCell = tableView.dequeueReusableCell(withIdentifier: "KpLiveMommentsLatticeCell") as! KpLiveMommentsLatticeCell
            kpLiveMommentsLatticeCell.transform = CGAffineTransformMakeScale(1, -1);
            if let loginKampPageModel = KampHelper.sharedHelper.kampLoginUser.value {
                kpLiveMommentsLatticeCell.liverImageLaiite.image = loginKampPageModel.liverCache != nil ? loginKampPageModel.liverCache : UIImage(named: loginKampPageModel.kampLiverIdentif)
            }
            kpLiveMommentsLatticeCell.kpMonment.text = monmentSDatas[indexPath.section]
            return kpLiveMommentsLatticeCell
        }else{
            let showTableViewLatticeCell = tableView.dequeueReusableCell(withIdentifier: "KpLiveGiftShowTableViewLatticeCell") as! KpLiveGiftShowTableViewLatticeCell
            showTableViewLatticeCell.transform = CGAffineTransformMakeScale(1, -1);
            if let loginKampPageModel = KampHelper.sharedHelper.kampLoginUser.value {
                showTableViewLatticeCell.kpUserLattice.image = loginKampPageModel.liverCache != nil ? loginKampPageModel.liverCache : UIImage(named: loginKampPageModel.kampLiverIdentif)
                showTableViewLatticeCell.liveUserName.text = loginKampPageModel.kampLiver
                showTableViewLatticeCell.liveGifLattice.image = UIImage(named: "giftItem" + "\(kpSelectGiftDatas[indexPath.section].index)")
                showTableViewLatticeCell.giftKpCount.isHidden = true
                if kpSelectGiftDatas[indexPath.section].giftCount > 1 {
                    showTableViewLatticeCell.giftKpCount.text = "X" + "\(kpSelectGiftDatas[indexPath.section].giftCount)"
                    showTableViewLatticeCell.giftKpCount.isHidden = false
                }
            }
            return showTableViewLatticeCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
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
