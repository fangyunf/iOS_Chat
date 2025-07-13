//
//  FTeamChatViewController.swift
//  Fiesta
//
//  Created by Amy on 2024/6/5.
//

import UIKit
import NEChatUIKit
import NEChatKit
import NIMSDK

@objc
public protocol FTeamChatDelegate {
    func teamRedPacketAction(model:MessageContentModel)
    func teamKickoutAction(model:MessageContentModel)
    func teamAvatarAction(model:MessageContentModel)
    func switchBtnAction(model:MessageContentModel, user:FGroupUserInfoModel?)
    
}

@objcMembers class FTeamChatViewController: GroupChatViewController {
    var msgContentModel:MessageContentModel?
    weak var teamChatDelegate : FTeamChatDelegate?
    public var memberList :[FGroupUserInfoModel] = [FGroupUserInfoModel]()
    var clickUser:FGroupUserInfoModel?
    var popover:Popover?
    var sessionId:String = ""
    override init(sessionId: String) {
        super.init(sessionId: sessionId)
        self.sessionId = sessionId
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("SearchMessageRouter == :\(SearchMessageRouter)")
        // Do any additional setup after loading the view.
    }
    
    @objc func setGroupName(name:String) {
        setTeamTitle(name: name)
    }
    
    @objc func setMemberList(list:[FGroupUserInfoModel]) {
        memberList = list
        tableView.reloadData()
    }
    
    @objc func atUserAction() {
        addToAtUserAction(model: msgContentModel)
        popover?.dismiss()
    }
    
    @objc func redPacketAction() {
        if msgContentModel != nil {
            teamChatDelegate?.teamRedPacketAction(model: msgContentModel!)
        }
        popover?.dismiss()
    }
    
    @objc func kickoutAction() {
        if msgContentModel != nil {
            teamChatDelegate?.teamKickoutAction(model: msgContentModel!)
        }
        
        popover?.dismiss()
    }
    
    @objc func switchBtnAction() {
        if msgContentModel != nil {
            teamChatDelegate?.switchBtnAction(model: msgContentModel!, user: clickUser)
        }
        
        popover?.dismiss()
    }
    
    open override func setOperationItems(items: inout [OperationItem], model: MessageContentModel?) {
//        if model?.type == .text || model?.type == .image {
//            let item = OperationItem()
//            item.text = "收藏"
//            item.imageName = "op_collection"
//            item.type = .collection
//            
//            items.append(item)
//            
//            let item1 = OperationItem()
//            item1.text = "转发"
//            item1.imageName = "op_forward"
//            item1.type = .forward
//            
//            items.append(item1)
//        }
        
        items.forEach { item in
            if !(item.type == .copy || item.type == .delete || item.type == .forward || item.type == .collection || item.type == .recall) {
                let index = items.firstIndex(of: item)
                items.remove(at: index ?? 0)
            }
        }
        print(items)
    }
    
    override func didTapAvatarView(_ cell: UITableViewCell, _ model: MessageContentModel?) {
        if model != nil {
            teamChatDelegate?.teamAvatarAction(model: model!)
        }
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
                if let c = cell as? NEBaseChatMessageCell {
                    c.setModel(c.contentModel ?? MessageContentModel(message: c.contentModel?.message))
                    var level = 0
                    for item in memberList {
                        if c.contentModel?.message?.from == item.userId {
                            level = item.grade
                        }
                    }
                    if ((c.contentModel?.message?.isOutgoingMsg) != nil && (c.contentModel?.message?.isOutgoingMsg)!) {
                        if level > 0 {
                            c.avatarFrameRight.isHidden = false
                            c.avatarFrameRight.image = UIImage(named: "avatar_frame_\(level)")
                        }else{
                            c.avatarFrameRight.isHidden = true
                        }
                    }else{
                        if level > 0 {
                            c.avatarFrameLeft.isHidden = false
                            c.avatarFrameLeft.image = UIImage(named: "avatar_frame_\(level)")
                        }else{
                            c.avatarFrameLeft.isHidden = true
                        }
                    }
                    return c
                }
                return cell
//        let model = viewmodel.messages[indexPath.row]
//        if let c = cell as? NEBaseChatMessageCell {
//            c.tagLeftLabel.isHidden = true
//            c.tagRightLabel.isHidden = true
//            var userModel:FGroupUserInfoModel?
//            if let m = model as? MessageContentModel {
//                if ((m.message?.isOutgoingMsg) != nil) && m.message?.isOutgoingMsg == false {
//                    for data in memberList {
//                        if m.message?.from == data.userId {
//                            userModel = data
//                        }
//                    }
//                    if userModel != nil {
//                        if userModel?.rankState == 1 {
//                            c.tagLeftLabel.isHidden = false
//                            c.tagLeftLabel.text = "群主"
//                        }else if userModel?.rankState == 2 {
//                            c.tagLeftLabel.isHidden = false
//                            c.tagLeftLabel.text = "管理员"
//                        }
//                    }
//                }
//
//            }
//        }
        
        return cell
    }
    
