//
//  StudySphereEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/2.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

class StudySphereEngageCore: EngageCore,PHPickerViewControllerDelegate {

    @IBOutlet weak var addkpConverImageLattice: UIImageView!
    @IBOutlet weak var naemKpFiled: UITextField!
    @IBOutlet weak var selectKpChannles: UILabel!
    @IBOutlet weak var channleKpView: UIView!
    
    var liveRoomName:String?
    
    var liveChannel:String?{
        didSet{
            selectKpChannles.text = liveChannel
            selectKpChannles.textColor = .white
        }
    }
    
    
    @IBOutlet weak var coverImageLattice: UIImageView!
    var selectChannerKpLattice:SelectChannelLattice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view
        configLattice()
    }
    
    func configLattice(){
        naemKpFiled.attributedPlaceholder = NSAttributedString(string: process("Iyndpbuqtw kluinvseo zrxouonmo bneaymce"), attributes: [.foregroundColor:UIColor.white.withAlphaComponent(0.5)])
        
        let channleKpViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(channleKpViewTapGestureRecognizerHanderTap))
        channleKpView.addGestureRecognizer(channleKpViewTapGestureRecognizer)
        
        let coverImageLatticeTap = UITapGestureRecognizer(target: self, action: #selector(coverImageLatticeHanderTap))
        addkpConverImageLattice.isUserInteractionEnabled = true
        addkpConverImageLattice.addGestureRecognizer(coverImageLatticeTap)
        naemKpFiled.rx.text.orEmpty
            .subscribe { [weak self] inputKpValue in
                guard let self = self else {return}
                self.liveRoomName = inputKpValue
            }
            .disposed(by: kpRxDisposeBag)
    }
    
    @objc private func coverImageLatticeHanderTap(){
        photoLibraryCanOpen()
    }
    
    private func selectChannerKpLatticeDismis(){
        selectChannerKpLattice?.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(570)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.selectChannerKpLattice?.removeFromSuperview()
        }
    }
    
    @objc private func channleKpViewTapGestureRecognizerHanderTap(){
        if selectChannerKpLattice == nil {
            selectChannerKpLattice = Bundle.main.loadNibNamed("SelectChannelLattice", owner: nil)?.last as? SelectChannelLattice
            
            selectChannerKpLattice?.selectChannelCloseKp.rx.tap.subscribe(onNext: { [weak self] _ in
                if let self = self{
                    self.selectChannerKpLatticeDismis()
                }
            })
            .disposed(by: kpRxDisposeBag)
            
            selectChannerKpLattice?.selectChannelKpConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
                if let self = self{
                    self.liveChannel = self.selectChannerKpLattice!.liveChannel
                    self.selectChannerKpLatticeDismis()
                }
            })
            .disposed(by: kpRxDisposeBag)
        }
        
        self.view.addSubview(self.selectChannerKpLattice!)
        self.selectChannerKpLattice!.snp.removeConstraints()
        selectChannerKpLattice!.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(570)
            make.bottom.equalToSuperview().offset(570)
        }
        self.view.layoutIfNeeded()
        
        selectChannerKpLattice!.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func navigationBarKpBakc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startkpLive(_ sender: Any) {
        
        if let _ = liveRoomName , let _ = liveChannel , let _ = coverImageLattice.image{
            self.performSegue(withIdentifier: "KampLivIngEngageCore", sender: self)
        }
    }
    
    
    fileprivate func photoLibraryCanOpen() {
        let permission = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch permission {
            
        case .authorized, .limited:
            self.openPhotoLibrary()
            
        case .restricted, .denied:
            self.noPermissionAlert()
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newState in
                
                if newState == .authorized {
                    self.openPhotoLibrary()
                }
            }
        
        @unknown default:break
        }
    }
    
    // 展示相册选择器
    fileprivate func openPhotoLibrary() {
        let selectionLimit = 1
        var kpConfig = PHPickerConfiguration()
        kpConfig.filter = .images
        kpConfig.selectionLimit = selectionLimit
        
        if selectionLimit > 0 {
            let kaImagePicker = PHPickerViewController(configuration: kpConfig)
            
            kaImagePicker.delegate = self
            
            self.present(kaImagePicker, animated: true, completion: nil)
        }
    }
    
    fileprivate func noPermissionAlert() {
        
        
        KampHelper.showKampAlert(on: self, message: process("Pelwedaqsgey reunsahbolieu dpmhsowtwoy ulcizbfruaarlyf uancnceemsfsn kiqnx zscejtqtzidnlgjsy jtyoj xsuexlveucjto uphhaooteogs"),cancelTitle: "Ok",confirmTitle:process("Gmof jtbos asjeptztxiendgks")) {
            let kpUrlString = UIApplication.openSettingsURLString
            if kpUrlString.count > 0,let kpSetting = URL(string: kpUrlString){
                UIApplication.shared.open(kpSetting)
            }
        }
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        picker.dismiss(animated: true, completion: nil)
        
        guard let picketResult = results.first else { return }
        
        picketResult.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            guard let self = self else {return}
            if let kpTempImage = object as? UIImage {
                DispatchQueue.main.async {
                    self.coverImageLattice.image = kpTempImage
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let kampSegIdentifier = segue.identifier
        if kampSegIdentifier?.isEmpty == false {
            
            if kampSegIdentifier == "KampLivIngEngageCore" {
                let campLivIngEngageCore = segue.destination as! KampLivIngEngageCore
                if let livekpModel = KampHelper.sharedHelper.kampLoginUser.value {
                    campLivIngEngageCore.liveCoverImage = self.coverImageLattice.image
                    livekpModel.kampLiveId = UUID().uuidString
                    campLivIngEngageCore.kampLiveModel.accept(livekpModel)
                }
            }
        }
        
    }

}
