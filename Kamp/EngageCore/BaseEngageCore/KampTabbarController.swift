//
//  KampTabbarController.swift
//  Kamp
//
//  Created by Kamp on 2024/12/2.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class KampTabbarController: UITabBarController,UITabBarControllerDelegate {
    
    let tabbarItemsImages = ["KampLiveChannel","kpMonent","","kpPeerSpard","kpSkillShowRoom"]
    var kpMutableViewControllers = [UIViewController]()
    
    var kpAddButton = UIButton(type: .custom)
    
    let kpDisposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        configLattice()
    }
    
    private func configLattice(){
        
        
        let kampLiveChannelEngageCore = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KampLiveChannelEngageCore") as! KampLiveChannelEngageCore
        let momentsEngageCore = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MomentsEngageCore") as! MomentsEngageCore
        let centerENgageCore = UIViewController()
        let peerSparkEngageCore = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PeerSparkEngageCore") as! PeerSparkEngageCore
        let skillShowroomEngageCore = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SkillShowroomEngageCore") as! SkillShowroomEngageCore
        
        configNavigation(rootController: kampLiveChannelEngageCore, index: 0)
        configNavigation(rootController: momentsEngageCore, index: 1)
        configNavigation(rootController: centerENgageCore, index: 2)
        configNavigation(rootController: peerSparkEngageCore, index: 3)
        configNavigation(rootController: skillShowroomEngageCore, index: 4)
        
        self.viewControllers = kpMutableViewControllers
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = UIColor(red: 42/255.0, green: 37/255.0, blue: 55/255.0, alpha: 1)
        
        kpAddButton.setBackgroundImage(UIImage(named: "kpAddBar"), for: .normal)
        kpAddButton.rx.tap
            .subscribe { [weak self] _ in
                if let self = self {
                    if let kpCurrentEngageCore = self.viewControllers?[self.selectedIndex] as? UINavigationController{
                        let studySphereEngageCore = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudySphereEngageCore") as! StudySphereEngageCore
                        studySphereEngageCore.hidesBottomBarWhenPushed = true
                        kpCurrentEngageCore.pushViewController(studySphereEngageCore, animated: true)
                    }
                    
                }
            }
            .disposed(by: kpDisposeBag)
        tabBar.addSubview(kpAddButton)
        let kpAddButtonWidth = 46 * (UIScreen.main.bounds.size.width / 375)
        kpAddButton.frame = CGRectMake( UIScreen.main.bounds.size.width / 2 - kpAddButtonWidth / 2, -10, kpAddButtonWidth, kpAddButtonWidth)
    }
    
    private func configNavigation(rootController:UIViewController,index:Int){
        let kpNavigationEngageCore = UINavigationController(rootViewController: rootController)
        kpNavigationEngageCore.tabBarItem.title = nil
        if index != 2 {
            kpNavigationEngageCore.tabBarItem.image = UIImage(named: tabbarItemsImages[index])?.withRenderingMode(.alwaysOriginal)
            kpNavigationEngageCore.tabBarItem.selectedImage = UIImage(named: tabbarItemsImages[index] + "s")?.withRenderingMode(.alwaysOriginal)
        }else{
            kpNavigationEngageCore.tabBarItem.isEnabled = false
            kpNavigationEngageCore.tabBarItem.image = nil
        }
        
        kpNavigationEngageCore.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        kpMutableViewControllers.append(kpNavigationEngageCore)
        
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        UIView.setAnimationsEnabled(false)
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UIView.setAnimationsEnabled(true)
    }

}
