//
//  UserAgreementEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/11.
//

import UIKit
import WebKit
import SVProgressHUD

class UserAgreementEngageCore: EngageCore ,WKUIDelegate,WKNavigationDelegate{
    
    var kampPolicyLattice:WKWebView!
    
    var kampInfo = ""
    
    var isHud = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.view.backgroundColor = UIColor(red: 0.14, green: 0.11, blue: 0.2, alpha: 1)
        configLattice()
        loadInfo()
    }
    
    fileprivate func configLattice(){
        kampPolicyLattice = WKWebView()
        kampPolicyLattice.uiDelegate = self
        kampPolicyLattice.navigationDelegate = self
        self.view.addSubview(kampPolicyLattice)
        kampPolicyLattice.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset((self.navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.size.height)
        }
    }
    
    fileprivate func loadInfo(){
        if let infoUrl = URL(string: kampInfo) {
            SVProgressHUD.show()
            kampPolicyLattice.load(URLRequest(url: infoUrl))
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
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
