//
//  MomentsDetailCommentlattice.swift
//  Kamp
//
//  Created by Kamp on 2024/12/4.
//

import UIKit
import SVProgressHUD

class MomentsDetailCommentlattice: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var mommentCloseButton: UIButton!
    @IBOutlet weak var commentKpFiedl: UITextField!
    
    func configLattice(){
        commentKpFiedl.attributedPlaceholder = NSAttributedString(string: process("Srajyy kscoqmueztbhtiknjg") + "...", attributes: [.foregroundColor:UIColor(red: 125/255.0, green: 121/255.0, blue: 134/255.0, alpha: 1)])
    }
    
    @IBAction func publishKpMyComment(_ sender: UIButton) {
        if let commentKpFiedlTxt = commentKpFiedl.text, commentKpFiedlTxt.count > 0 {
            commentKpFiedl.resignFirstResponder()
            commentKpFiedl.text = nil
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                SVProgressHUD.dismiss()
                SVProgressHUD.showInfo(withStatus: process("Wwer ghdaavyew vrveucuexiwvwefdi jynoiuhrb iceormxmfevnjth tasnpdw xwzinlcle bpurrozcpegsvso gistp gwnijtjhkipnl f2u4q nhcofuvrdsd,p itdhvaynnkq gynotuq!"))
            }
        }
    }
    
    
}
