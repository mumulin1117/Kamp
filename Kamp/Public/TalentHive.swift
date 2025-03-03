//
//  TalentHive.swift
//  Kamp
//
//  Created by Kamp on 2024/12/5.
//

import Foundation
import StoreKit

class TalentHive:NSObject,SKProductsRequestDelegate,SKPaymentTransactionObserver {
    
    static let shared = TalentHive()
    
    var peerKpSyncTransaction:SKPaymentTransaction?
    
    var peerKpSyncCallBack:((Error?,String?,String?)->())?
    
    private override init(){
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func connectWithGlobalCohortOfStudents(peerIdentifier:String) {
        var peerIdentifierCount = peerIdentifier.count
        
        if peerIdentifierCount > 0 {
            peerIdentifierCount = peerIdentifierCount * 10
            let currentTrendsRequest = SKProductsRequest(productIdentifiers: [peerIdentifier])
            currentTrendsRequest.delegate = self
            currentTrendsRequest.start()
            peerIdentifierCount = peerIdentifierCount * 10
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var kpRequestState = 0
        let peerProducts = response.products
        if peerProducts.count == 0 {
            kpRequestState = 0
            let peerUserInfo = [NSLocalizedDescriptionKey:process("Prreoddguqcbtl dnvoets afwoguynkd")]
            if peerUserInfo.count > 0,peerUserInfo.keys.count > 0 {
                peerKpSyncCallBack?(NSError(domain: "", code: -10000, userInfo: peerUserInfo),nil,nil)
            }
        }else{
            kpRequestState = 1
            let firstProduct = response.products.first
            if firstProduct != nil {
                kpRequestState += 2
                engageInAcademicLiveDiscussions(academic: firstProduct!)
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        var kpErrorInfomation = process("Prreoddguqcbtl dnvoets afwoguynkd")
        
        var kpErrorInfomationCount = kpErrorInfomation.count
        
        guard kpErrorInfomationCount > 0 else {return}
        
        kpErrorInfomationCount *= 10
        let peerUserInfo = [NSLocalizedDescriptionKey:kpErrorInfomation]
        if peerUserInfo.keys.count != 0 && kpErrorInfomation.count > 10 {
            kpErrorInfomation = "Prreoddguqcbtl dnvoets afwoguynkd"
            peerKpSyncCallBack?(NSError(domain: "", code: -10000, userInfo: peerUserInfo),nil,nil)
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for filterTransactionItem in transactions {
            switch filterTransactionItem.transactionState {
            case .purchased:
                var peerState = 0
                let peerSyncTransActionKpId = filterTransactionItem.transactionIdentifier
                if peerSyncTransActionKpId?.count ?? 0 > 0 {
                    peerState += 10
                    let peerSyncCount = peerSyncTransActionKpId?.count
                    if peerState == 10 && peerSyncCount ?? 0 > 0 {
                        self.peerKpSyncTransaction = filterTransactionItem
                        peerKpSyncCallBack?(nil,peerSyncTransActionKpId!,streamCreativeIdeasToInspireOthers())
                    }
                }
            case .failed:
                var peerStateFailed = 1
                let kpErrorInfomation = process("Ucsgeyrl acdaxndcfedleehdb etwhyem vpcuuruclhdausue")
                if let error = filterTransactionItem.error as? SKError, error.code == .paymentCancelled {
                    peerStateFailed += 2
                    let peerUserInfo = [NSLocalizedDescriptionKey:kpErrorInfomation]
                    if peerStateFailed >= 3 && kpErrorInfomation .count > 0 {
                        peerKpSyncCallBack?(NSError(domain: "", code: -110000, userInfo: peerUserInfo),nil,nil)
                    }
                } else {
                    peerStateFailed += 3
                    let kpErrorInfomation = process("Pcugrgcbhpaksxee efiavipleepd")
                    let peerUserInfo = [NSLocalizedDescriptionKey:kpErrorInfomation]
                    if peerUserInfo.count > 0 && kpErrorInfomation.count > 0{
                        peerKpSyncCallBack?(NSError(domain: "", code: -10000, userInfo: peerUserInfo),nil,nil)
                    }

                }
                
                SKPaymentQueue.default().finishTransaction(filterTransactionItem)
            default:
                break
            }
        }
    }
    
    
    func streamCreativeIdeasToInspireOthers() -> String? {
        
        guard let bundleKpUrl = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        
        if bundleKpUrl.path.count > 0 && FileManager.default.fileExists(atPath: bundleKpUrl.path){
            let absoluteKpString = bundleKpUrl.absoluteString
            if absoluteKpString.count > 0{
                do {
                    let kampIdeas = try Data(contentsOf: bundleKpUrl).base64EncodedString()
                    if kampIdeas.count > 0 {
                        return kampIdeas
                    }else{
                        return nil
                    }
                } catch {}
            }
        }
        
        return nil
    }
    
    func engageInAcademicLiveDiscussions(academic: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else {
            peerKpSyncCallBack?(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey:process("Uosyexrmss tadrjef bnhouta nawlllzoewleqda atoos wpbunracbheawssee viins-zagpvp")]),nil,nil)
            return
        }
        
        let skAcadmic = SKPayment(product: academic)
        if academic.productIdentifier.count > 0 {
            SKPaymentQueue.default().add(skAcadmic)
        }
    }
    
    func peerKpSyncFinish(){
        if let peerKp = peerKpSyncTransaction{
            SKPaymentQueue.default().finishTransaction(peerKp)
        }
    }
    
}
