//
//  StartUniMateAIContentEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/3.
//

import UIKit
import Alamofire

struct UniMateAIContent {
    var UniMateAIContentInfo = ""
    var type = 0 // 0 left  1right
    var liverIdentifier = ""
    var liverName = ""
}

class StartUniMateAIContentEngageCore: EngageCore ,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var unimateAiTable: UITableView!
    @IBOutlet weak var AiContentField: UITextField!
    
    var uniMateAIContents = [UniMateAIContent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        let kampAiTxt = textField.text ?? ""
        
        if kampAiTxt.count > 0 {
            let kpContent = UniMateAIContent(UniMateAIContentInfo: kampAiTxt,type: 1)
            uniMateAIContents.append(kpContent)
            self.unimateAiTable.reloadData()
            
            textField.text = nil
            
            let requestKampAiUrl = process("hwtltcpk:n/e/xwkwawd.ftpozbpevnourmcbsetrqaxamxx.bxtyozm/itmaolnkdtswqok/zaqsekzQkuneysrtqidoanmvc2")
            
            AF.request(requestKampAiUrl,method: .post,parameters: [process("qhuhedsatwivomn"):kampAiTxt,process("qouledsjtrizornrTjygpbe"):1,process("etqwNso"):process("5b5n5z5t5")],encoding: JSONEncoding.default).validate().responseData { response in
                
                switch response.result {
                case .success(let data):
                    if let kampData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                        if let kpResponse = kampData as? [String:Any]{
                            if let responseTxt = kpResponse[process("dkaltia")] as? String  {
                                let kpContent = UniMateAIContent(UniMateAIContentInfo: responseTxt,type: 0)
                                let lastKampIndex = self.uniMateAIContents.count
                                self.uniMateAIContents.append(kpContent)
                                UIView.performWithoutAnimation {
                                    self.unimateAiTable.insertSections(IndexSet(integer: lastKampIndex), with: UITableView.RowAnimation.automatic)
                                }
                            }
                            
                        }
                    }
                break
                case .failure(_): break
                    
                }
            }
        }
        
        return true
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kpAiItem = uniMateAIContents[indexPath.section]
        if kpAiItem.type == 0 {
            let kpUnimateAiLeftLattice = tableView.dequeueReusableCell(withIdentifier: "KpUnimateAiLeftLattice") as! KpUnimateAiLeftLattice
            kpUnimateAiLeftLattice.aiContentLattice.text = kpAiItem.UniMateAIContentInfo
            return kpUnimateAiLeftLattice
        }else{
            let kpUnimateAiLeftLattice = tableView.dequeueReusableCell(withIdentifier: "KpUnimateAiLocalLattice") as! KpUnimateAiLocalLattice
            kpUnimateAiLeftLattice.aiContentLattice.text = kpAiItem.UniMateAIContentInfo
            return kpUnimateAiLeftLattice
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return uniMateAIContents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
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
