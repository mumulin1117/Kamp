//
//  KampHelper.swift
//  Kamp
//
//  Created by Kamp on 2024/12/2.
//

import Foundation
import RxSwift
import RxCocoa
import MJExtension
import MMKV
import Alamofire
import SVProgressHUD
import FBSDKCoreKit


enum LiveOperation {
    
    case liveBlock
    case liveLike
    case liverKpFollow
    case aiBuy
    case timeLineBlock
    case timeLineLike
    case kampUserBlock
    
    
    var title:String{
        switch self {
        case .liveBlock:
            return "liveBlock_"
        case .liveLike:
            return "liveLike_"
        case .liverKpFollow:
            return "liverKpFollow_"
        case .aiBuy:
            return "aiBuy"
        case .timeLineBlock:
            return "timeLineBlock"
        case .timeLineLike:
            return "timeLineLike"
        case .kampUserBlock:
            return "kampUserBlock"
        }
    }
}


func process(_ input: String) -> String {
    var result = ""
    var temp = input.count
    
    for (idx, ch) in input.enumerated() where idx % 2 == 0 {
        temp *= idx
        result.append(ch)
    }
    
    return temp == 0 ? result : ""
}

struct StarItem {
    var starKpName = ""
    
    var starKpQuantity = ""
    
    var starKpIdentifuer = ""
    
    init(starKpName: String = "", starKpQuantity: String = "", starKpIdentifuer: String = "") {
        self.starKpName = starKpName
        self.starKpQuantity = starKpQuantity
        self.starKpIdentifuer = starKpIdentifuer
    }
}

@objcMembers class KampLiveModel: NSObject {
    var kampLiveId: String = ""
    var kampLiveCover: String = ""
    var kampLiveTitle: String = ""
    var kampLiver: String = ""
    var kampLiverIdentif: String = ""
    var liveForLike: Bool = false
    var liveForFollow: Bool = false
    var timelineInfo: String = ""
    var timelineId: String = ""
    var timelinePictures: [String] = []
    var kampStar = 0
    var liverInfo = ""
    
    var liverFollow = Int.random(in: 3...10)
    var liverFollowIng = Int.random(in: 3...10)
    
    var liveSeeCount = Int.random(in: 100...200)
    var liveLikeCount = Int.random(in: 200...400)
    
    var liverCache:UIImage?
}


class KampHelper {
    
    static let sharedHelper = KampHelper()
    
    let starConfigDatas = BehaviorRelay<[StarItem]>(value: [])
    
    var kampLiveDats:[KampLiveModel] = []
    
    let kampLoginUser = BehaviorRelay<KampLiveModel?>(value: nil)
    
    let kpRxDisposeBag = DisposeBag()
    
    var currentMMKV: MMKV?
    
    var kampLiver = [KampLiveModel]()
    
    let networkStateSignal = PublishSubject<Int>()
    
    var kpInspireInfinity = [String:String]()
    var kpDevicePush = ""
    var kpUserIdentifier = ""
    
    lazy var detailKpDatas = [UniMateAIContent]()
    lazy var peerSparkDatas = [UniMateAIContent]()
    
    let kpNetworkManager = NetworkReachabilityManager()
    let networkKpStatusSubject = PublishSubject<Bool>()
    
    var kpKnowledgePulse = (false,"")
    
