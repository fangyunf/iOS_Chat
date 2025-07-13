//
//  FConversationListViewController.swift
//  Fiesta
//
//  Created by Amy on 2024/6/5.
//

import UIKit
import NEConversationUIKit
import NEChatUIKit
import Masonry
import YYKit

@objc
public protocol FConversationListDelegate {
    func conversationListSelectedTableRow(sessionType: NIMSessionType, sessionId: String, indexPath: IndexPath);
}

open class FConversationListViewController: ConversationController {
    var tableDelegate : FConversationListDelegate?
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override open func setupSubviews() {
        super.setupSubviews()
        
        tableView.rowHeight = 64
        tableView.backgroundColor = .white
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func onselectedTableRow(sessionType: NIMSessionType, sessionId: String, indexPath: IndexPath) {
        if (tableDelegate != nil) {
            tableDelegate?.conversationListSelectedTableRow(sessionType: sessionType, sessionId: sessionId, indexPath: indexPath)
        }
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model:ConversationListModel? = filterConversationList()[indexPath.row]
        let reusedId = "\(model?.customType ?? 0)"
        let cell = tableView.dequeueReusableCell(withIdentifier: reusedId, for: indexPath)
        
        if let c = cell as? NEBaseConversationListCell {
            c.backgroundColor = UIColor.white
            c.contentView.backgroundColor = UIColor.white
            c.topStickInfos = viewModel.stickTopInfos
            c.configData(sessionModel: model)
            if model?.recentSession?.session?.sessionId == FMessageManager.shared().serviceUserId {
                c.title.text = "客服"
                c.headImge.image = UIImage(named: "avatar_person")
                c.subTitle.isHidden = true
                c.subTitle.attributedText = nil
                c.memberCodeLabel.isHidden = true
                c.levelImgView.isHidden = true
                c.headFrameImge.isHidden = true
            }
            c.subTitle.isHidden = false
            if model?.recentSession?.session?.sessionType == .P2P {
                if let alias = model?.userInfo?.alias {
                    c.title.text = alias
                }else {
                    c.title.text = model?.userInfo?.userInfo?.nickName
                }
                if model?.recentSession?.session?.sessionId != FMessageManager.shared().aideNewsUserId {
                    let friendModel = FUserRelationManager.shared().allFriendDict[model?.recentSession?.session?.sessionId as Any] as? FFriendModel
                    if friendModel != nil {
                        model?.userInfo?.userInfo?.avatarUrl = friendModel?.avatar ?? ""
                        model?.userInfo?.userInfo?.nickName = friendModel?.remark.count ?? 0 > 0 ? friendModel?.remark:friendModel?.name
                        c.headImge.sd_setImage(with: URL.init(string: friendModel?.avatar ?? ""), placeholderImage: UIImage(named: "avatar_person"))
                        c.title.text = friendModel?.remark.count ?? 0 > 0 ? friendModel?.remark:friendModel?.name
                    }else{
                        c.headImge.image = UIImage(named: "avatar_person")
                    }
                }
                
                
                if FUserRelationManager.shared().allFriendDict.count > 0 && model != nil && model?.recentSession != nil && model?.recentSession?.session != nil && model?.recentSession?.session?.sessionId != nil {
                    if model?.recentSession?.session?.sessionId == FMessageManager.shared().aideNewsUserId {
                        c.title.text = "小助手"
                        c.headImge.image = UIImage(named: "avatar_helper")
                        c.subTitle.isHidden = true
                        c.subTitle.attributedText = nil
                        c.memberCodeLabel.isHidden = true
                        c.levelImgView.isHidden = true
                        c.headFrameImge.isHidden = true
                    }else{
                        let friendModel = FUserRelationManager.shared().allFriendDict[(model?.recentSession?.session?.sessionId ?? "") as String] as? FFriendModel
                        
                        if friendModel != nil {
//                            c.redTagView.isHidden = true
                            let titleSize = ((c.title.text ?? "")  as NSString).size(for: c.title.font, size: CGSizeMake(kScreenWidth - 49 - 42 - 132, 22), mode: .byWordWrapping)
//                            if friendModel!.grade > 0 {
//                                c.headFrameImge.image = UIImage(named: "avatar_frame_\(friendModel!.grade)")
//                                c.levelImgView.frame = CGRectMake(titleSize.width + 69, 11, 42, 16)
//                                c.levelImgView.image = UIImage(named: "icn_level_tag_\(friendModel!.grade)")
//                                c.headFrameImge.isHidden = false
//                                c.levelImgView.isHidden = false
//                                c.memberCodeLabel.frame = CGRectMake(titleSize.width+69+46, 13, 80, 16)
//                            }else{
                                c.headFrameImge.isHidden = true
                                c.levelImgView.isHidden = true
                                c.memberCodeLabel.frame = CGRectMake(titleSize.width+69, 13, 80, 16)
//                            }
                            c.memberCodeLabel.isHidden = false
                            c.memberCodeLabel.text = "ID:\(friendModel!.memberCode)"
                        }else{
                            c.memberCodeLabel.isHidden = true
                            c.levelImgView.isHidden = true
                            c.headFrameImge.isHidden = true
                        }
                    }
                }
                c.memberCodeLabel.isHidden = true
            }else{
                let groupModel = FUserRelationManager.shared().allGroupsDict[model?.recentSession?.session?.sessionId as Any] as? FGroupModel
                if groupModel != nil {
                    print("groupModelAvatar == :\(groupModel?.head ?? "")")
                    model?.userInfo?.userInfo?.avatarUrl = groupModel?.head ?? ""
                    model?.userInfo?.userInfo?.nickName = groupModel?.name
                    c.headImge.sd_setImage(with: URL.init(string: groupModel?.head ?? ""), placeholderImage: UIImage(named: "avatar_group"))
                    c.title.text = groupModel?.name
                }
                c.headFrameImge.isHidden = true
                c.levelImgView.isHidden = true
                c.memberCodeLabel.isHidden = true
            }
            if let lastMessage = model?.recentSession?.lastMessage {
                if lastMessage.messageType == .custom {
                    var text = ""
                    let object : NIMCustomObject = lastMessage.messageObject as! NIMCustomObject;
                    if let attachment = object.attachment {
                        if (attachment.isKind(of: FUserCardMessageModel.classForCoder())) {
                            text = "[名片]"
                        }else if (attachment.isKind(of: FRedPacketMessageModel.classForCoder())) {
                            let redM: FRedPacketMessageModel = attachment as! FRedPacketMessageModel
                            var stateStr = ""
                            if redM.customType == 21 {
                                stateStr = "[专属红包]"
                            }else if redM.customType == 22 {
                                stateStr = "[个人红包]"
                            }else if redM.customType == 23 {
                                stateStr = "[群红包]"
                            }else if redM.customType == 28 {
                                stateStr = "[转账]"
                            }else {
                                stateStr = "[红包]"
                            }
                            text = stateStr + (redM.title ?? "")
                        }
                    }
                    let mutaAttri = NSMutableAttributedString(string: text)
                    if let sessionId = model?.recentSession?.session?.sessionId {
                        let isAtMessage = NEAtMessageManager.instance?.isAtCurrentUser(sessionId: sessionId)
                        if isAtMessage == true {
                            let atStr = "[有人@您]"
                            mutaAttri.insert(NSAttributedString(string: atStr), at: 0)
                            mutaAttri.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#E6605C") as Any, range: NSMakeRange(0, atStr.count))
                            mutaAttri.addAttribute(NSAttributedString.Key.font, value: UIFont .systemFont(ofSize: 12), range: NSMakeRange(0, mutaAttri.length))
                        }
                    }
                    c.subTitle.attributedText = mutaAttri
                }else if lastMessage.messageType == .text {
                    let text = c.contentForRecentSession(message: lastMessage)
                    let textStr = AESUtil.aesDecrypt(text, andKey: "wallstreetimchat")
                    let endStr = textStr.count == 0 ? text : textStr
                    let mutaAttri = NSMutableAttributedString(string: endStr)
                    if let sessionId = model?.recentSession?.session?.sessionId {
                        let isAtMessage = NEAtMessageManager.instance?.isAtCurrentUser(sessionId: sessionId)
                        if isAtMessage == true {
                            let atStr = "[有人@您]"
                            mutaAttri.insert(NSAttributedString(string: atStr), at: 0)
                            mutaAttri.addAttribute(NSAttributedString.Key.foregroundColor, value:  UIColor(hexString: "#E6605C") as Any, range: NSMakeRange(0, atStr.count))
                            mutaAttri.addAttribute(NSAttributedString.Key.font, value: UIFont .systemFont(ofSize: 12), range: NSMakeRange(0, mutaAttri.length))
                        }
                    }
                    c.subTitle.attributedText = mutaAttri
                }else if lastMessage.messageType == .tip {
                    let text = "[通知]"
                    let mutaAttri = NSMutableAttributedString(string: text)
                    if let sessionId = model?.recentSession?.session?.sessionId {
                        let isAtMessage = NEAtMessageManager.instance?.isAtCurrentUser(sessionId: sessionId)
                        if isAtMessage == true {
                            let atStr = "[有人@您]"
                            mutaAttri.insert(NSAttributedString(string: atStr), at: 0)
                            mutaAttri.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#E6605C") as Any, range: NSMakeRange(0, atStr.count))
                            mutaAttri.addAttribute(NSAttributedString.Key.font, value: UIFont .systemFont(ofSize: 12), range: NSMakeRange(0, mutaAttri.length))
                        }
                    }
                    c.subTitle.attributedText = mutaAttri // contentForRecentSession(message: lastMessage)
                }
            }
        }
        return cell
    }
}

@objcMembers
open class FConversationListShowVc: UIViewController {
    private var listVc = FConversationListViewController()
    weak public var delegate : FConversationListDelegate?
    public var allConversationList:Array<ConversationListModel> = Array<ConversationListModel>()
    
