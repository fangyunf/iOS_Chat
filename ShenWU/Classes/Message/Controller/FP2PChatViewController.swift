//
//  FP2PChatViewController.swift
//  Fiesta
//
//  Created by Amy on 2024/6/5.
//

import UIKit
import NEChatUIKit
import NIMSDK

class FP2PChatViewController: P2PChatViewController {
    var sessionId:String = ""
    public override init(sessionId: String) {
        super.init(sessionId: sessionId)
        self.sessionId = sessionId
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func setOperationItems(items: inout [OperationItem], model: MessageContentModel?) {
        if model?.type == .text || model?.type == .image {
//            let item = OperationItem()
//            item.text = "收藏"
//            item.imageName = "op_collection"
//            item.type = .collection
//            items.append(item)
        }
        
        
        items.forEach { item in
            if !(item.type == .copy || item.type == .delete || item.type == .forward || item.type == .collection || item.type == .recall) {
                let index = items.firstIndex(of: item)
                items.remove(at: index ?? 0)
            }
        }
        print(items)
    }
    
    override func didLongPressMessageView(_ cell: UITableViewCell, _ model: MessageContentModel?) {
        if let m = model as? MessageCustomModel {
            if let object = m.message?.messageObject as? NIMCustomObject {
                if let _ = object.attachment as? FRedPacketMessageModel {
                    /// 红包不允许有任何操作
                    return
                }
            }
        }
        super.didLongPressMessageView(cell, model)
    }
    
    override func didTapAvatarView(_ cell: UITableViewCell, _ model: MessageContentModel?) {
        return
    }
    
    override func didTapMessage(_ cell: UITableViewCell?, _ model: MessageContentModel?, _ replyIndex: Int? = nil) {
        super.didTapMessage(cell, model, replyIndex)
        if let m = model as? MessageCustomModel {
            if let object = m.message?.messageObject as? NIMCustomObject {
                if let cardModel = object.attachment as? FUserCardMessageModel {
                    FUserRelationManager.shared().jump(toUserCardInfo: cardModel.memberCode ?? "")
                }else if let redModel = object.attachment as? FRedPacketMessageModel {
                    redModel.sendAvatar = model?.avatar
                    redModel.sendName = model?.fullName
                    if redModel.claimed == true {
                        jumpToRedPacketDetail(redModel)
                    }else {
                        /// 点击红包就变暗的逻辑
                        redModel.received = true
                        NIMSDK.shared().conversationManager.update((model?.message)!, for: (model?.message?.session)!) { error in
                            if error == nil {
                                self.tableView.reloadData()
                            }
                        }
                        if redModel.customType == 28 {
                            NIMSDK.shared().conversationManager.update((model?.message)!, for: (model?.message?.session)!) { error in
                                if error == nil {
                                    self.tableView.reloadData()
                                }
                            }
                            self.jumpToZhuanzhangDetail(redModel)
                        }else{
                            showRedPacket(redModel, sessionId: self.sessionId) { dict in
                                redModel.claimed = true
                                NIMSDK.shared().conversationManager.update((model?.message)!, for: (model?.message?.session)!) { error in
                                    if error == nil {
                                        self.tableView.reloadData()
                                    }
                                }
                                self.jumpToRedPacketDetail(redModel)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    func jumpToRedPacketDetail(_ model:FRedPacketMessageModel, _ isLook:Bool = false) {
        let vc = FReceiveMoneyDetailViewController()
        vc.redPacketDict = model.modelToJSONObject() as! [AnyHashable : Any]
        vc.isLook = isLook
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func jumpToZhuanzhangDetail(_ model:FRedPacketMessageModel, _ isLook:Bool = false) {
        let vc = FReceiveTransferViewController()
        vc.redPacketDict = model.modelToJSONObject() as! Dictionary<String, Any>
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func sendText(text: String?, attribute: NSAttributedString?) {
        guard let content = text, content.count > 0 else {
            return
        }
        let str = AESUtil.aesEncrypt(text ?? "", andKey: "wallstreetimchat")
        super.sendText(text: str, attribute: attribute)
    }
}
