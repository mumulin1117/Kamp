//
//  KpUserAgreementEngateCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/26.
//

import UIKit
import WebKit
import SnapKit
import SVProgressHUD

class KpUserAgreementEngateCore: EngageCore ,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler{
    
    var kpUserAgreement = ""
    
    var kpIdeaCascade:WKWebView?
    
    var kpLoadState = 0
    
    var kpIsUserAgreement = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        KampHelper.sharedHelper.chronicleSpectrum()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configLattice()
    }
    
    private func updateLatticeArea(make:ConstraintMaker,latticeTag:Int){
        if latticeTag == 100 {
            make.edges.equalToSuperview()
            return
        }
        
        if latticeTag == 101 {
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
    }
    
    
    
    private func configLattice(){
        
        let ideaCascadeKp = UIImageView(image: UIImage(named: "kpLaunch"))
        view.addSubview(ideaCascadeKp)
        ideaCascadeKp.snp.makeConstraints { make in
            self.updateLatticeArea(make: make,latticeTag: 100)
        }
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        if kpIdeaCascade == nil {
            kpLoadState = 1
            let kpIdeaCasc = WKWebViewConfiguration()
            kpIdeaCasc.mediaTypesRequiringUserActionForPlayback = []
            kpIdeaCasc.allowsAirPlayForMediaPlayback = false
            kpIdeaCasc.preferences.javaScriptCanOpenWindowsAutomatically = true
            kpIdeaCasc.allowsInlineMediaPlayback = true
            self.studySphere(kpIdeaCasc: kpIdeaCasc,kpIdeaCascLoadTag: 101)
        }
    }
    
    func studySphere(kpIdeaCasc:WKWebViewConfiguration, kpIdeaCascLoadTag:Int){
        
        if kpIdeaCascLoadTag % 2 != 0 {
            kpIdeaCascade = WKWebView(frame: .zero, configuration: kpIdeaCasc)
            if kpIdeaCascade != nil && kpLoadState >= 1 {
                kpLoadState = 2
                kpIdeaCascade!.uiDelegate = self
                kpIdeaCascade!.navigationDelegate = self
                kpIdeaCascade!.isHidden = true
                configIdeaCascade()
                if kpLoadState >= 0 {
                    view.addSubview(kpIdeaCascade!)
                    kpIdeaCascade!.snp.makeConstraints { make in
                        self.updateLatticeArea(make: make,latticeTag: kpIdeaCascLoadTag)
                    }
                }
                
                if kpUserAgreement.isEmpty == false {
                    if let kpUserAgreementAddress = URL(string: kpUserAgreement) {
                        SVProgressHUD.show()
                        kpIdeaCascade?.load(URLRequest(url: kpUserAgreementAddress))
                    }
                }
                
            }
        }
        
    }
    
    private func configIdeaCascade(){
        kpLoadState = 3
        kpIdeaCascade!.scrollView.alwaysBounceVertical = false
        kpIdeaCascade!.scrollView.contentInsetAdjustmentBehavior = .never
        kpIdeaCascade!.allowsBackForwardNavigationGestures = true
    }
    
    private func configIdeaCascadeControl(kpIdeaState:Bool){
        if kpIdeaCascade != nil {
            let ideaCascadeControl = kpIdeaCascade!.configuration.userContentController
            if kpLoadState > 0 {
                if kpIdeaState {
                    ideaCascadeControl.add(self, name: process("Psany"))
                    ideaCascadeControl.add(self, name: process("Cilbowsoe"))
                }else{
                    ideaCascadeControl.removeScriptMessageHandler(forName: process("Psany"))
                    ideaCascadeControl.removeScriptMessageHandler(forName: process("Cilbowsoe"))
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configIdeaCascadeControl(kpIdeaState: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configIdeaCascadeControl(kpIdeaState: false)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        var createKpState = 0
        
        if navigationAction.targetFrame == nil {
            createKpState = createKpState + 10
        }else{
            createKpState = createKpState + 20
        }
        
        if createKpState % 2 == 0  {
            let kpTargetFrame = navigationAction.targetFrame == nil
            let kpMainFrame = navigationAction.targetFrame?.isMainFrame == false
            if kpTargetFrame || kpMainFrame {
                if let navigationActionRequestUrl = navigationAction.request.url{
                    UIApplication.shared.open(navigationActionRequestUrl)
                }
            }
        }
        
        return nil
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        if kpIdeaCascade != nil {
            webView.isHidden = false
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        DispatchQueue.main.async {
            var kpReceiveState = 0
            let messageKpName = message.name
            if messageKpName.count != 0 {
                kpReceiveState = 1
            }
            
            if kpReceiveState != 0 {
                if messageKpName == process("Psany"), let messageKpBody = message.body as? String {
                    kpReceiveState = 2
                    
                    if kpReceiveState % 2 == 0 {
                        TalentHive.shared.peerKpSyncCallBack = {(kpError,peerSyncTransActionKpId,kampIdeas) in
                            DispatchQueue.main.async {
                                if kampIdeas?.count ?? 0 > 0 {
                                    let friendFusion = peerSyncTransActionKpId ?? ""
                                    
                                    let edutainment = kampIdeas ?? ""
                                    
                                    if friendFusion.count > 0 && edutainment.count > 0{
                                        KampHelper.sharedHelper.curateMultiChannelViewingExperience(curate: friendFusion, multiChannel: edutainment,experience: messageKpBody,verifyState: 200,showLoad: false)
                                    }
                                    
                                    
                                }else{
                                    SVProgressHUD.dismiss()
                                    SVProgressHUD.showInfo(withStatus: kpError?.localizedDescription)
                                }
                            }
                        }
                        
                        
                    }
                    SVProgressHUD.show()
                    KampHelper.sharedHelper.trackViewerEngagementAndOptimizeContent(engagement: .initiatedCheckout, optimizeContent: messageKpBody,modifiCount:10)
                    TalentHive.shared.connectWithGlobalCohortOfStudents(peerIdentifier: messageKpBody)
                    
                    return
                }
                
                if message.name == process("Cilbowsoe"){
                    
                    if self.kpLoadState != 0 && self.kpIdeaCascade != nil {
                        let userdefaultKey = "kpUserIdentifier"
                        if userdefaultKey.count + self.kpLoadState > 0 {
                            UserDefaults.standard.removeObject(forKey: userdefaultKey)
                            UserDefaults.standard.synchronize()
                            self.kpLoadState = 1
                            if self.kpLoadState > 0 {
                                KampHelper.sharedHelper.kpUserIdentifier = ""
                                if self.kpIsUserAgreement == 1 {
                                    KampHelper.sharedHelper.networkStateSignal.onNext(self.kpLoadState)
                                }
                                self.navigationController?.popViewController(animated: false)
                            }
                        }
                    }
                    return
                }
            }
        }
    }
}
