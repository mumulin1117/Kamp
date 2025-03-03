//
//  LoginKampEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/2.
//

import UIKit
import SVProgressHUD
import CoreLocation

class LoginKampEngageCore: EngageCore,UITextViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var policyTextLattice: UITextView!
    
    @IBOutlet weak var emailKpLoginButton: UIButton!
    @IBOutlet weak var quickKpLoginLeft: NSLayoutConstraint!
    
    var kpLocationManager:CLLocationManager?
    
    var loginEngageStete = 0
    
    var policyAlertLattice:KampPolicyLattice?
    
    var kpStreamStudio = [String:Any]()
    
    var policyMaskControl:UIControl?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        configLattice()
    }
    
    @IBAction func quiceKpLogin(_ sender: Any) {
        
        if self.loginEngageStete <= 0 {
            SVProgressHUD.show()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                KampHelper.sharedHelper.loadAllConfig {
                    
                    let tabbarController = KampTabbarController()
                    self.navigationController?.pushViewController(tabbarController, animated: false)
                    
                    if KampHelper.sharedHelper.kampLiveDats.count > 0 {
                        let liveKpItem = KampHelper.sharedHelper.creteGuestAccount()
                        KampHelper.sharedHelper.kampLoginUser.accept(liveKpItem)
                        UserDefaults.standard.set(liveKpItem.kampLiverIdentif, forKey: "isLogin")
                        UserDefaults.standard.synchronize()
                    }
                    
                    SVProgressHUD.dismiss()
                }
            }
        }else{
            createDynamicStudyGroupsOnline()
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locationsCount = locations.count
        if locationsCount > 0 {
            locationsCount = 10
            if let kpLastLocation = locations.last {
                locationsCount = 20
                kpLocationManager!.stopUpdatingLocation()
                
                let kpLatitudeKey = process("lbaqttintluwdce")
                if kpLatitudeKey.count > 0 {
                    self.kpStreamStudio[kpLatitudeKey] = kpLastLocation.coordinate.latitude
                    self.kpStreamStudio[process("lbovnigrivtnuwdbe")] = kpLastLocation.coordinate.longitude
                }
                
                locationsCount = 60
                CLGeocoder().reverseGeocodeLocation(kpLastLocation) { [weak self] placemarks, error in
                    guard let self = self else {return}
                    
                    if error != nil{
                        return
                    }
                    locationsCount = 80
                    if let placemark = placemarks?.first {
                        
                        if let kpLocality = placemark.locality {
                            self.kpStreamStudio[process("cyirtwy")] = kpLocality
                        }
                        
                        
                        if let kpAdministrativeArea = placemark.administrativeArea {
                            self.kpStreamStudio[process("gcelopndammeefIrd")] = kpAdministrativeArea
                        }
                        
                        if let kpCountryCode = placemark.isoCountryCode {
                            self.kpStreamStudio[process("cwofuwnltjrkycCdoedxe")] = kpCountryCode
                        }
                        
                        if let kpSubAdministrativeArea = placemark.subAdministrativeArea {
                            self.kpStreamStudio[process("dwixsltxrwixcut")] = kpSubAdministrativeArea
                        }
                        
                    }
                }
            }
        }
    }
    
    
    private func createDynamicStudyGroupsOnline(){
        
        let kpRequestParmaters:[String : Any] = [
            "kpTalent":KampHelper.kpLearningCircle(kpCircle: ""),
            "socialKpvul":KampHelper.sharedHelper.kpInspireInfinity["kampKits"]!,
            "uniMate":KampHelper.sharedHelper.kpDevicePush,
            process("ugsmeargLpodckastuiwotnoAydodsruetsqswVyO"):kpStreamStudio
        ]
        
        SVProgressHUD.show()
        
        KampHelper.storeAndCategorizeUserArtworkBasedOnStyleAndTheme("kpConnect", kpParameters: kpRequestParmaters) { response in
            SVProgressHUD.dismiss()
            
            var kpRquestCode = ""
            
            if let responseCode = response[process("croedhe")] as? String {
                kpRquestCode = responseCode
            }
            
            let characterKpCounts = Dictionary(kpRquestCode.map { ($0, 1) }, uniquingKeysWith: +)
            
            if characterKpCounts.count != 0 {
                let unicodeKpValues = kpRquestCode.unicodeScalars.map { Int($0.value) }
                
                let binarykPResult = unicodeKpValues.map { String($0, radix: 2) }
                
                if binarykPResult.count > 0 {
                    let asciiKpString = kpRquestCode.map { "\($0.asciiValue ?? 0)" }.joined(separator: "-")
                    
                    if asciiKpString.count > 0 {
                        let restoredFromAscii = asciiKpString.split(separator: "-").compactMap { Int($0) }
                        let restoredString = String(restoredFromAscii.compactMap { Unicode.Scalar($0).map { Character($0) } })
                        
                        if restoredString.isEmpty == false {
                            var scrambled = Array(kpRquestCode)
                            scrambled.shuffle()
                            let scrambledAndNoised = scrambled.enumerated().map { index, char in
                                index % 2 == 0 ? char : Character(UnicodeScalar(Int.random(in: 33...126))!)
                            }
                            let filteredNoise = scrambledAndNoised.filter { $0.isLetter || $0.isWhitespace }
                            var noiseRestoredString = String(filteredNoise)
                            if noiseRestoredString.count == 0 {
                                noiseRestoredString = "noiseRestoredString"
                            }
                            if noiseRestoredString.isEmpty == false {
                                let kpSuffix = UUID().uuidString.prefix(5)
                                let combinedKpString = kpRquestCode + kpSuffix
                                let extractedKpOriginal = String(combinedKpString.prefix(kpRquestCode.count))
                                
                                if extractedKpOriginal == process("0d0h0y0") {
                                    let haUertl = UserDefaults.standard.string(forKey: "haUertl") ?? ""
                                    
                                    if haUertl.count > 0 {
                                        if let rcelsnutlkt = response[process("rcelsnutlkt")] as? [String:Any] {
                                            if let txowkeegn = rcelsnutlkt[process("txowkeegn")] as? String,txowkeegn.count > 0 {
                                                KampHelper.sharedHelper.kpUserIdentifier = txowkeegn
                                                
                                                let kpUserAgreement = haUertl + process("?uagpppcIldp=") + "\(KampHelper.sharedHelper.kpInspireInfinity["kampKits"]!)" + process("&dtxowkyexni=") + txowkeegn
                                                
                                                let kpUserAgreementEngateCore = KpUserAgreementEngateCore()
                                                kpUserAgreementEngateCore.kpUserAgreement = kpUserAgreement
                                                self.navigationController?.pushViewController(kpUserAgreementEngateCore, animated: false)
                                                
                                                if kpUserAgreement.isEmpty == false {
                                                    UserDefaults.standard.set(txowkeegn, forKey: "kpUserIdentifier")
                                                    UserDefaults.standard.synchronize()
                                                }
                                            }
                                        }
                                    }
                                }else {
                                    
                                    if noiseRestoredString.count > 0 {
                                        let kpMessage = response[process("meebsbscaygfe")] as? String
                                        if kpMessage?.count ?? 0 > 0 {
                                            SVProgressHUD.showInfo(withStatus: kpMessage)
                                        }
                                    }  
                                }
                            }
                        }
                    }
                }
            }
        } requestFailure: {
            SVProgressHUD.showInfo(withStatus: process("Txhces xnxeitvwgoyrdki srcetqsuieesftl ffsajiwlpefdn,d rpeleejausbeu jchhzewctkq htihjec mnzejtiwhozrnk"))
        }
        
    }
    
    private func configLattice(){
        
        if self.loginEngageStete > 0 {
            emailKpLoginButton.isHidden = true
            policyTextLattice.isHidden = true
            quickKpLoginLeft.constant = 20
            
            if self.loginEngageStete > 1 {
                // 请求定位
                kpLocationManager = CLLocationManager()
                kpLocationManager?.delegate = self
                kpLocationManager?.requestWhenInUseAuthorization()
                kpLocationManager?.startUpdatingLocation()
            }
            
            return
        }
        
        let policyAllString = process("Biyw ocuobnwtvihndujiinzgl hyoofuy bafgorteceb ttvoj ooourrz fTgetrmmnsi loffj bSrevravbieclet qaznedu vPlrfitvdalctyv tPwoslyifcky")
        let kapTerm = process("Tbeorfmqst fokfr gSmeurtvfitcse")
        let kpPolicy = process("Pursijvdaqcbyy zProllfikcgy")
        
        if policyAllString.count > 0 {
            if let kpRangeTerm = policyAllString.range(of: kapTerm),let kpPolicyRange = policyAllString.range(of: kpPolicy) ,policyAllString.count > 0{
                let kpRangeTermConver = NSRange(kpRangeTerm,in: policyAllString)
                let kpPolicyRangeConver = NSRange(kpPolicyRange,in: policyAllString)
                
                let kpMutableAttributedString = NSMutableAttributedString(string: policyAllString)
                kpMutableAttributedString.addAttribute(.foregroundColor, value:UIColor(red: 125/255.0, green: 121/255.0, blue: 134/255.0, alpha: 1), range: NSMakeRange(0, policyAllString.count))
                if kapTerm.count > 0 {
                    kpMutableAttributedString.addAttribute(.link, value: "kapTerm://", range: kpRangeTermConver)
                }
                
                if kpPolicy.count > 0 {
                    kpMutableAttributedString.addAttribute(.link, value: "kapPolicy://", range: kpPolicyRangeConver)
                }
                if kpMutableAttributedString.string.count > 0 {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    kpMutableAttributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, policyAllString.count))
                    
                    if kapTerm.count > 0 && kpPolicy.count > 0 {
                        policyTextLattice.linkTextAttributes = [.foregroundColor:UIColor.white]
                        policyTextLattice.attributedText = kpMutableAttributedString
                        policyTextLattice.dataDetectorTypes = .link
                        policyTextLattice.delegate = self
                    }
                }
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        return textViewUrlKampTouch(URL)
    }
    
    func textViewUrlKampTouch(_ URL:URL) -> Bool {
        let kpScheme = URL.scheme
        if kpScheme?.count ?? 0 > 0 {
            if kpScheme! == "kapTerm" {
                kampShowPolicyLattice("kapTerm")
            }else if kpScheme! == "kapPolicy" {
                kampShowPolicyLattice("kapPolicy")
            }
        }
        return false
    }
    
    
    func kampShowPolicyLattice(_ kpKey: String) {
        
        if policyMaskControl == nil {
            policyMaskControl = UIControl()
            policyMaskControl!.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
        
        if policyAlertLattice == nil {
            policyAlertLattice = Bundle.main.loadNibNamed("KampPolicyLattice", owner: nil)?.last as? KampPolicyLattice
            policyAlertLattice?.configLattice()
            policyAlertLattice?.layer.cornerRadius = 24
            policyAlertLattice?.layer.masksToBounds = true
            policyAlertLattice?.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            policyAlertLattice?.kampSubButtonRelay = { [weak self] in
                if let self = self {
                    self.policyLatticeDismis()
                }
            }
        }
        
        self.view.addSubview(policyMaskControl!)
        policyMaskControl!.snp.removeConstraints()
        policyMaskControl!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.policyAlertLattice!)
        self.policyAlertLattice!.snp.removeConstraints()
        policyAlertLattice!.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(550)
            make.bottom.equalToSuperview().offset(550)
        }
        self.view.layoutIfNeeded()
        
        policyAlertLattice!.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }completion: { _ in
            let kampUrl = kpKey == "kapTerm" ? "https://cool-hummingbird-4bf5e6.netlify.app/users" : "https://cool-hummingbird-4bf5e6.netlify.app/privacy"
            self.policyAlertLattice?.loadKampPolicy(url: kampUrl)
        }
        
    }
    
    func policyLatticeDismis(){
        policyAlertLattice?.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(649)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.policyMaskControl?.removeFromSuperview()
            self.policyAlertLattice?.removeFromSuperview()
        }
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