    open override func viewDidLoad() {
        NEChatUIKitClient.instance.regsiterCustomCell(["10086": FUserCardMessageCell.self])
        NEChatUIKitClient.instance.regsiterCustomCell(["21": FRedPacketMessageCell.self])
        NEChatUIKitClient.instance.regsiterCustomCell(["22": FRedPacketMessageCell.self])
        NEChatUIKitClient.instance.regsiterCustomCell(["23": FRedPacketMessageCell.self])
        NEChatUIKitClient.instance.regsiterCustomCell(["28": FRedPacketMessageCell.self])
        
        super.viewDidLoad()
        NEKitConversationConfig.shared.ui.showTitleBar = false
        NEKitConversationConfig.shared.ui.stickTopBottonTitle = "置顶"
        NEKitConversationConfig.shared.ui.stickTopBottonCancelTitle = "取消置顶"
        NEKitConversationConfig.shared.ui.deleteBottonTitle = "删除"
        listVc.serviceUserId = FMessageManager.shared().serviceUserId
        listVc.aideNewsUserId = FMessageManager.shared().aideNewsUserId
        listVc.viewModel.aideNewsUserId = FMessageManager.shared().aideNewsUserId
        listVc.view.translatesAutoresizingMaskIntoConstraints = false
        listVc.tableDelegate = self
        //将NEConversationListCtrl添加到自己的控制器
        self.addChild(listVc)
        self.view.addSubview(listVc.view)
        listVc.tableView.layer.masksToBounds = true
        listVc.tableView.separatorStyle = .none
        listVc.tableView.backgroundColor = .white
        listVc.tableView.separatorColor = .white
        listVc.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        listVc.view.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self.view)?.offset()(0)
            make?.top.equalTo()(self.view)?.offset()(0)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkExistGroup), name: NSNotification.Name("checkGroup"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setServiceUserId), name: NSNotification.Name("serviceUserId"), object: nil)
