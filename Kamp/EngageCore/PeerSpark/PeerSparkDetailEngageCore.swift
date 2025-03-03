//
//  PeerSparkDetailEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/4.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class PeerSparkDetailEngageCore: EngageCore,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var peerSparkDetailTableLattice: UITableView!
    
    @IBOutlet weak var peerSparkFiedl: UITextField!
    
    var isKampReport = 0
    
    var giftViewMaskControl:UIControl?
    
    var kampReportLattice:KampReportLattice?
    
    var selectKampLattice:KampReportOrBlockLattice?
    
    var detailKpDatas = [UniMateAIContent]()
    //    var peerSparkDetailTableLatticeDatas = []()
    
    @IBOutlet weak var liverName: UILabel!
    var kpLiveModel:KampLiveModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        configTableLattice()
        getAllDetailKpDatas()
    }
    
    private func configTableLattice(){
        peerSparkDetailTableLattice.rowHeight = UITableView.automaticDimension
        peerSparkDetailTableLattice.estimatedRowHeight = 100
        peerSparkFiedl.attributedPlaceholder = NSAttributedString(string: process("Srajyy kscoqmueztbhtiknjg") + "...", attributes: [.foregroundColor:UIColor(red: 125/255.0, green: 121/255.0, blue: 134/255.0, alpha: 1)])
        
        if let kpLiveModel = kpLiveModel {
            liverName.text = kpLiveModel.kampLiver
        }
        
    }
    
    fileprivate func getAllDetailKpDatas(){
        if let kpLiveModel = self.kpLiveModel {
            self.detailKpDatas = KampHelper.sharedHelper.detailKpDatas.filter {$0.liverIdentifier == kpLiveModel.kampLiverIdentif}
            self.peerSparkDetailTableLattice.reloadData()
        }
    }
    
    @IBAction func peersparkSdend(_ sender: UIButton) {
        
        let kampAiTxt = peerSparkFiedl.text ?? ""
        
        if kampAiTxt.count > 0 ,let kpLiveModel = self.kpLiveModel{
            
            self.peerSparkFiedl.resignFirstResponder()
            let kpContent = UniMateAIContent(UniMateAIContentInfo: kampAiTxt,type: 1,liverIdentifier: kpLiveModel.kampLiverIdentif,liverName: kpLiveModel.kampLiver)
            detailKpDatas.append(kpContent)
            KampHelper.sharedHelper.detailKpDatas.append(kpContent)
            self.peerSparkDetailTableLattice.reloadData()
            peerSparkFiedl.text = nil
            KampHelper.sharedHelper.peerSparkDatas.removeAll {$0.liverIdentifier == kpLiveModel.kampLiverIdentif}
            KampHelper.sharedHelper.peerSparkDatas.insert(kpContent, at: 0)
            
        }
    }
    
    @IBAction func navigationBarKpBakc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func liveLinkKampRelay(_ sender: Any) {
        self.performSegue(withIdentifier: "KampLiveLinkEngageCore", sender: self)
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
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.giftViewMaskControl?.removeFromSuperview()
            self.kampReportLattice?.removeFromSuperview()
            self.selectKampLattice?.removeFromSuperview()
        }
    }
    
    @IBAction func kampReportOrBlockRelay(_ sender: Any) {
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
                                if let kampPageModel = self.kpLiveModel{
                                    KampHelper.sharedHelper.currentMMKV?.set(kampPageModel.kampLiveId, forKey: LiveOperation.kampUserBlock.title + kampPageModel.kampLiverIdentif)
                                    NotificationCenter.default.post(name: NSNotification.Name("peerSparkBlock"), object: nil)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let peerSparkDetailTableViewLatticeCell = tableView.dequeueReusableCell(withIdentifier: "PeerSparkDetailTableViewLatticeCell", for: indexPath) as! PeerSparkDetailTableViewLatticeCell
        let kpLiveModel = detailKpDatas[indexPath.section].UniMateAIContentInfo
        peerSparkDetailTableViewLatticeCell.sparkContent.text = kpLiveModel
        if let kpLiveModel = KampHelper.sharedHelper.kampLoginUser.value {
            if kpLiveModel.liverCache != nil {
                peerSparkDetailTableViewLatticeCell.kpLiverImageLaiiice.image = kpLiveModel.liverCache!
            }else{
                peerSparkDetailTableViewLatticeCell.kpLiverImageLaiiice.image = UIImage(named: kpLiveModel.kampLiverIdentif)
            }
        }
        return peerSparkDetailTableViewLatticeCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = detailKpDatas.count
        if numberOfSections > 0{
            return numberOfSections
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let kampSegIdentifier = segue.identifier
        if kampSegIdentifier?.isEmpty == false {
            
            
            if kampSegIdentifier == "KampLiveLinkEngageCore" {
                let campLivIngEngageCore = segue.destination as! KampLiveLinkEngageCore
                campLivIngEngageCore.kpLiveModel = self.kpLiveModel
            }
        }
        
    }

}