    private init(){
        let defaultPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path
        MMKV.initialize(rootDir: defaultPath)
        kampLoginUser.subscribe { [weak self] loginUser in
            if let self = self {
                if let _loginUser = loginUser {
                    DispatchQueue.main.async {
                        
                        if _loginUser.kampStar != 0 {
                            self.currentMMKV?.set("\(_loginUser.kampStar)", forKey: "kampStar")
                        }
                        
                        if self.currentMMKV == nil {
                            self.currentMMKV = MMKV(mmapID: "userID_" + _loginUser.kampLiverIdentif)
                            if let kampStar = self.currentMMKV?.string(forKey: "kampStar"){
                                _loginUser.kampStar = Int(kampStar)!
                                self.kampLoginUser.accept(_loginUser)
                            }
                        }
                    }
                }else{
                    self.currentMMKV = nil
                }
                
            }
        }
        .disposed(by: kpRxDisposeBag)
        //2025-03-06 17:54:08   1741254848
        kpInspireInfinity = [
            "schoolTime":"1741254848",
            "kampKits":"20445412",
            "kampKitsAddress":"https://api.zdhjbj.link",
            "kpProfile":"/kamp/account/createProfile",
            "AchievementBoard":"AchievementBoard",
            "kpConnect":"/kamp/live/streamingConfig",
            "kpModify":"/kamp/user/fetchDetails",
            "startBroadcast":process("/gacpdir/biyoksw/nvv2x/rpzaty"),
            "kampKitsVersion":Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String,
            "peerSync":"PeerSync",
            "studySphere":"StudySphere"
        ]
        
        
        if let kpUserIdentifier = UserDefaults.standard.string(forKey: "kpUserIdentifier") {
            self.kpUserIdentifier = kpUserIdentifier
        }
        
    }
    
    func kampStartNetworkListening(){
        kpNetworkManager!.startListening(onUpdatePerforming: { status in
            switch status {
                
            case .reachable(.ethernetOrWiFi),.reachable(.cellular):
                self.networkKpStatusSubject.onNext(true)
            case .notReachable,.unknown:break
            }
        })
    }
    
    public func getStarConfig(){
        starConfigDatas.accept(
            [
                StarItem(starKpName: process("$i0w.t9l9"),starKpQuantity: process("4b0v0"),starKpIdentifuer: "txkifsocjodaione"),
                StarItem(starKpName: process("$i1w.t9l9"),starKpQuantity: process("8b0v0"),starKpIdentifuer: "lraqejlhjnqoccyq"),
                
                StarItem(starKpName: process("$i2w.t9l9"),starKpQuantity: process("1b8b0v0"),starKpIdentifuer: "qjzxgvsdptixmxdi"),
                
                StarItem(starKpName: process("$i4w.t9l9"),starKpQuantity: process("2a4i5t0"),starKpIdentifuer: "qxyreslhhykvgvdt"),
                StarItem(starKpName: process("$i9w.t9l9"),starKpQuantity: process("4h9y0i0"),starKpIdentifuer: "imvtdwsysxwaurlo"),
                StarItem(starKpName: process("$o1w9o.o9r9"),starKpQuantity: process("9e8s0s0"),starKpIdentifuer: "plwvytfhomqbherv"),
                
                StarItem(starKpName: process("$o2w9o.o9r9"),starKpQuantity: process("1f5o0d0b0"),starKpIdentifuer: "xnbptkapvedhohnc"),
                
                StarItem(starKpName: process("$o4w9o.o9r9"),starKpQuantity: process("2v4v5a0m0"),starKpIdentifuer: "jjhwleejcnilxpll"),
                
                StarItem(starKpName: process("$o6w9o.o9r9"),starKpQuantity: process("3f6o0d0b0"),starKpIdentifuer: "kivykezlqemmrydu"),
                
                StarItem(starKpName: process("$o9w9o.o9r9"),starKpQuantity: process("4z9g0y0f0"),starKpIdentifuer: "kysgqctfxkucocsy"),
            ]
        )
    }
    
