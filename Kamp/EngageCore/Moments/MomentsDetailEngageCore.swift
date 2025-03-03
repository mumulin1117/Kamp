//
//  MomentsDetailEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/4.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class MomentsDetailEngageCore: EngageCore,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var mommentComment: UIButton!
    
    var kpCommentTableLattice:MomentsDetailCommentlattice?
    
    var giftViewMaskControl:UIControl?
    
    var kampReportLattice:KampReportLattice?
    
    var selectKampLattice:KampReportOrBlockLattice?
    
    let timelineKpModel = BehaviorRelay<KampLiveModel?>(value: nil)
    
    var isKampReport = 0
    
    @IBOutlet weak var timelineImageLattice: UIImageView!
    @IBOutlet weak var timeLineCollecLattice: UICollectionView!
    @IBOutlet weak var timelineInfo: UILabel!
    @IBOutlet weak var timelinerImageLattice: UIImageView!
    @IBOutlet weak var timelinerName: UILabel!
    @IBOutlet weak var timelinerFollowStatus: UIButton!
    @IBOutlet weak var timelineLikeStatus: UIButton!
    @IBOutlet weak var kpItemPageControl: UIPageControl!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configLattice()
        bindToLattice()
    }
    
    fileprivate func bindToLattice(){
        timelineKpModel.subscribe { [weak self] timelineKpModel in
            guard let self = self else {return}
            if let _timelineKpModel = timelineKpModel {
                self.timelineInfo.text = _timelineKpModel.timelineInfo
                self.timelinerImageLattice.image = UIImage(named: _timelineKpModel.kampLiverIdentif)
                self.timelinerName.text = _timelineKpModel.kampLiver
                self.kpItemPageControl.numberOfPages = _timelineKpModel.timelinePictures.count
                self.timeLineCollecLattice.reloadData()
                
                if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.timeLineLike.title + _timelineKpModel.timelineId){
                    timelineLikeStatus.isSelected = true
                }else{
                    timelineLikeStatus.isSelected = false
                }
                
                if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.liverKpFollow.title + _timelineKpModel.kampLiveId){
                    timelinerFollowStatus.isSelected = true
                }else{
                    timelinerFollowStatus.isSelected = false
                }
            }
        }
        .disposed(by: kpRxDisposeBag)
    }
    
    @IBAction func timelinerFollowStatusRelay(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if let kampPageModel = timelineKpModel.value {
            if sender.isSelected == true {
                KampHelper.sharedHelper.currentMMKV?.set(kampPageModel.kampLiveId, forKey: LiveOperation.liverKpFollow.title + kampPageModel.kampLiveId)
            }else{
                KampHelper.sharedHelper.currentMMKV?.removeValue(forKey: LiveOperation.liverKpFollow.title + kampPageModel.kampLiveId)
            }
            NotificationCenter.default.post(name: NSNotification.Name("timeLineListUpdate"), object: nil)
        }
            
    }
    
    @IBAction func timelineLikeStatusRelay(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if let kampPageModel = timelineKpModel.value {
            if sender.isSelected == true {
                KampHelper.sharedHelper.currentMMKV?.set(kampPageModel.kampLiveId, forKey: LiveOperation.timeLineLike.title + kampPageModel.timelineId)
                kampPageModel.liveLikeCount += 1
            }else{
                KampHelper.sharedHelper.currentMMKV?.removeValue(forKey: LiveOperation.timeLineLike.title + kampPageModel.timelineId)
                kampPageModel.liveLikeCount -= 1
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("timeLineListUpdate"), object: nil)
        }
    }
    
    @IBAction func navigationKampRightRelay(_ sender: UIButton) {
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
                                if let kampPageModel = self.timelineKpModel.value{
                                    KampHelper.sharedHelper.currentMMKV?.set(kampPageModel.kampLiveId, forKey: LiveOperation.timeLineBlock.title + kampPageModel.timelineId)
                                    self.navigationController?.popViewController(animated: true)
                                    NotificationCenter.default.post(name: NSNotification.Name("timeLineChanged"), object: nil)
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
        
        self.view.addSubview(giftViewMaskControl!)
        giftViewMaskControl!.snp.makeConstraints { make in
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
    
    private func configLattice(){
        let showroomCollectionLatticeLayout = UICollectionViewFlowLayout()
        showroomCollectionLatticeLayout.scrollDirection = .horizontal
        showroomCollectionLatticeLayout.minimumLineSpacing = 0
        showroomCollectionLatticeLayout.minimumInteritemSpacing = 0
        showroomCollectionLatticeLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        showroomCollectionLatticeLayout.itemSize = CGSizeMake(UIScreen.main.bounds.size.width - 30, 525 * (UIScreen.main.bounds.size.width/375))
        timeLineCollecLattice.setCollectionViewLayout(showroomCollectionLatticeLayout, animated: true)
        timeLineCollecLattice.delegate = self
        timeLineCollecLattice.dataSource = self
        
        mommentComment.setTitle(process("Srajyy kscoqmueztbhtiknjg") + "...", for: .normal)
        
        timelinerImageLattice.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(timelinerImageLatticeHandle)))
        timelinerImageLattice.isUserInteractionEnabled = true
    }
    
    @objc fileprivate func timelinerImageLatticeHandle(){
        if timelineKpModel.value?.kampLiverIdentif != KampHelper.sharedHelper.kampLoginUser.value?.kampLiverIdentif {
            self.performSegue(withIdentifier: "SkillShowroomEngageCore", sender: self)
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
        
        self.view.addSubview(giftViewMaskControl!)
        giftViewMaskControl!.snp.makeConstraints { make in
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 计算当前页
        let pageIndex = round(scrollView.contentOffset.x / (view.bounds.width-30))
        kpItemPageControl.currentPage = Int(pageIndex)
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
            kpCommentTableLattice?.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(649)
            }
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.giftViewMaskControl?.removeFromSuperview()
            self.kpCommentTableLattice?.removeFromSuperview()
            self.kampReportLattice?.removeFromSuperview()
            self.selectKampLattice?.removeFromSuperview()
        }
    }
    
    @IBAction func navigationBarKpBakc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func kpCommentTableLatticeOpen(_ sender: UIButton) {
        isKampReport = 3
        if giftViewMaskControl == nil {
            giftViewMaskControl = UIControl()
            giftViewMaskControl!.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            giftViewMaskControl!.addTarget(self, action: #selector(giftViewMaskControlClick), for: .touchUpInside)
        }
        
        if kpCommentTableLattice == nil {
            kpCommentTableLattice = Bundle.main.loadNibNamed("MomentsDetailCommentlattice", owner: nil)?.last as? MomentsDetailCommentlattice
            kpCommentTableLattice?.configLattice()
            kpCommentTableLattice?.mommentCloseButton.rx.tap.subscribe(onNext: { [weak self] _ in
                if let self = self{
                    self.giftViewMaskControlClick()
                }
            })
            .disposed(by: kpRxDisposeBag)
        }
        
        self.view.addSubview(giftViewMaskControl!)
        giftViewMaskControl!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.kpCommentTableLattice!)
        self.kpCommentTableLattice!.snp.removeConstraints()
        kpCommentTableLattice!.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(649)
            make.bottom.equalToSuperview().offset(649)
        }
        self.view.layoutIfNeeded()
        
        kpCommentTableLattice!.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let showRoomCollectionLatticeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowRoomCollectionLatticeCell", for: indexPath) as! ShowRoomCollectionLatticeCell
        if let timelineKpModel = timelineKpModel.value {
            showRoomCollectionLatticeCell.kampImageLattice.image = UIImage(named: timelineKpModel.timelinePictures[indexPath.row])
        }
        
        return showRoomCollectionLatticeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let timelineKpModel = timelineKpModel.value {
            return timelineKpModel.timelinePictures.count
        }else{
            return 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let kampSegIdentifier = segue.identifier
        if kampSegIdentifier?.isEmpty == false {
            
            if kampSegIdentifier == "SkillShowroomEngageCore" {
                let skillShowroomEngageCore = segue.destination as! SkillShowroomEngageCore
                skillShowroomEngageCore.kpLiveModel = self.timelineKpModel.value
            }
        }
        
    }

}
