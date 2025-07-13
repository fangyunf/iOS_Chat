//
//  FMessageTeamViewController.swift
//  Fiesta
//
//  Created by Amy on 2024/6/5.
//

import UIKit
import NEChatUIKit
import NEChatKit


@objc
public protocol FMessageTeamDelegate {
    func clickRightMore()
    func sendRedPacket()
    func sendUserCard()
    func showCollect()
    func teamRedPacketAction(model:MessageContentModel)
    func teamSwitchBtnAction(model:MessageContentModel, user:FGroupUserInfoModel?)
    func teamKickoutAction(model:MessageContentModel)
    func teamAvatarAction(model:MessageContentModel)
}

@objcMembers
class FMessageTeamViewController: FBaseViewController {
    
    weak var delegate : FMessageTeamDelegate?
    public var imTeamChatVc : FTeamChatViewController?
    public var sessionId : String
//    public var memberList :[FGroupUserInfoModel] = [FGroupUserInfoModel]()
    var recordView:FRecordVoiceView?
    
    public init(session: String) {
        self.sessionId = session
        super.init(nibName: nil, bundle: nil)
        imTeamChatVc = FTeamChatViewController(sessionId: sessionId)
        imTeamChatVc?.teamChatDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NEKitChatConfig.shared.ui.messageProperties.showTitleBarRightIcon = true
        NEKitChatConfig.shared.ui.chatInputMenu = { [self] menuList in
//            let collect = NEMoreItemModel()
//            collect.image = UIImage(named: "icn_more_collect")
//            collect.title = "收藏"
//            collect.customDelegate = self
//            collect.action = #selector(collectAction)
//            menuList.append(collect)
            
            let card = NEMoreItemModel()
            card.image = UIImage(named: "icn_more_card")
            card.title = "名片"
            card.customDelegate = self
            card.action = #selector(userCardAction)
            menuList.append(card)
            
            let quan = NEMoreItemModel()
            quan.image = UIImage(named: "icn_more_quan")
            quan.title = "红包"
            quan.customDelegate = self
            quan.action = #selector(redPacketAction)
            menuList.append(quan)
            
        }
        
        if imTeamChatVc != nil {
            self.addChild(imTeamChatVc!)
            self.view.addSubview((imTeamChatVc?.view)!)
            imTeamChatVc?.view.mas_makeConstraints({ (make) in
                make?.left.equalTo()(self.view)?.offset()(0)
                make?.right.equalTo()(self.view)?.offset()(0)
                make?.bottom.equalTo()(self.view)?.offset()(0)
                make?.top.equalTo()(self.view)?.offset()(0)
            })
        }
        
        NEKitChatConfig.shared.ui.messageProperties.titleBarRightClick = {
            self.delegate?.clickRightMore()
        }
        
        setWhiteNavBack()
        
        NotificationCenter.default.addObserver(self, selector: #selector(recordAudioProgress(_:)), name:  NSNotification.Name("recordAudioProgress"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startRecordAudio), name:  NSNotification.Name("startRecordAudio"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(endRecordAudio), name:  NSNotification.Name("endRecordAudio"), object: nil)
        
        
    }
    
    @objc func setGroupMessageName(name:String) {
        imTeamChatVc?.setGroupName(name: name)
    }
    
    @objc func setBgImage(_ image:UIImage) {
        imTeamChatVc?.setBgImage(image)
    }
    
    @objc func setMemberList(list:[FGroupUserInfoModel]) {
        imTeamChatVc?.setMemberList(list: list)
    }
    
    func redPacketAction() {
        self.delegate?.sendRedPacket()
    }
    
    func userCardAction() {
        self.delegate?.sendUserCard()
    }
    
    func collectAction() {
        self.delegate?.showCollect()
    }
    
    @objc func recordAudioProgress(_ noti:Notification){
        let currentTime:TimeInterval = noti.object as! TimeInterval
        print("\(currentTime)")
        if (recordView != nil) {
            recordView?.timeLabel.text = NSString(format: "00:%02ld", Int(currentTime)) as String
        }
    }
    
    func setTeamTitle(name: String) {
        title = name
        imTeamChatVc?.viewmodel.team?.teamName = name
        imTeamChatVc?.setNavTitle(name: name)
    }
    
    func clearMsgRecord() {
        imTeamChatVc?.viewmodel.messages.removeAll()
        imTeamChatVc?.tableView.reloadData()
    }
    
    @objc func startRecordAudio(){
        if recordView == nil {
            self.recordView = FRecordVoiceView(frame: CGRectMake((kScreenWidth - 140)/2, (kScreenHeight - 96)/2, 140, 96))
            view.addSubview(self.recordView!)
            recordView?.timeLabel.text = "00:00"
        }else{
            recordView?.timeLabel.text = "00:00"
            self.recordView?.isHidden = false
        }
        
    }
    
    @objc func endRecordAudio(){
        if (recordView != nil) {
            recordView?.isHidden = true
            recordView?.timeLabel.text = "00:00"
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension FMessageTeamViewController:FTeamChatDelegate {
    func switchBtnAction(model: NEChatUIKit.MessageContentModel, user: FGroupUserInfoModel?) {
        delegate?.teamSwitchBtnAction(model: model, user: user)
    }
    
    func teamRedPacketAction(model: NEChatUIKit.MessageContentModel) {
        delegate?.teamRedPacketAction(model: model)
    }
    
    func teamKickoutAction(model: NEChatUIKit.MessageContentModel) {
        delegate?.teamKickoutAction(model: model)
    }
    func teamAvatarAction(model: MessageContentModel) {
        delegate?.teamAvatarAction(model: model)
    }
}
