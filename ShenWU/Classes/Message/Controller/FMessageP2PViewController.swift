//
//  FMessageP2PViewController.swift
//  Fiesta
//
//  Created by Amy on 2024/6/5.
//

import UIKit
import NEChatUIKit

@objc
public protocol FMessageP2PDelegate {
    func clickRightMore()
    func sendRedPacket()
    func sendZhuazhang()
    func sendUserCard()
    func showCollect()
}

@objcMembers
class FMessageP2PViewController: FBaseViewController {
    weak var delegate : FMessageP2PDelegate?
    var imP2PChatVc : FP2PChatViewController?
    var recordView:FRecordVoiceView?
    public var sessionId : String?
    
    public init(session: String) {
        super.init(nibName: nil, bundle: nil)
        sessionId = session
        imP2PChatVc = FP2PChatViewController(sessionId: session)
    }
    
    deinit {
        print("FMessageP2PViewController")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if sessionId != FMessageManager.shared().aideNewsUserId {
            NEKitChatConfig.shared.ui.chatInputMenu = { [self] menuList in
//                let collect = NEMoreItemModel()
//                collect.image = UIImage(named: "icn_more_collect")
//                collect.title = "收藏"
//                collect.customDelegate = self
//                collect.action = #selector(collectAction)
//                menuList.append(collect)
                
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
                
                let zhuanzhang = NEMoreItemModel()
                zhuanzhang.image = UIImage(named: "icn_more_tran")
                zhuanzhang.title = "转账"
                zhuanzhang.customDelegate = self
                zhuanzhang.action = #selector(zhuanzhangAction)
                menuList.append(zhuanzhang)
                
            }
            NEKitChatConfig.shared.ui.messageProperties.showTitleBarRightIcon = true
        }else{
            NEKitChatConfig.shared.ui.messageProperties.showTitleBarRightIcon = false
        }
        
        
        if imP2PChatVc != nil {
            addChild(imP2PChatVc!)
            view.addSubview((imP2PChatVc?.view)!)
            imP2PChatVc?.view.mas_makeConstraints({ [self] (make) in
                make?.left.equalTo()(view)?.offset()(0)
                make?.right.equalTo()(view)?.offset()(0)
                make?.bottom.equalTo()(view)?.offset()(0)
                make?.top.equalTo()(view)?.offset()(0)
            })
        }
        
        NEKitChatConfig.shared.ui.messageProperties.titleBarRightClick = {
            self.delegate?.clickRightMore()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setWhiteNavBack()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(recordAudioProgress(_:)), name:  NSNotification.Name("recordAudioProgress"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startRecordAudio), name:  NSNotification.Name("startRecordAudio"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(endRecordAudio), name:  NSNotification.Name("endRecordAudio"), object: nil)
    }
    
    func setChatTitle(name: String) {
        title = name
        imP2PChatVc?.setNavTitle(name: name)
    }
    
    @objc func setBgImage(_ image:UIImage) {
        imP2PChatVc?.setBgImage(image)
    }
    
    func clearMsgRecord() {
        imP2PChatVc?.viewmodel.messages.removeAll()
        imP2PChatVc?.tableView.reloadData()
    }
    
    func redPacketAction() {
        self.delegate?.sendRedPacket()
    }
    
    func zhuanzhangAction() {
        self.delegate?.sendZhuazhang()
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
