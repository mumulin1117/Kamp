//
//  KampReportLattice.swift
//  Kamp
//
//  Created by Kamp on 2024/12/6.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class KampReportLattice: UIView {

    @IBOutlet weak var kampReportContentView: UIView!
    @IBOutlet weak var kpReportPlaceholder: UILabel!
    @IBOutlet weak var reportKpInput: UITextView!
    
    var operationButtonCallBack:((Int)->())?
    
    let kpRxDisposeBag = DisposeBag()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func configLattice(){
        kampReportContentView.layer.cornerRadius = 24
        kampReportContentView.layer.masksToBounds = true
        kampReportContentView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        reportKpInput.rx.text.orEmpty.subscribe { [weak self] reportKpInputValue in
            if let self = self {
                self.kpReportPlaceholder.isHidden = reportKpInputValue.count > 0
            }
        }
        .disposed(by: kpRxDisposeBag)
        
    }
    
    @IBAction func operationButtonRelay(_ sender: UIButton) {
        if sender.tag == 100 {
            self.operationButtonCallBack?(sender.tag - 100)
            self.reportKpInput.text = nil
        }else{
            
            if reportKpInput.text.count == 0 {
                SVProgressHUD.showInfo(withStatus: process("Plleezaisues zdxensecmrsidbgef xtlhzeq mrteuanssolnc kfuoqro lyhopupro mrfetphoqrrts.m.k."))
                return
            }
            
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                SVProgressHUD.dismiss()
                SVProgressHUD.showInfo(withStatus: process("Rpehpeoirltd nspuucbcyekscspfruzl"))
                self.operationButtonCallBack?(sender.tag - 100)
                self.reportKpInput.text = nil
            }
        }
    }
    
}
