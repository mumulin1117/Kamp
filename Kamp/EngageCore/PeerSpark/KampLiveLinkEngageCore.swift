//
//  KampLiveLinkEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/6.
//

import UIKit
import AVFoundation
import SVProgressHUD
import RxSwift
import RxCocoa

class KampLiveLinkEngageCore: EngageCore {
    
    @IBOutlet weak var liverImageLattice: UIImageView!
    @IBOutlet weak var liverIsFollow: UIButton!
    @IBOutlet weak var liverName: UILabel!
    @IBOutlet weak var liverBackground: UIImageView!
    
    var kpEndDisposeBag = DisposeBag()
    
    fileprivate var kpWaitCount: Int = 15
    
    fileprivate var liveLinkMyPreviewLayer: AVCaptureVideoPreviewLayer?
    
    fileprivate let kpIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    @IBOutlet weak var myLocalLattice: UIView!
    
    fileprivate var kpLiveLinkSession: AVCaptureSession?

    @IBOutlet weak var messageLink: UILabel!
    
    var giftViewMaskControl:UIControl?
    
    var kampReportLattice:KampReportLattice?
    
    var selectKampLattice:KampReportOrBlockLattice?
    
    var kpLiveModel:KampLiveModel?
    
    var isKampReport = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        loadIndicator()
        kampCamerAuthorizationStatus()
        
