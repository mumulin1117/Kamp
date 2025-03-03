//
//  SelectChannelLattice.swift
//  Kamp
//
//  Created by Kamp on 2024/12/4.
//

import UIKit

class SelectChannelLattice: UIView {

    var nowSelectKpChannel:UIButton?
    @IBOutlet weak var selectChannelKpConfirmButton: UIButton!
    @IBOutlet weak var selectChannelCloseKp: UIButton!
    
    var liveChannel:String?
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func selectChannkpel(_ sender: UIButton) {
        guard sender.isSelected == false else {return}
        
        sender.isSelected.toggle()
        nowSelectKpChannel?.isSelected.toggle()
        nowSelectKpChannel = sender
        
        switch sender.tag - 100 {
        case 0:
            liveChannel = "Enter tainment live"
        case 1:
            liveChannel = "Study share live"
        case 2:
            liveChannel = "Campus life live"
        default:
            break
        }
        
    }
}