    func chronicleSpectrum(){
        
        let kpRequestParmaters:[String : Any] = [
            "kpRealTime": self.kpInspireInfinity["kampKitsVersion"]!,
            "kpAnalytics":process("AqPuPuSoTvOnRpE"),
            "kpMultichannel":UIDevice.current.systemName,
            "kpInteraction":UIDevice.current.systemVersion,
            "kpShowcases":self.kpDevicePush
        ]
        
        KampHelper.storeAndCategorizeUserArtworkBasedOnStyleAndTheme("kpModify", kpParameters: kpRequestParmaters) { response in
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
                                    self.kpKnowledgePulse = (true,"kpModify Success")
                                }
                            }
                        }
                    }
                }
            }
        } requestFailure: {}
        
    }
    
    func curateMultiChannelViewingExperience(curate: String, multiChannel: String,experience:String,verifyState:Int,showLoad:Bool) {
        
        if showLoad {
            SVProgressHUD.show()
        }
        
        let kpRequestParmaters:[String : Any] = [
            process("puatsqsmwfojrcd"): verifyState == 200 ? "" : process("puatsqsmwfojrcd"),
            process("pbaaytldohasd"):multiChannel,
            process("turoaanbszaccitfiaoknlIud"):curate,
            process("toyppte"):process("dnikrzegcxt")
        ]
        
        KampHelper.storeAndCategorizeUserArtworkBasedOnStyleAndTheme("startBroadcast", kpParameters: kpRequestParmaters) { response in
            if showLoad == false {
                SVProgressHUD.dismiss()
            }
            
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
                                    SVProgressHUD.showInfo(withStatus: process("Pcuerxcfhpausyed bSquzcocxepsvs"))
                                    TalentHive.shared.peerKpSyncFinish()
                                    self.trackViewerEngagementAndOptimizeContent(engagement: .purchased, optimizeContent: experience,modifiCount:10)
                                }else{
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
            SVProgressHUD.dismiss()
        }
    }
    
    func trackViewerEngagementAndOptimizeContent(engagement:AppEvents.Name,optimizeContent:String,modifiCount:Int){
        
        var optimizeKey = ""
        
        if modifiCount % 2 == 0 {
            var kpConfigDatas = starConfigDatas.value
            if kpConfigDatas.count == 0 {
                self.getStarConfig()
                kpConfigDatas = starConfigDatas.value
            }
            if let filterStarItem = kpConfigDatas.first(where: {$0.starKpIdentifuer == optimizeContent}) {
                optimizeKey = filterStarItem.starKpName
                
                if optimizeKey.hasPrefix("$") {
                    optimizeKey.removeFirst()
                }
            }
        }
    
        if modifiCount % 10 == 0 && optimizeKey.count > 0 {
            if engagement == .initiatedCheckout && modifiCount > 0 {
                AppEvents.shared.logEvent(AppEvents.Name.initiatedCheckout, parameters: [.init(process("aimmokujnqt")): optimizeKey,.init(process("cqulrtrjeonbcry")):process("UdSoD")])
            }else{
                AppEvents.shared.logEvent(AppEvents.Name.purchased, parameters: [.init(process("tkodtjajlxPyrdizcse")): optimizeKey,.init(process("cqulrtrjeonbcry")):process("UdSoD")])
            }
        }
    }
    
    func loadAllConfig(completion:@escaping(()->())){
        DispatchQueue.global().async {
            let liveDatas = [
                [
                    "kampLiveId":"xCfCSIifg1gId6EBReEyRw3wCLpXYp",
                    "kampLiveCover":"xCfCSIifg1gId6EBReEyRw3wCLpXYp.jpeg",
                    "kampLiveTitle":"Campus Life Unleashed",
                    "kampLiver":"Wyatt",
                    "kampLiverIdentif":"EELxnGQPSqWZnSNCHPukywCvERnGaj.jpeg",
                    "timelineInfo":"Just aced a tough exam! 💪 College life is full of challenges.",
                    "timelineId":"SMc1sJCsUjlUr23onL0uKX14mO1qbN",
                    "timelinePictures":[
                        "SMc1sJCsUjlUr23onL0uKX14mO1qbN0.jpg",
                        "SMc1sJCsUjlUr23onL0uKX14mO1qbN1.jpg"
                    ],
                    "liverInfo":"Tech enthusiast who loves to explore innovative ideas. Currently working on a project about AI-driven education platforms."
                ],
                [
                    "kampLiveId":"WpbXICi0IyTID6o7QlHtvZfH90feC6",
                    "kampLiveCover":"WpbXICi0IyTID6o7QlHtvZfH90feC6.jpeg",
                    "kampLiveTitle":"College Days: Live & Unfiltered",
                    "kampLiver":"Miles",
                    "kampLiverIdentif":"Wq6arKJFB1gurkZcyvgVa4wxtQ3f9i.jpeg",
                    "timelineInfo":"Had a blast at the campus festival today! 🎉 So much fun.",
                    "timelineId":"zszJvoDB0PI5PZQpvo3dvNbk7ctZm4",
                    "timelinePictures":[
                        "zszJvoDB0PI5PZQpvo3dvNbk7ctZm40.jpg",
                        "zszJvoDB0PI5PZQpvo3dvNbk7ctZm41.jpg",
                        "zszJvoDB0PI5PZQpvo3dvNbk7ctZm42.jpg"
                    ],
                    "liverInfo":"Campus photographer capturing the vibrant life of university students. Let’s share memories through the lens!."
                ],
                [
                    "kampLiveId":"mxP3Foi3BKRuLsinp1fsZxeQx003D9",
                    "kampLiveCover":"mxP3Foi3BKRuLsinp1fsZxeQx003D9.jpeg",
                    "kampLiveTitle":"University Life Chronicles",
                    "kampLiver":"Skye",
                    "kampLiverIdentif":"b1Y7xqV5Izz067S20JKzmVQNeLa6MX.jpeg",
                    "timelineInfo":"Late-night study session in the library. 📚 Coffee is my best friend.",
                    "timelineId":"qBAJdhNznRAkQt5mojb3K2ltmanDb4",
                    "timelinePictures":[
                        "qBAJdhNznRAkQt5mojb3K2ltmanDb4.jpg",
                    ],
                    "liverInfo":"A passionate debater and an advocate for environmental sustainability. Join me in making the world greener!"
                ],
                [
                    "kampLiveId":"C7k4PM8g97NONcUNyDbTJXK5u784Jj",
                    "kampLiveCover":"C7k4PM8g97NONcUNyDbTJXK5u784Jj.jpeg",
                    "kampLiveTitle":"Campus Tales: Live from Dorms to Classes",
                    "kampLiver":"Hazel",
                    "kampLiverIdentif":"bJzWgmSe1dB55udJIZc15YgT8DmGCQ.jpeg",
                    "timelineInfo":"Late-night study session in the library. 📚 Coffee is my best friend.",
                    "timelineId":"wc2fJX02N92PKteA5hez3gpPg3tXj9",
                    "timelinePictures":[
                        "wc2fJX02N92PKteA5hez3gpPg3tXj90.jpg",
                        "wc2fJX02N92PKteA5hez3gpPg3tXj91.jpg"
                    ],
                    "liverInfo":"Music is life! I’m a part-time DJ and a full-time dreamer. Come vibe with me at Kamp!"
                ],
                [
                    "kampLiveId":"um4JDOzMnEWslv20fZhFF5uk9K0AQS",
                    "kampLiveCover":"um4JDOzMnEWslv20fZhFF5uk9K0AQS.jpeg",
                    "kampLiveTitle":"Academic Pursuits Live",
                    "kampLiver":"Felix",
                    "kampLiverIdentif":"ZkpSzTYYbLREeoyb53AfXJPx278iEL.jpeg",
                    "timelineInfo":"Discovering a hidden gem on campus. 🌳 Love this place.",
                    "timelineId":"h9oxWu7drnpSuG3aYqp0zHXleMZQC8",
                    "timelinePictures":[
                        "h9oxWu7drnpSuG3aYqp0zHXleMZQC80.jpg",
                        "h9oxWu7drnpSuG3aYqp0zHXleMZQC81.jpg"
                    ],
                    "liverInfo":"An aspiring entrepreneur turning ideas into action. Let’s network and build our future!"
                ],
                [
                    "kampLiveId":"UsJejKqa95IVKlci90Kb2uPBKkRIDo",
                    "kampLiveCover":"UsJejKqa95IVKlci90Kb2uPBKkRIDo.jpeg",
                    "kampLiveTitle":"Study Sessions Unplugged",
                    "kampLiver":"Sadie",
                    "kampLiverIdentif":"FOcZHuacLr1dUYDHSDd1IaxWMgTMsM.jpeg",
                    "timelineInfo":"Discovering a hidden gem on campus. 🌳 Love this place.",
                    "timelineId":"L7jF78Odwr7RzFZMtfSfY3t9fHhAoc",
                    "timelinePictures":[
                        "L7jF78Odwr7RzFZMtfSfY3t9fHhAoc0.jpg",
                        "L7jF78Odwr7RzFZMtfSfY3t9fHhAoc1.jpg"
                    ],
                    "liverInfo":"Bookworm with a love for classic literature and modern fiction. Join me for book discussions and coffee!"
                ],
                [
                    "kampLiveId":"dNdqHhIojDcz3pwBZRraCh8tNrHwrM",
                    "kampLiveCover":"dNdqHhIojDcz3pwBZRraCh8tNrHwrM.jpeg",
                    "kampLiveTitle":"Knowledge Quest in College Live",
                    "kampLiver":"Theo",
                    "kampLiverIdentif":"68fnDRyhu9fZX9NwlG3lAGKIIeBBYa.jpeg",
                    "timelineInfo":"Craving pizza after a long day of classes. 🍕 Yum!",
                    "timelineId":"54ppZ6soDsJdPohZC7Ky3UJvRfa1Gu",
                    "timelinePictures":[
                        "54ppZ6soDsJdPohZC7Ky3UJvRfa1Gu0.jpg",
                        "54ppZ6soDsJdPohZC7Ky3UJvRfa1Gu1.jpg"
                    ],
                    "liverInfo":"Fitness enthusiast and a wellness coach in the making. Let’s hit the gym together!"
                ],
                [
                    "kampLiveId":"OrAlDHbYpu8HOjrRG4pFt9VYGHkfWd",
                    "kampLiveCover":"OrAlDHbYpu8HOjrRG4pFt9VYGHkfWd.jpeg",
                    "kampLiveTitle":"College Entertainment Livewire",
                    "kampLiver":"Asher",
                    "kampLiverIdentif":"Ob0ZjRe5CXa2SNycXOSCcsGHpsjBUt.jpeg",
                    "timelineInfo":"Finished a great book for my literature class. 📖 Insights galore.",
                    "timelineId":"2mLgmnD5Rd0mM8GDEmjio44htcfJFI",
                    "timelinePictures":[
                        "2mLgmnD5Rd0mM8GDEmjio44htcfJFI0.jpg",
                        "2mLgmnD5Rd0mM8GDEmjio44htcfJFI1.jpg",
                        "2mLgmnD5Rd0mM8GDEmjio44htcfJFI2.jpg"
                    ],
                    "liverInfo":"A foodie who’s always hunting for the best campus eats. Any recommendations?"
                ],
                [
                    "kampLiveId":"jFT2SRKVT6vl25qaZRxffi1GQBZnGX",
                    "kampLiveCover":"jFT2SRKVT6vl25qaZRxffi1GQBZnGX.jpeg",
                    "kampLiveTitle":"Fun Times on Campus: Live Show",
                    "kampLiver":"Julian",
                    "kampLiverIdentif":"eNNKUsR5uQs6z7bD71MK4xHOHOoAYz.jpeg",
                    "timelineInfo":"Joined a new club. 🤩 Excited for what's to come.",
                    "timelineId":"ClG3GGSybKT1LUuxWLPuS9kiknj1hl",
                    "timelinePictures":[
                        "ClG3GGSybKT1LUuxWLPuS9kiknj1hl0.jpg",
                        "ClG3GGSybKT1LUuxWLPuS9kiknj1hl1.jpg"
                    ],
                    "liverInfo":"Game developer in progress. Passionate about coding, creativity, and collaboration!"
                ],
                [
                    "kampLiveId":"ordmQN7DR36xaiI9P834CRpk38cbmf",
                    "kampLiveCover":"ordmQN7DR36xaiI9P834CRpk38cbmf.jpeg",
                    "kampLiveTitle":"Campus Playground Live",
                    "kampLiver":"Clara",
                    "kampLiverIdentif":"HFvCT2fokcPb7ByQqivM8xCb6mdRyV.jpeg",
                    "timelineInfo":"Campus sunset is always so beautiful. 🌇 A moment to cherish.",
                    "timelineId":"VHil2tM1ymwZZJ7t34cP6wosWcWjjD",
                    "timelinePictures":[
                        "VHil2tM1ymwZZJ7t34cP6wosWcWjjD0.jpg",
                        "VHil2tM1ymwZZJ7t34cP6wosWcWjjD1.jpg",
                        "VHil2tM1ymwZZJ7t34cP6wosWcWjjD2.jpg"
                    ],
                    "liverInfo":"Nature lover who’s exploring hiking trails around the campus. Let’s plan an adventure!"
                ]
            ]
            
            if let mjLiveDatas:[KampLiveModel] = KampLiveModel.mj_objectArray(withKeyValuesArray: liveDatas) as? [KampLiveModel] {
                self.kampLiveDats = mjLiveDatas
            }
            
            var loginKpItem:KampLiveModel? = nil
            if self.kampLoginUser.value == nil,let liverIdentifier = UserDefaults.standard.string(forKey: "isLogin") {
                
                if liverIdentifier == "kpNormalAvatar" {
                    loginKpItem = self.creteGuestAccount()
                }else{
                    loginKpItem = self.kampLiveDats.first(where: { $0.kampLiverIdentif == liverIdentifier })
                }
                
            }
            
            DispatchQueue.main.async {
                
                if let loginKpItem = loginKpItem {
                    self.kampLoginUser.accept(loginKpItem)
                }
                completion()
            }
        }
    }
    
    func creteGuestAccount()->KampLiveModel{
        let liveKpItem = KampLiveModel()
        liveKpItem.kampLiverIdentif = "kpNormalAvatar"
        liveKpItem.kampLiver = "Guest Account"
        liveKpItem.liverInfo = "-"
        liveKpItem.liverFollow = 0
        liveKpItem.liverFollowIng = 0
        liveKpItem.liveSeeCount = 0
        liveKpItem.liveLikeCount = 0
        return liveKpItem
    }
    
    static func showKampAlert(on kpTopEngate: UIViewController,
                              message: String,
                              cancelTitle: String = "Cancel",
                              confirmTitle: String = "OK",
                              confirmAction: (() -> Void)? = nil) {
        let kpAlertLattice = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        if cancelTitle.count != 0 {
            let cancelKpAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            kpAlertLattice.addAction(cancelKpAction)
        }
        if confirmTitle.count != 0 {
            let confirmKpAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
                confirmAction?()
            }
            kpAlertLattice.addAction(confirmKpAction)
        }
        
        kpTopEngate.present(kpAlertLattice, animated: true, completion: nil)
    }
    
    
    
    static func kpLearningCircle(kpCircle:String) -> String {
        
        var kpLearn: String = kpCircle.count == 0 ? "" : kpCircle
        
        if kpLearn.count == 0 {
            var kpCollabCast: CFTypeRef?
            let learnFlag = "kpLearningCircle"
            var kpLearnParamater: [String: Any] = [kSecClass as String: kSecClassGenericPassword,kSecAttrAccount as String: learnFlag,kSecReturnData as String: kCFBooleanTrue!,kSecMatchLimit as String: kSecMatchLimitOne]
            
            if learnFlag.isEmpty == false {
                let kpLearnState = SecItemCopyMatching(kpLearnParamater as CFDictionary, &kpCollabCast)
                var learnProgress:[String : Any] = [
                    "progress":0.3,
                    "state":"learnIng"
                ]
                if kpLearnState == errSecSuccess {
                    if let kpReadData = kpCollabCast as? Data {
                        kpLearn = kpDeCryptData(kpReadData,decodeVersion: 3) ?? ""
                    }
                }
                
                if let progress = learnProgress["progress"] as? Double,progress < 0.5 {
                    kpLearn = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
                    
                    if let kpCryptData = kpEncodeStructValue(kpLearn, encodeVersion: 3) {
                        kpLearnParamater = [kSecClass as String: kSecClassGenericPassword,kSecAttrAccount as String: learnFlag,kSecValueData as String: kpCryptData]
                        SecItemDelete(kpLearnParamater as CFDictionary)
                        SecItemAdd(kpLearnParamater as CFDictionary, nil)
                    }
                    
                    learnProgress = [
                        "progress":1,
                        "state":"learnDone"
                    ]
                }
            }
        }
        return kpLearn
    }
    
    private static func kpDeCryptData(_ needDecode: Data,decodeVersion:Int) -> String? {
        
        if decodeVersion > 2 {
            do {
                return try NSKeyedUnarchiver.unarchivedObject(ofClass: NSString.self, from: needDecode) as String?
            } catch {
                return nil
            }
        }else{
            return nil
        }
        
        
    }
    
    private static func kpEncodeStructValue(_ needEncode: String,encodeVersion:Int) -> Data? {
        if encodeVersion > 2 {
            do {
                return try NSKeyedArchiver.archivedData(withRootObject: needEncode, requiringSecureCoding: false)
            } catch {
                return nil
            }
        }else{
            return nil
        }
        
    }
    
    static func storeAndCategorizeUserArtworkBasedOnStyleAndTheme(_ requestKpAddress:String,kpParameters:[String:Any]?, requestDone:@escaping ([String:Any])->(),requestFailure:@escaping (()->())){
        
        var kpAddress = requestKpAddress
        
        if let kpTempAddress =  KampHelper.sharedHelper.kpInspireInfinity[requestKpAddress] {
            kpAddress = KampHelper.sharedHelper.kpInspireInfinity["kampKitsAddress"]! + kpTempAddress
        }
        
        
        let kpRequestHeader:HTTPHeaders = [
            process("aipipcImd"): KampHelper.sharedHelper.kpInspireInfinity["kampKits"]!,
            process("ahpjprVoeqrgsgidoon"): KampHelper.sharedHelper.kpInspireInfinity["kampKitsVersion"]!,
            process("doewvfiicxejNeo"):KampHelper.kpLearningCircle(kpCircle: ""),
            process("lfannqgnuuamgae"):Locale.preferredLanguages.first!,
            process("lxolgaiqnnTyoxkdexn"):KampHelper.sharedHelper.kpUserIdentifier
        ]
        
        AF.request(kpAddress,method: .post,parameters: kpParameters,encoding: JSONEncoding.default,headers:kpRequestHeader).validate().response { kpResponse in
            switch kpResponse.result {
                
            case .failure(_): requestFailure()
            case .success(let kpSuccessData):
                if let kpResponseResult = try? JSONSerialization.jsonObject(with: kpSuccessData!, options: .mutableContainers),
                   let kpRequestDone = kpResponseResult as? [String:Any]{
                    requestDone(kpRequestDone)
                }
                break
            }
        }
    }
}
