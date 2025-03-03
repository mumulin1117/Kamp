//
//  KampSettingEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/5.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class KampSettingEngageCore: EngageCore,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var KampSettingTableLattice: UITableView!
    
    let KampSettingTableLatticeDatas:[[String]] = [
        [
            process("Pfrwirvrayclyv b&i tUmszevrt oAkgdrdebehmmejnwt"),
            process("Ctljeiaxrn ftahqeg mcqahcthie"),
            process("Afbyoqudte juts"),
            process("Bclqorchkneidn pLtiyswt"),
            process("Hdeollpo c&x gFvefendobraqcmk")
        ],
        [process("Ddevaxcgtrivvwamthed xArczcooquanit")]
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = process("Smestpthicnjgqs")
    }
    
    @IBAction func logoutRelay(_ sender: Any) {
        showKampTipAlert(kpState: 0)
    }
    
    fileprivate func showKampTipAlert(kpState:Int){
        let alertKpContent = kpState == 0 ? process("Aoroeo qywomup askuxrseu zyqofuf kwtacnptq xtmom ieoxaiott?") : process("Airbet hywojuc mstudreei dytovup gwvannatl htkow zdfecldeytweg?x yDcaatgao pcfabnyneootd qbeep broepcwoivxejrjetdk jadfrtceere ydyejlpeltiihoqn")
        KampHelper.showKampAlert(on: self, message: alertKpContent ,confirmTitle: process("Sgufrwe")) {
            if kpState == 1 || KampHelper.sharedHelper.kampLoginUser.value?.liverInfo == "-" {
                KampHelper.sharedHelper.currentMMKV?.clearAll()
            }
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                KampHelper.sharedHelper.kampLoginUser.accept(nil)
                
                let loginKampEngageCore = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginKampEngageCore") as! LoginKampEngageCore
                UserDefaults.standard.removeObject(forKey: "isLogin")
                UserDefaults.standard.synchronize()
                self.resetKpRoot(to: UINavigationController(rootViewController: loginKampEngageCore))
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KampSettingTableLatticeDatas[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return KampSettingTableLatticeDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kampSettingTableViewLatticeCell = tableView.dequeueReusableCell(withIdentifier: "KampSettingTableViewLatticeCell", for: indexPath) as! KampSettingTableViewLatticeCell
        kampSettingTableViewLatticeCell.settingItemImageLattice.image = UIImage(named: "kampSettingItem" + (indexPath.section == 1 ? "1" : "") + "\(indexPath.row)")
        kampSettingTableViewLatticeCell.settingItemTitle.text = KampSettingTableLatticeDatas[indexPath.section][indexPath.row]
        kampSettingTableViewLatticeCell.settingRIghtLattice.isHidden = false
        if indexPath.section == 1 {
            kampSettingTableViewLatticeCell.settingItemTitle.textColor = UIColor(red: 0.93, green: 0.09, blue: 0.25, alpha: 1)
            kampSettingTableViewLatticeCell.settingRIghtLattice.isHidden = true
        }
        return kampSettingTableViewLatticeCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 13
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            showKampTipAlert(kpState: 1)
        }else{
            switch indexPath.row {
            case 0:
                let userAgreementEngageCore = UserAgreementEngageCore()
                userAgreementEngageCore.kampInfo = "https://cool-hummingbird-4bf5e6.netlify.app/users"
                self.navigationController?.pushViewController(userAgreementEngageCore, animated: true)
            case 1:
                showKpProgressOverKpTime()
            case 2:
                self.performSegue(withIdentifier: "KampAboutEngageCore", sender: self)
                
            case 3:
                self.performSegue(withIdentifier: "KampInteractionFilterEngageCore", sender: self)
            case 4:
                self.performSegue(withIdentifier: "KampFeedbackEngageCore", sender: self)
            default: break
            }
        }
        
    }
    
    func showKpProgressOverKpTime() {
        
        SVProgressHUD.showProgress(0.0, status: "Waiting...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var currentProgress: Float = 0.0
            let totalDuration: Float = 4.0
            let timerInterval: TimeInterval = 0.1
            let progressIncrement = timerInterval / Double(totalDuration)

            Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
                currentProgress = min(currentProgress + Float(progressIncrement), 1.0)

                SVProgressHUD.showProgress(currentProgress, status: "\(Int(currentProgress * 100))%")

                if currentProgress >= 1.0 {
                    timer.invalidate()
                    SVProgressHUD.dismiss(withDelay: 1.0)
                }
            }
        }
        
    }
    
    func resetKpRoot(to viewController: UIViewController, animated: Bool = true) {
        // 获取当前的 SceneDelegate
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate,
              let window = delegate.window else {
            return
        }

        // 设置 rootViewController
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = viewController
            })
        } else {
            window.rootViewController = viewController
        }
        window.makeKeyAndVisible()
    }

}
