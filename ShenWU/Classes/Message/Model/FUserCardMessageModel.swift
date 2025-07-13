//
//  FUserCardMessageModel.swift
//  Fiesta
//
//  Created by Amy on 2024/6/12.
//

import UIKit
import NEChatUIKit
import NIMSDK

@objcMembers
class FUserCardMessageModel: NSObject, NIMCustomAttachment, NECustomAttachmentProtocol {
    @objc  public var customType: Int = 10086
    @objc  public var cellHeight: CGFloat = 0
    @objc public var avatar: String?
    @objc public var memberCode: String?
    @objc public var name: String?
    
    func encode() -> String {
        let info = ["avatar": avatar ?? "", "memberCode": memberCode ?? "", "name": name ?? ""] as [String: Any]
        
        let jsonData: String = FDataTool.convert(toJsonData: info)
        let para = ["type":customType, "data":jsonData] as [String : Any]
        print("para === :\(para)")
        let content: String = FDataTool.convert(toJsonData: para)
        return content
    }
    
}
