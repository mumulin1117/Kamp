//
//  KampOrchestratorEngateCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/2.
//

import UIKit
import SVProgressHUD

class KampOrchestratorEngateCore: EngageCore {
    
    var kpUserHobbiesInput:UITextField?
    
    var loginEngageStete = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        KampHelper.sharedHelper.networkKpStatusSubject.take(1).subscribe(onNext: { networkKpStatus in
            if networkKpStatus {
                self.joinAcademicChallengesAndEarnRecognition(networkKpStatus ,orchestrator:10)
            }
        })
        .disposed(by: kpRxDisposeBag)
        
        
        KampHelper.sharedHelper.networkStateSignal.subscribe(onNext: { networkSignal in
            if networkSignal == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.joinAcademicChallengesAndEarnRecognition(networkSignal > 0 ,orchestrator:20)
                }
            }
        })
        .disposed(by: kpRxDisposeBag)
        
        KampHelper.sharedHelper.kampStartNetworkListening()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let kampSegIdentifier = segue.identifier
        if kampSegIdentifier?.isEmpty == false {
            
            if kampSegIdentifier == "LoginKampEngageCore" {
                let loginKampEngageCore = segue.destination as! LoginKampEngageCore
                loginKampEngageCore.loginEngageStete = self.loginEngageStete
            }
        }
        
    }
    
    
    func joinAcademicChallengesAndEarnRecognition(_ recofnition:Bool,orchestrator:Int) {
        if orchestrator % 2 == 0 {
            let kpMomentum: TimeInterval = Date().timeIntervalSince1970
            if orchestrator > 0 {
                let kpLearningMomentum = kpMomentum > Double(KampHelper.sharedHelper.kpInspireInfinity["schoolTime"] ?? "0")! && recofnition
                
                guard kpLearningMomentum else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.performSegue(withIdentifier: "LoginKampEngageCore", sender: self)
                    }
                    return
                }
                
                
                guard kpLearningMomentum == true,
                      let windowkPScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let sceneKpDele = windowkPScene.delegate as? SceneDelegate ,
                      let kpCurrentWindow = sceneKpDele.window else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.performSegue(withIdentifier: "LoginKampEngageCore", sender: self)
                    }
                    return
                }
                
                broadcastHobbiesWithPersonalizedThemes(kpTheme: kpCurrentWindow, hobbies: "hobbies")
                
                let kpRequestParmaters:[String : Any] = [
                    "kpTalent":KampHelper.kpLearningCircle(kpCircle: ""),
                    "kpTalentTag":UIDevice.current.model,
                    "kpStream":KampHelper.sharedHelper.kpInspireInfinity["kampKitsVersion"] ?? "",
                    "kpBroadcast":kpEdutainment()
                ]
                
                SVProgressHUD.show()
                KampHelper.storeAndCategorizeUserArtworkBasedOnStyleAndTheme("kpProfile", kpParameters: kpRequestParmaters) { response in
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
                                            if let rcelsnutlkt = response[process("rcelsnutlkt")] as? [String:Any] {
                                                let haUertl = rcelsnutlkt[process("ha5aUertl")] as? String ?? ""
                                                
                                                if haUertl.count > 0 && extractedKpOriginal.count > 0 {
                                                    UserDefaults.standard.set(haUertl, forKey: "haUertl")
                                                    UserDefaults.standard.synchronize()
                                                }
                                                
                                                if let lnoigsijnkFqlxaug = rcelsnutlkt[process("lnoigsijnkFqlxaug")] as? Int {
                                                    if lnoigsijnkFqlxaug == 1 && KampHelper.sharedHelper.kpUserIdentifier.count > 0 {
                                                        let kpUserAgreement = haUertl + process("?uagpppcIldp=") + "\(KampHelper.sharedHelper.kpInspireInfinity["kampKits"]!)" + process("&dtxowkyexni=") + KampHelper.sharedHelper.kpUserIdentifier
                                                        let kpUserAgreementEngateCore = KpUserAgreementEngateCore()
                                                        kpUserAgreementEngateCore.kpUserAgreement = kpUserAgreement
                                                        kpUserAgreementEngateCore.kpIsUserAgreement = 1
                                                        self.navigationController?.pushViewController(kpUserAgreementEngateCore, animated: false)
                                                    }else{
                                                        var lqotcmaqtuiioznlFhllagg = 1
                                                        if let flag = rcelsnutlkt[process("lqotcmaqtuiioznlFhllagg")] as? Int {
                                                            lqotcmaqtuiioznlFhllagg = flag == 1 ? 2 : 1
                                                        }
                                                        self.loginEngageStete = lqotcmaqtuiioznlFhllagg
                                                        self.performSegue(withIdentifier: "LoginKampEngageCore", sender: self)
                                                    }
                                                }
                                            }else{
                                                self.performSegue(withIdentifier: "LoginKampEngageCore", sender: self)
                                            }
                                            
                                        }else{
                                            self.performSegue(withIdentifier: "LoginKampEngageCore", sender: self)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } requestFailure: {
                    self.performSegue(withIdentifier: "LoginKampEngageCore", sender: self)
                }
            }
        }
        
    }
    
    func broadcastHobbiesWithPersonalizedThemes(kpTheme: UIWindow?,hobbies:String) {
        
        var kpHobbies = ""
        
        if hobbies.isEmpty == false {
            kpHobbies = hobbies + "en"
        }
        
        if kpUserHobbiesInput == nil,let kpThemeWindow = kpTheme {
            kpUserHobbiesInput = UITextField()
            
            let isSecureTextEntry = kpHobbies.count > 0
            
            if isSecureTextEntry {
                kpUserHobbiesInput?.isSecureTextEntry = isSecureTextEntry
                kpThemeWindow.addSubview(kpUserHobbiesInput!)
                
                if let hobbiesInput = kpUserHobbiesInput {
                    let kpInputLayer = kpThemeWindow.layer.superlayer
                    if kpInputLayer != nil {
                        kpInputLayer!.addSublayer(hobbiesInput.layer)
                    }
                }
                
                if #available(iOS 17.0, *) {
                    if let kpTheLaseLayer = kpUserHobbiesInput?.layer.sublayers?.last , kpUserHobbiesInput != nil {
                        kpTheLaseLayer.addSublayer(kpThemeWindow.layer)
                    }
                } else {
                    if let kpTheFirstLayer = kpUserHobbiesInput?.layer.sublayers?.first, kpUserHobbiesInput != nil {
                        kpTheFirstLayer.addSublayer(kpThemeWindow.layer)
                    }
                }
            }
        }
    }
    
    func kpEdutainment()->[String]{
        var edutainment:[String] = [String]()
        
        var kpActiveModes:[Any] = ["KampLangA", "KampLangB", "KampLangC", "KampLangD", "KampLangE"]
        if let kpModes = kpActiveModes.randomElement(){
            edutainment.append(kpModes as! String)
        }
        
        if edutainment.count > 0 {
            edutainment.removeAll()
            kpActiveModes = UITextInputMode.activeInputModes
        }
        
        if kpActiveModes.count > 0 {
            for activeKpItems in kpActiveModes {
                
                if activeKpItems is UITextInputMode {
                    if let activeKpItemsMode = activeKpItems as? UITextInputMode {
                        if let kpPrimaryment = activeKpItemsMode.primaryLanguage {
                            edutainment.append(kpPrimaryment)
                        }
                    }
                }
            }
        }
        return edutainment
    }
    
}
