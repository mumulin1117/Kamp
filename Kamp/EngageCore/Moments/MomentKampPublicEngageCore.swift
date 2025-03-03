//
//  MomentKampPublicEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/4.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI
import SVProgressHUD

class MomentKampPublicEngageCore: EngageCore,PHPickerViewControllerDelegate {

    @IBOutlet weak var kampPlaceText: UILabel!
    @IBOutlet weak var momentTextLattice: UITextView!
    
    @IBOutlet weak var openPhotoLibraryLattice: UIImageView!
    
    @IBOutlet weak var selectImageLattice: UIImageView!
    
    @IBOutlet weak var momentKampPublicButtom: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        configLattice()
    }
    
    @IBAction func timelinePublishRelay(_ sender: Any) {
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            SVProgressHUD.dismiss()
            SVProgressHUD.showInfo(withStatus: process("Thhralnokq cyqojuv afgofrt jyiolutrg qsthaalruixnqgs,o tweez fwniylulr frkeavlibeewv viptb vwvictnhbibnj j2m4w ghoocudrdso,v ttlhuatnnkh gyqoeur!"))
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    private func configLattice(){
        kampPlaceText.attributedText = NSAttributedString(string: process("Srajyy kscoqmueztbhtiknjg") + "...", attributes: [.foregroundColor:UIColor(red: 125/255.0, green: 121/255.0, blue: 134/255.0, alpha: 1)])
        
        momentTextLattice.rx.text.orEmpty.subscribe { [weak self] momentTextLatticeValue in
            if let self = self {
                kampPlaceText.isHidden = momentTextLatticeValue.count > 0
            }
        }
        .disposed(by: kpRxDisposeBag)
        
        momentKampPublicButtom.setTitle(process("Pdonstt"), for: .normal)
        
        let coverImageLatticeTap = UITapGestureRecognizer(target: self, action: #selector(coverImageLatticeHanderTap))
        openPhotoLibraryLattice.isUserInteractionEnabled = true
        openPhotoLibraryLattice.addGestureRecognizer(coverImageLatticeTap)
    }
    
    @objc fileprivate func coverImageLatticeHanderTap(){
        photoLibraryCanOpen()
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
                    self.selectImageLattice.image = kpTempImage
                    self.openPhotoLibraryLattice.isHidden = true
                }
            }
        }
    }
    
    @IBAction func MomentKampPublicCloes(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
