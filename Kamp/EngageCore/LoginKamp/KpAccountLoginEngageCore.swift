//
//  KpAccountLoginEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/2.
//

import UIKit
import SVProgressHUD

class KpAccountLoginEngageCore: EngageCore {
    @IBOutlet weak var loginAccountField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configLattice()
    }
    
    private func configLattice(){
        self.loginAccountField.attributedPlaceholder = NSAttributedString(string: process("Ejnatfebrh aykofudrj leamxabijl"), attributes: [.foregroundColor:UIColor(red: 125/255.0, green: 121/255.0, blue: 134/255.0, alpha: 1),.font:UIFont.systemFont(ofSize: 15)])
        self.loginPasswordField.attributedPlaceholder = NSAttributedString(string: process("Eqngtzefrc lyooquarh rpsamsesowsomrrd"), attributes: [.foregroundColor:UIColor(red: 125/255.0, green: 121/255.0, blue: 134/255.0, alpha: 1),.font:UIFont.systemFont(ofSize: 15)])
    }
    
    @IBAction func changeSuereTextEntry(_ sender: UIButton) {
        sender.isSelected.toggle()
        loginPasswordField.isSecureTextEntry.toggle()
    }
    
    @IBAction func loginRelay(_ sender: UIButton) {
        
        if let accountTxt = loginAccountField.text, let kpPassword = loginPasswordField.text {
            if accountTxt != "kamp@gmail.com" && kpPassword != "666666" {
                SVProgressHUD.showInfo(withStatus: process("Tdhaem madczcyokuinxts qodro ypoausnsdwxodrudh riwsa bibnrckourwryencktm,q npllfeaadsjeh rcnhdezcqk"))
                return
            }
        }
        
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            KampHelper.sharedHelper.loadAllConfig {
                
                let tabbarController = KampTabbarController()
                self.navigationController?.pushViewController(tabbarController, animated: false)
                
                if KampHelper.sharedHelper.kampLiveDats.count > 0 {
                    let liveKpItem = KampHelper.sharedHelper.kampLiveDats.first
                    KampHelper.sharedHelper.kampLoginUser.accept(liveKpItem)
                    UserDefaults.standard.set(liveKpItem?.kampLiverIdentif, forKey: "isLogin")
                    UserDefaults.standard.synchronize()
                }
                SVProgressHUD.dismiss()
            }
        }
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