//        filerConversation(selectIndex: 100)
    }
    
    func filerConversation (selectIndex:Int) {
        listVc.reloadTableView()
    }
    
    func setAppear(isAppear:Bool){
        listVc.isAppear = isAppear
    }
    
    func reloadTableView () {
        listVc.reloadTableView()
    }
    
    func setServiceUserId () {
        listVc.serviceUserId = FMessageManager.shared().serviceUserId
    }
    
    @objc func searchData (content:String) {
        listVc.searchContent = content
        listVc.reloadTableView()
//        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
//            listVc.reloadTableView()
//        }
    }
    
    @objc func setSelectType (type:NIMSessionType) {
//        listVc.isFilterType = true
        listVc.selectType = type
    }
    
    func checkExistGroup(){
        if listVc.viewModel.conversationListArray != nil {
            for groupId in FUserRelationManager.shared().allGroupsDict.allKeys {
                if listVc.viewModel.conversationListArray!.filter({($0.recentSession?.session?.sessionId ?? "") == groupId as! String}).count == 0 {
                    listVc.viewModel.isAddNumber = listVc.viewModel.isAddNumber+1
                    let session = NIMSession(groupId as! String, type: .team)
                    let option = NIMAddEmptyRecentSessionBySessionOption()
                    option.withLastMsg = true
                    option.addEmptyMsgIfNoLastMsgExist = false
                    NIMSDK.shared().conversationManager.addEmptyRecentSession(by: session, option: option)
                }
            }
        }
    }
}


extension FConversationListShowVc : FConversationListDelegate {
    public func conversationListSelectedTableRow(sessionType: NIMSessionType, sessionId: String, indexPath: IndexPath) {
        if (self.delegate != nil) {
            self.delegate?.conversationListSelectedTableRow(sessionType: sessionType, sessionId: sessionId, indexPath: indexPath)
        }
    }
}

extension String {
    func matchSearch(_ content:String) -> Bool{
        let pinyin = convertToPinyin(self).lowercased()
        if(self.contains(content.lowercased()) || pinyin.contains(content.lowercased()))
        {
            return true
        }else{
            return false
        }
    }
    
    func convertToPinyin(_ input: String) -> String {
        let mutableString = NSMutableString(string: input) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        return mutableString as String
    }
}