    override func didLongPressAvatar(_ cell: UITableViewCell, _ model: MessageContentModel?) {
        var userInfoModel:FGroupUserInfoModel?
        for item in memberList {
            if item.userId == model?.message?.from ?? "" {
                userInfoModel = item
            }
        }
        if userInfoModel != nil {
            showPop(cell, model, userInfoModel)
        }else{
            var params = [String:String]()
            params["userId"] = model?.message?.from ?? ""
            params["groupId"] = viewmodel.session.sessionId
            params["page"] = "1"
            FNetworkManager.shared().postRequest(fromServer: "/group/groupUserListPost", parameters: params) { [self] result in
                print("\(result["data"])")
                let list:Array<[String:Any]> = result["data"] as! Array<[String:Any]>
                let userInfoModel = FGroupUserInfoModel.model(with: list.first ?? [String:Any]())
                showPop(cell, model, userInfoModel)
            } failure: { [self] error in
                showPop(cell, model, nil)
            }
        }
        

       
    }
    
    func showPop(_ cell: UITableViewCell, _ model: MessageContentModel?, _ userInfoModel:FGroupUserInfoModel?){
        clickUser = userInfoModel
        let tempCell:NEBaseChatMessageCell = cell as! NEBaseChatMessageCell
        let indexPath = tableView.indexPath(for: tempCell) ?? IndexPath(row: 0, section: 0)
        let rect = tableView.convert(tableView.rectForRow(at: indexPath), to: kKeyWindow)
        
        msgContentModel = model;
        
        var startPoint = CGPoint(x: rect.origin.x+31, y: rect.origin.y+44)
        if tempCell.timeLabel.isHidden {
            startPoint = CGPoint(x: rect.origin.x+31, y: rect.origin.y+26)
        }
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 120))
        if userInfoModel != nil {
            aView.frame = CGRect(x: 0, y: 0, width: 100, height: 160)
        }else{
            aView.frame = CGRect(x: 0, y: 0, width: 100, height: 120)
        }
        
        let atBtn = createButton(title: "@此人", font: regularFont(16), textColor: UIColor.black, target: self, sel: #selector(atUserAction))
        atBtn.frame = CGRectMake(0, 15, 100, 35)
        aView.addSubview(atBtn)
        
        let redBtn = createButton(title: "专属红包", font: regularFont(16), textColor: UIColor.black, target: self, sel: #selector(redPacketAction))
        redBtn.frame = CGRectMake(0, 50, 100, 35)
        aView.addSubview(redBtn)
        
        if userInfoModel != nil {
            var title = ""
            if userInfoModel?.forbidState != nil && userInfoModel?.forbidState == true {
                title = "取消禁抢"
            }else{
                title = "禁止抢包"
            }
            let switchBtn = createButton(title: title, font: regularFont(16), textColor: UIColor.black, target: self, sel: #selector(switchBtnAction))
            switchBtn.frame = CGRectMake(0, 85, 100, 35)
            aView.addSubview(switchBtn)
            
            let kickoutBtn = createButton(title: "踢除此人", font: regularFont(16), textColor: UIColor.black, target: self, sel: #selector(kickoutAction))
            kickoutBtn.frame = CGRectMake(0, 120, 100, 35)
            aView.addSubview(kickoutBtn)
        }else {
            let kickoutBtn = createButton(title: "踢除此人", font: regularFont(16), textColor: UIColor.black, target: self, sel: #selector(kickoutAction))
            kickoutBtn.frame = CGRectMake(0, 85, 100, 35)
            aView.addSubview(kickoutBtn)
        }
        
        
        
        popover = Popover()
        popover?.popoverType = .down
        popover?.arrowSize = CGSize(width: 10, height: 10)
        popover?.show(aView, point: startPoint)
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
                        showRedPacket(redModel,sessionId: self.sessionId) { dict in
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
    
    func jumpToRedPacketDetail(_ model:FRedPacketMessageModel, _ isLook:Bool = false) {
        let vc = FReceiveMoneyDetailViewController()
        vc.redPacketDict = model.modelToJSONObject() as! [AnyHashable : Any]
        vc.isLook = isLook
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sendText(text: String?, attribute: NSAttributedString?) {
        guard let content = text, content.count > 0 else {
            return
        }
        let str = AESUtil.aesEncrypt(text ?? "", andKey: "wallstreetimchat")
        super.sendText(text: str, attribute: attribute)
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
