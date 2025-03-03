//
//  KampFeedbackEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/5.
//

import UIKit
import SVProgressHUD
import RxSwift
import RxCocoa

class KampFeedbackEngageCore: EngageCore {

    @IBOutlet weak var inputKpBaseLattice: UIView!
    @IBOutlet weak var kpTextLattice: UITextView!
    @IBOutlet weak var kpInputPlaceholder: UILabel!
    @IBOutlet weak var contactKpField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configLattice()
        bindToLattice()
    }
    
    private func bindToLattice(){
        kpTextLattice.rx.text
            .orEmpty
            .subscribe { [weak self] kpTextLatticeNew in
                if let self = self {
                    self.kpInputPlaceholder.isHidden = kpTextLatticeNew.count > 0
                }
            }
            .disposed(by: kpRxDisposeBag)
    }
    
    private func configLattice(){
        contactKpField.attributedPlaceholder = NSAttributedString(string: process("Yjokucrl iegmxaeisl"), attributes: [.foregroundColor:UIColor(red: 125/255.0, green: 121/255.0, blue: 134/255.0, alpha: 1)])
    }
    
    @IBAction func submitRelay(_ sender: Any) {
        if self.contactKpField.text?.count == 0 {
            SVProgressHUD.showInfo(withStatus: "Please leave your email")
            return
        }
        
        if self.kpTextLattice.text?.count == 0 {
            SVProgressHUD.showInfo(withStatus: "Please fill in your suggestions, your suggestions are very important to us")
            return
        }
        
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            SVProgressHUD.dismiss()
            SVProgressHUD.showInfo(withStatus: "Thank you for your suggestion")
        }
    }

}
