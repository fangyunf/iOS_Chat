//
//  TKEggExplodeMessageModel.swift
//  ShenWU
//
//  Created by Amy on 2024/8/27.
//

import UIKit
import NEChatUIKit
import NIMSDK

@objcMembers
class TKEggExplodeMessageModel: NSObject, NIMCustomAttachment, NECustomAttachmentProtocol {
    /// type == 525
    public var customType: Int = 0
    public var cellHeight: CGFloat = 0
    
    /// 红包金额
    public var amount: Double = 0.00
    public var name: String?
    public var avatar: String?
    public var groupName: String?
    public var groupId: String?
    
    func encode() -> String {
        let info = ["amount": amount, "name": name ?? "", "avatar": avatar ?? "", "groupName": groupName ?? "", "groupId": groupName ?? ""] as [String: Any]
        let jsonData: String = FDataTool.convert(toJsonData: info)
        let para = ["type":customType, "data":jsonData] as [String : Any]
        print("para === :\(para)")
        let content: String = FDataTool.convert(toJsonData: para)
        return content
    }
    
    
//    static func modelCustomPropertyMapper() -> [String:Any]? {
//        return ["redPacketId":["id", "redPacketId"],"sendLevel":["level", "sendLevel"]]
//    }
}
