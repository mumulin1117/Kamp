//
//  EngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/2.
//

import UIKit
import RxSwift
import RxCocoa

class EngageCore: UIViewController ,UIGestureRecognizerDelegate{
    
    let kpRxDisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
       
        var kpATitleStyle: [NSAttributedString.Key: Any]? = nil
        
        if kpATitleStyle == nil {
            kpATitleStyle = [.foregroundColor: UIColor.white,.font: UIFont.systemFont(ofSize: 18, weight: .bold)]
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.backgroundColor = .clear
            navigationBarAppearance.configureWithTransparentBackground()
            navigationBarAppearance.shadowColor = .clear
            navigationBarAppearance.titleTextAttributes = kpATitleStyle!
            
            if let navigationController = self.navigationController {
                navigationController.navigationBar.standardAppearance = navigationBarAppearance
                navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
                navigationController.navigationBar.compactAppearance = navigationBarAppearance
            }
            
            
            if let navigationController = self.navigationController,navigationController.viewControllers.count > 1 {
                let kpNavigationBackButton = UIButton(type: .custom)
                let kpNavigationBackButtonImage = UIImage(named: "kpNavigationBackButton")
                kpNavigationBackButton.setImage(kpNavigationBackButtonImage, for: .normal)
                let kpNavigationBackButtonWidth = 30.0
                kpNavigationBackButton.frame = CGRect(x: 0, y: 0, width: kpNavigationBackButtonWidth, height: kpNavigationBackButtonWidth)
                kpNavigationBackButton.contentHorizontalAlignment = .left
                kpNavigationBackButton.rx.tap.subscribe {[weak self] _ in
                    self?.kpNavigationBackButtonRelay()
                }.disposed(by: kpRxDisposeBag)
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: kpNavigationBackButton)
            }
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.view.backgroundColor = UIColor(red: 0.14, green: 0.11, blue: 0.2, alpha: 1)
        
    }
    
    func kpNavigationBackButtonRelay(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let navigationController = self.navigationController {
            navigationController.interactivePopGestureRecognizer?.delegate = self
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        var shouldBegin = true
        if let navigationController = self.navigationController{
            shouldBegin = navigationController.viewControllers.count > 1
        }
        
        return shouldBegin
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
