//
//  SceneDelegate.swift
//  Kamp
//
//  Created by Kamp on 2024/12/2.
//

import UIKit
import SVProgressHUD
import IQKeyboardManagerSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

