//
//  KampPolicyLattice.swift
//  Kamp
//
//  Created by Kamp on 2024/12/5.
//

import UIKit
import WebKit
import SVProgressHUD

class KampPolicyLattice: UIView,WKNavigationDelegate {
    
    var kampSubButtonRelay:(()->())?

    @IBOutlet weak var policyWkLattice: WKWebView!
    @IBOutlet weak var kampTitelLattice: UILabel!
    @IBOutlet weak var leftKampPolicy: UILabel!
    @IBOutlet weak var rightKampPolicy: UILabel!
    
    var kampLoadUrl:String?
    
    public func configLattice(){
        
        policyWkLattice.navigationDelegate = self
        
        kampTitelLattice.text = process("EzUlLlA")
        var policyAttribute = NSAttributedString(string: process("Thekrnmxsy eotfe aUhsae"), attributes: [.underlineStyle:NSUnderlineStyle.single.rawValue])
        leftKampPolicy.attributedText = policyAttribute
        leftKampPolicy.tag = 1000
        
        policyAttribute = NSAttributedString(string: process("Portidvtaucgyh nPromlqilczy"), attributes: [.underlineStyle:NSUnderlineStyle.single.rawValue])
        rightKampPolicy.attributedText = policyAttribute
        rightKampPolicy.tag = 1001
        
        leftKampPolicy.isUserInteractionEnabled = true
        rightKampPolicy.isUserInteractionEnabled = true
        
        let userAttributeTap = UITapGestureRecognizer(target: self, action: #selector(policyAttributeTapRelay))
        let policyAttributeTap = UITapGestureRecognizer(target: self, action: #selector(policyAttributeTapRelay))
        leftKampPolicy.addGestureRecognizer(userAttributeTap)
        rightKampPolicy.addGestureRecognizer(policyAttributeTap)
    }
    
    @objc func policyAttributeTapRelay(sender:UITapGestureRecognizer){
        if sender.view?.tag == 1000 {
            if kampLoadUrl?.contains("users") == true {
                return
            }
            loadKampPolicy(url:"https://cool-hummingbird-4bf5e6.netlify.app/users")
        }else{
            if kampLoadUrl?.contains("privacy") == true {
                return
            }
            loadKampPolicy(url:"https://cool-hummingbird-4bf5e6.netlify.app/privacy")
        }
    }
    
    public func loadKampPolicy(url:String){
        if let loadKampUrl = URL(string: url) {
            kampLoadUrl = url
            SVProgressHUD.show()
            policyWkLattice.isHidden = true
            policyWkLattice.load(URLRequest(url: loadKampUrl))
        }
    }

    @IBAction func buttonRelay(_ sender: Any) {
        kampSubButtonRelay?()
        policyWkLattice.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        policyWkLattice.isHidden = false
        SVProgressHUD.dismiss()
    }
}
