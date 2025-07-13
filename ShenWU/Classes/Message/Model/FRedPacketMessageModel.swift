//
//  FRedPacketMessageModel.swift
//  Fiesta
//
//  Created by Amy on 2024/6/12.
//

import UIKit
import NEChatUIKit
import NIMSDK

@objcMembers
class FRedPacketMessageModel: NSObject, NIMCustomAttachment, NECustomAttachmentProtocol {
    /// type == 21 专属 || type == 22 个人 || type == 23 群 || type == 28 转账
    public var customType: Int = 0
    public var cellHeight: CGFloat = 0
    
    /// 名字
    public var title: String?
    /// 红包金额
    public var amount: Double = 0.00
    public var redPacketId: String?
    public var sendName: String?
    public var sendAvatar: String?
    public var sendLevel: Int = 0
    public var received: Bool = false
    public var claimed: Bool = false
    public var skinUrl: String?
    public var fromUserId: String?
    public var toUserId: String?
    public var toUserName: String?
    public var createTime: String?
    
    /// 群主管理员的账号
    public var adminIds: [String] = []
    
    func encode() -> String {
        let info = ["title": title ?? "", "amount": amount, "redPacketId": redPacketId ?? "", "skinUrl": skinUrl ?? "", "sendName": sendName ?? "", "sendAvatar": sendAvatar ?? "", "sendLevel": sendLevel, "received": received, "claimed" : claimed, "fromUserId":fromUserId ?? "", "toUserId": toUserId ?? "","toUserName": toUserName ?? "", "createTime": createTime ?? "", "adminIds": adminIds] as [String: Any]
        let jsonData: String = FDataTool.convert(toJsonData: info)
        let para = ["type":customType, "data":jsonData] as [String : Any]
        print("para === :\(para)")
        let content: String = FDataTool.convert(toJsonData: para)
        return content
    }
    
    
    static func modelCustomPropertyMapper() -> [String:Any]? {
        return ["redPacketId":["id", "redPacketId"],"sendLevel":["level", "sendLevel"]]
    }
    
    
    
}

