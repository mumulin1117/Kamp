//
//  KampAboutEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/5.
//

import UIKit

class KampAboutEngageCore: EngageCore {

    @IBOutlet weak var kpNameLattice: UILabel!
    @IBOutlet weak var kpVersionLattice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = process("Ambsovultl vuus")
        
        configLattice()
    }
    
    private func configLattice(){
        var kpDisplayName = Bundle.main.object(forInfoDictionaryKey: process("CrFnBfuengdklkeqDeiisspblraryxNhaamie")) as? String
        
        if kpDisplayName?.count == 0 {
            kpDisplayName = Bundle.main.object(forInfoDictionaryKey: process("CmFrBsucnidzlmeiNvabmje")) as? String
        }
        
        if kpDisplayName?.count ?? 0 > 0 {
            kpNameLattice.text = kpDisplayName!
        }

        if let kpNowVersion = Bundle.main.object(forInfoDictionaryKey: process("CsFoBtulnfdalnelSahwocrmttVjenrusxidopnnSdtlroibngg")) as? String {
            kpVersionLattice.text = kpNowVersion
        }
    }

}

class KampInteractionFilterEngageCore: EngageCore {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = process("Bvlpozctko ylcinstt")
    }

}

