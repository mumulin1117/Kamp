//
//  KampLiveChannelEngageCore.swift
//  Kamp
//
//  Created by Kamp on 2024/12/2.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class KampLiveChannelEngageCore: EngageCore ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var kampLiveChannelTable: UITableView!
    @IBOutlet weak var liveCollectionLattice: UICollectionView!
    var kampLiveChannelDatas:[Int]?
    @IBOutlet weak var kampLiveChannelTapBar1: UIButton!
    @IBOutlet weak var kampLiveChannelTapBar2: UIButton!
    
    var foryouTempLiveData:[KampLiveModel]?
    
    let liveChannelMateAIButton = UIButton(type: .custom)
    
    let kampLiveDatas = BehaviorRelay<[KampLiveModel]>(value: [])
    
    var kampChannelDatas = [[KampLiveModel]]()
    
    var SelectekampIndex = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configLattice()
        getKampLiveDatas()
        
        NotificationCenter.default.rx.notification(Notification.Name("liveBlocked")).subscribe {[weak self] _ in
            guard let self = self else {return}
            self.getKampLiveDatas(loading: false)
        }
        .disposed(by: kpRxDisposeBag)
    }
    
    private func configLattice(){
        let liveCollectionLatticeLayout = UICollectionViewFlowLayout()
        liveCollectionLatticeLayout.scrollDirection = .horizontal
        liveCollectionLatticeLayout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        liveCollectionLatticeLayout.minimumInteritemSpacing = 10
        liveCollectionLatticeLayout.itemSize = CGSizeMake(160, 264)
        
        liveCollectionLattice.setCollectionViewLayout(liveCollectionLatticeLayout, animated: true)
        
        kampLiveDatas.bind(to: liveCollectionLattice.rx.items(cellIdentifier: "liveCollectionLatticeCell", cellType: liveCollectionLatticeCell.self)){ liveCollectionLatticeIndex,liveCollectionLatticeItem,liveCollectionLatticecell in
            
            liveCollectionLatticecell.kpLiveSeeCount.setTitle(" \(liveCollectionLatticeItem.liveSeeCount)", for: .normal)
            liveCollectionLatticecell.kpLiveCover.image = UIImage(named: liveCollectionLatticeItem.kampLiveCover)
            liveCollectionLatticecell.kpLIveName.text = liveCollectionLatticeItem.kampLiveTitle
            
        }
        .disposed(by: kpRxDisposeBag)
        
        liveCollectionLattice.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if let self = self {
                self.SelectekampIndex = indexPath.row
                self.performSegue(withIdentifier: "KampLivIngEngageCore", sender: self)
            }
        }).disposed(by: kpRxDisposeBag)
        
        liveChannelMateAIButton.setBackgroundImage(UIImage(named: "liveChannelMuteAI"), for: .normal)
        liveChannelMateAIButton.rx.tap.subscribe { [weak self] _ in
            if let self = self {
                if let kampLoginUser = KampHelper.sharedHelper.kampLoginUser.value {
                    if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.aiBuy.title + kampLoginUser.kampLiverIdentif){
                        self.performSegue(withIdentifier: "StartUniMateAIContentEngageCore", sender: self)
                    }else{
                        self.performSegue(withIdentifier: "StartUniMateAIEngageCore", sender: self)
                    }
                }
                
            }
        }
        .disposed(by: kpRxDisposeBag)
        self.view.addSubview(liveChannelMateAIButton)
        liveChannelMateAIButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-149)
        }
    }
    
    fileprivate func getKampLiveDatas(loading:Bool = true){
        if loading {
            SVProgressHUD.show()
        }
        DispatchQueue.global().async {
            sleep(2)
            var semaphore:DispatchSemaphore?
            var kampItems = KampHelper.sharedHelper.kampLiveDats
            if kampItems.count == 0 {
                semaphore = DispatchSemaphore(value: 0)
                KampHelper.sharedHelper.loadAllConfig {
                    kampItems = KampHelper.sharedHelper.kampLiveDats
                    semaphore!.signal()
                }
                semaphore!.wait()
            }
            kampItems = kampItems.shuffled()
            
            let tmpLiveFirstDatas:[KampLiveModel] = Array(kampItems[0..<4])
            let tmpLiveSecondDatas:[KampLiveModel] = Array(kampItems[4..<7])
            let tmpLiveThreeDatas:[KampLiveModel] = Array(kampItems[7..<10])
            
            self.kampChannelDatas.removeAll()
            
            self.kampChannelDatas.append(tmpLiveFirstDatas)
            self.kampChannelDatas.append(tmpLiveSecondDatas)
            self.kampChannelDatas.append(tmpLiveThreeDatas)

            
            kampItems.removeAll { liveItems in
                if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.liveBlock.title + liveItems.kampLiveId) {
                    return true
                }else if liveItems.kampLiverIdentif == KampHelper.sharedHelper.kampLoginUser.value?.kampLiverIdentif {
                    return true
                }else{
                    return false
                }
            }
            
            DispatchQueue.main.async {
                if loading{
                    SVProgressHUD.dismiss()
                }
                self.kampLiveDatas.accept(kampItems)
                DispatchQueue.main.async {
                    self.kampLiveChannelTable.reloadData()
                }
            }
        }
    }
    
    @IBAction func kampLiveChannelTapBarRelay(_ sender: UIButton) {
        if sender.isSelected == true {
            return
        }
        
        sender.isSelected.toggle()
        
        if sender == kampLiveChannelTapBar1 {
            kampLiveChannelTapBar2.isSelected = false
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                SVProgressHUD.dismiss()
                let kampLiveDatas = self.foryouTempLiveData!
                self.kampLiveDatas.accept(kampLiveDatas)
                self.liveCollectionLattice.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
            }
        }else{
            kampLiveChannelTapBar1.isSelected = false
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                SVProgressHUD.dismiss()
                var kampLiveDatas = self.kampLiveDatas.value
                self.foryouTempLiveData = kampLiveDatas
                kampLiveDatas.removeAll { KampLiveModel in
                    if let _ = KampHelper.sharedHelper.currentMMKV?.string(forKey: LiveOperation.liverKpFollow.title + KampLiveModel.kampLiveId){
                        return false
                    }else{
                        return true
                    }
                }
                
                self.kampLiveDatas.accept(kampLiveDatas)
                if kampLiveDatas.count > 0 {
                    self.liveCollectionLattice.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
                }

            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return kampChannelDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kampLiveChannelLattice = tableView.dequeueReusableCell(withIdentifier: "KampLiveChannelLattice") as! KampLiveChannelLattice
        kampLiveChannelLattice.kampLiveChannelLatticeBackgroundLattice.image = UIImage(named: "liveChannelCellBackground" + "\(indexPath.section % 3)")
        kampLiveChannelLattice.kampLiveModel = self.kampChannelDatas[indexPath.section].first
        if indexPath.section == 0 {
            kampLiveChannelLattice.liveChannelName.text = "Entertainment live"
        }else if indexPath.section == 1 {
            kampLiveChannelLattice.liveChannelName.text = "Study Share Live"
        }else{
            kampLiveChannelLattice.liveChannelName.text = "Campus Life Live"
        }
        return kampLiveChannelLattice
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 13
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.SelectekampIndex = indexPath.section
        self.performSegue(withIdentifier: "ChannelDetailEngageCore", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let kampSegIdentifier = segue.identifier
        if kampSegIdentifier?.isEmpty == false {
            
            if kampSegIdentifier == "ChannelDetailEngageCore" {
                let channelDetailEngageCore = segue.destination as! ChannelDetailEngageCore
                channelDetailEngageCore.kampLiveDatas.accept(self.kampChannelDatas[SelectekampIndex])
            }
            
            if kampSegIdentifier == "KampLivIngEngageCore" {
                let campLivIngEngageCore = segue.destination as! KampLivIngEngageCore
                campLivIngEngageCore.kampLiveModel.accept(self.kampLiveDatas.value[SelectekampIndex])
            }
        }
        
    }
}
