//
//  KampReportOrBlockLattice.swift
//  Kamp
//
//  Created by Kamp on 2024/12/6.
//

import UIKit

class KampReportOrBlockLattice: UIView {

    var reportOrBlockCallBack:((Int)->())?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func reportOrBlockRalay(_ sender: UIButton) {
        reportOrBlockCallBack?(sender.tag - 1000)
    }
    @IBAction func reportCloseRelay(_ sender: Any) {
        reportOrBlockCallBack?(-1)
    }
    
}