        let messageLinkTap = UITapGestureRecognizer(target: self, action: #selector(messageLinkTapRalay))
        messageLink.isUserInteractionEnabled = true
        messageLink.addGestureRecognizer(messageLinkTap)
        
        if let kpLiveModel = self.kpLiveModel {
            liverImageLattice.image = UIImage(named: kpLiveModel.kampLiverIdentif)
            liverBackground.image = UIImage(named: kpLiveModel.kampLiverIdentif)
            liverName.text = kpLiveModel.kampLiver
            
            if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.liverKpFollow.title + kpLiveModel.kampLiveId){
                liverIsFollow.isSelected = true
            }else{
                liverIsFollow.isSelected = false
            }
        }
    }
    
    @objc fileprivate func messageLinkTapRalay(){
        SVProgressHUD.showInfo(withStatus: process("Pplserazscek jWaazist"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.kampEndSession()
    }
    
    fileprivate func startkpTimer(){
        Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { self.kpWaitCount - $0 }
            .take(while: { $0 >= 0 })
            .subscribe(onNext: { _ in
                
            }, onCompleted: {
                let kpTipString = process("Tphaec coetahtecrt epiasrutnyl iimst wnjokte downclciinie")
                if kpTipString.count > 0 {
                    SVProgressHUD.showInfo(withStatus: kpTipString)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.kampEndSession()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
            .disposed(by: kpEndDisposeBag)
    }
    
    fileprivate func switchCameraKamp() {
        guard let kpLiveLinkSession = kpLiveLinkSession else { return }
        var kampSessionTag = 2001
        kpLiveLinkSession.beginConfiguration()
        defer { kpLiveLinkSession.commitConfiguration() }
        kampSessionTag = kampSessionTag * 10
        
        if kampSessionTag > 0 ,let kpNowInput = kpLiveLinkSession.inputs.first as? AVCaptureDeviceInput{
            let kpNowPosition = kpNowInput.device.position
            kampSessionTag = kampSessionTag * 10
            kpLiveLinkSession.removeInput(kpNowInput)
            
            if kampSessionTag > 10 {
                var newKpPosition:AVCaptureDevice.Position = .front
                if  kpNowPosition == .back {
                    newKpPosition = .front
                }else{
                    newKpPosition = .back
                }
                
                if  let newDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: newKpPosition).devices.first,
                    let newInput = try? AVCaptureDeviceInput(device: newDevice) {
                    
                    if kpLiveLinkSession.canAddInput(newInput) {
                        kpLiveLinkSession.addInput(newInput)
                    }
                }
            }
        }
        kampSessionTag = 0
    }
    
    fileprivate func loadIndicator() {
        if kpWaitCount > 0 {
            kpIndicator.center = view.center
            view.addSubview(kpIndicator)
            kpIndicator.startAnimating()
        }
        
    }
    
    @IBAction func stopVoice(_ sender: UIButton) {
        sender.isSelected.toggle()
        stopKpVoice(sender.isSelected)
    }
    
    
    @IBAction func switchKampInputCamer(_ sender: Any) {
        switchCameraKamp()
    }
    
    @IBAction func reportOrBlockRelay(_ sender: Any) {
        isKampReport = 2
        if giftViewMaskControl == nil {
            giftViewMaskControl = UIControl()
            giftViewMaskControl!.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            giftViewMaskControl!.addTarget(self, action: #selector(giftViewMaskControlClick), for: .touchUpInside)
        }
        
        if selectKampLattice == nil {
            selectKampLattice = Bundle.main.loadNibNamed("KampReportOrBlockLattice", owner: nil)?.last as? KampReportOrBlockLattice
            selectKampLattice?.reportOrBlockCallBack = { [weak self] kampFlag in
                if let self = self {
                    self.giftViewMaskControlClick()
                    if kampFlag < 0 {
                        return
                    }
                    
                    if kampFlag == 0 {
                        SVProgressHUD.show()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            SVProgressHUD.dismiss()
                            SVProgressHUD.showInfo(withStatus: process("Bilgoccckiexd"))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                if let kampPageModel = self.kpLiveModel{
                                    KampHelper.sharedHelper.currentMMKV?.set(kampPageModel.kampLiveId, forKey: LiveOperation.kampUserBlock.title + kampPageModel.kampLiverIdentif)
                                    NotificationCenter.default.post(name: NSNotification.Name("peerSparkBlock"), object: nil)
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        }
                    }else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.kpShowBlockOrReportLattice()
                        }
                    }
                }
            }
        }
        
        self.view.addSubview(giftViewMaskControl!)
        giftViewMaskControl!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.selectKampLattice!)
        self.selectKampLattice!.snp.removeConstraints()
        selectKampLattice!.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(270)
            make.bottom.equalToSuperview().offset(270)
        }
        self.view.layoutIfNeeded()
        
        selectKampLattice!.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func kpShowBlockOrReportLattice(){
        isKampReport = 1
        if giftViewMaskControl == nil {
            giftViewMaskControl = UIControl()
            giftViewMaskControl!.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            giftViewMaskControl!.addTarget(self, action: #selector(giftViewMaskControlClick), for: .touchUpInside)
        }
        
        if kampReportLattice == nil {
            kampReportLattice = Bundle.main.loadNibNamed("KampReportLattice", owner: nil)?.last as? KampReportLattice
            kampReportLattice?.configLattice()
            kampReportLattice?.operationButtonCallBack = { [weak self] kampFlag in
                if let self = self {
                    
                    if kampFlag == 1 {
                        
                    }
                    self.giftViewMaskControlClick()
                }
            }
        }
        
        self.view.addSubview(giftViewMaskControl!)
        giftViewMaskControl!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.kampReportLattice!)
        self.kampReportLattice!.snp.removeConstraints()
        kampReportLattice!.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(570)
            make.bottom.equalToSuperview().offset(570)
        }
        self.view.layoutIfNeeded()
        
        kampReportLattice!.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func giftViewMaskControlClick(){
        
        if isKampReport == 1 {
            kampReportLattice?.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(570)
            }
        }else if isKampReport == 2 {
            selectKampLattice?.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(270)
            }
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.giftViewMaskControl?.removeFromSuperview()
            self.kampReportLattice?.removeFromSuperview()
            self.selectKampLattice?.removeFromSuperview()
        }
    }
    
    @IBAction func stopLiveLink(_ sender: Any) {
        kampEndSession()
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func stopCameraKampPreviewLoad(_ shouldKpChange: Bool) {
        
        var loadKpStatus = 0
        
        if shouldKpChange {
            loadKpStatus = 1
            kpLiveLinkSession?.inputs.forEach { kpLiveLinkSession?.removeInput($0) }
            if loadKpStatus != 0 {
                liveLinkMyPreviewLayer?.isHidden = true
            }
        } else {
            loadKpStatus = 2
            if loadKpStatus > 0 {
                guard let session = kpLiveLinkSession,
                      let device = AVCaptureDevice.default(for: .video),
                      let input = try? AVCaptureDeviceInput(device: device) else { return }
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                liveLinkMyPreviewLayer?.isHidden = false
                loadKpStatus = 3
            }
            
            if loadKpStatus > 1 {
                loadKpStatus = loadKpStatus * 2
            }
        }
    }
    
    fileprivate func kampCamerAuthorizationStatus() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            getKampCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    DispatchQueue.main.async {
                        self.getKampCaptureSession()
                    }
                }
            }
        default:
            break
        }
    }
    
    fileprivate func stopKpVoice(_ isStop: Bool) {
        
        var loadKpStatus = 0
        
        if let session = kpLiveLinkSession {
            loadKpStatus = 1
            if isStop && loadKpStatus > 0 {
                session.inputs.compactMap { $0 as? AVCaptureDeviceInput }.filter { $0.device.hasMediaType(.audio) }.forEach { session.removeInput($0) }
            } else {
                if loadKpStatus > 0 ,let device = AVCaptureDevice.default(for: .audio),let input = try? AVCaptureDeviceInput(device: device){
                    if isStop == false {
                        if session.canAddInput(input) {
                            session.addInput(input)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func loadMyPreviewLayer() {
        
        if liveLinkMyPreviewLayer == nil {
            let cornerRadius = 16.0
            liveLinkMyPreviewLayer = AVCaptureVideoPreviewLayer(session: kpLiveLinkSession!)
            liveLinkMyPreviewLayer?.videoGravity = .resizeAspectFill
            liveLinkMyPreviewLayer?.cornerRadius = cornerRadius
            liveLinkMyPreviewLayer?.masksToBounds = true
            
            if cornerRadius > 0 ,liveLinkMyPreviewLayer != nil {
                myLocalLattice.layer.addSublayer(liveLinkMyPreviewLayer!)
                
                DispatchQueue.global().async { [weak self] in
                    self?.kpLiveLinkSession?.startRunning()
                }
                
                startkpTimer()
            }
        }
    }
    
    
    fileprivate func kampEndSession() {
        
        var kpDidEnd = "kpDidEnd"
        kpEndDisposeBag = DisposeBag()
        kpDidEnd = "kpDidEnd"
        if kpDidEnd.count != 0 {
            kpDidEnd = "kpDidRemove"
            kpLiveLinkSession?.stopRunning()
            
            kpLiveLinkSession?.inputs.forEach {
                kpLiveLinkSession?.removeInput($0)
            }
            
            kpLiveLinkSession?.outputs.forEach {
                kpLiveLinkSession?.removeOutput($0)
            }
            
            liveLinkMyPreviewLayer?.removeFromSuperlayer()
            let kpDidEndCount = kpDidEnd.count
            let kpArrayDidEnd = Array(kpDidEnd)
            if kpDidEndCount == kpArrayDidEnd.count  {
                liveLinkMyPreviewLayer = nil
                kpLiveLinkSession = nil
            }
        }
    }
    
    
    
    fileprivate func getKampCaptureSession() {
        guard kpLiveLinkSession == nil else { return }
        kpLiveLinkSession = AVCaptureSession()
        kpLiveLinkSession?.sessionPreset = .high
        
        if kpLiveLinkSession?.sessionPreset == .high,let loadCamera = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices.first,
           let kpCamerInput = try? AVCaptureDeviceInput(device: loadCamera),
           kpLiveLinkSession?.canAddInput(kpCamerInput) == true {
            
            kpLiveLinkSession?.addInput(kpCamerInput)
            loadMyPreviewLayer()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if liveLinkMyPreviewLayer != nil {
            liveLinkMyPreviewLayer!.frame = myLocalLattice.bounds
        }
    }
    
}
