//
//  StartUniMateAIEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/3.
//

import UIKit

class StartUniMateAIEngageCore: EngageCore {

    
    @IBAction func startUniMateAi(_ sender: UIButton) {
        
        if let kampLoginUser = KampHelper.sharedHelper.kampLoginUser.value {
            if kampLoginUser.kampStar > 300 {
                kampLoginUser.kampStar -= 300
                KampHelper.sharedHelper.kampLoginUser.accept(kampLoginUser)
                KampHelper.sharedHelper.currentMMKV?.set("isBuy", forKey: LiveOperation.aiBuy.title + kampLoginUser.kampLiverIdentif)
                self.performSegue(withIdentifier: "StartUniMateAIContentEngageCore", sender: self)
            }else{
                self.performSegue(withIdentifier: "KampChestEngageCore", sender: self)
            }
        }
    }
}
