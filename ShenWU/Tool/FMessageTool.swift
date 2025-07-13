//
//  FMessageTool.swift
//  Fiesta
//
//  Created by Amy on 2024/6/5.
//

import Foundation
import NIMSDK

public func messageContent(message: NIMMessage) -> String {
    var text = ""
    switch message.messageType {
    case .text:
        if let messageText = message.text {
            text = messageText
        }
    case .audio:
        text = "[语音]"
    case .image:
        text = "[图片]"
    case .video:
        text = "[视频]"
    case .location:
        text = "[位置]"
    case .notification:
        text = "[通知]"
    case .file:
        text = "[文件]"
    case .tip:
        if let messageText = message.text {
            text = messageText
        }
    default:
        text = "[未知]"
    }
    
    return text
}

func showRedPacket(_ model:FRedPacketMessageModel, sessionId:String, _ successBlock:@escaping (_ dict: [AnyHashable : Any]) -> ()) {
    FNetworkManager.shared().postRequest(fromServer: "/red/checkRedpacet", parameters: ["redpacketId":Int(model.redPacketId ?? "") ?? 0,"createTime":model.createTime ?? ""]) { response in
        if let code = response["code"] as? Int {
            if code == 200 || code == 10022 {
                let dataDict:[String:Any] = response["data"] as? [String:Any] ?? ["type":1]
                let type = dataDict["type"] as? Int ?? 1
            
                
                if type == 1 {
                    /// 可领取
                    let view:FLookRedPacketView = FLookRedPacketView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight));
                    view.sessionId = sessionId
                    view.loadData(dataDict, modelDict: model.modelToJSONObject() as! [AnyHashable : Any]) { data in
                        successBlock(data)
                    }
                    kKeyWindow.addSubview(view)
                }else if type == 2 {
                    /// 已领完
                    let view = FLookRedPacketView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight));
                    view.sessionId = sessionId
                    view.loadData(dataDict, modelDict: model.modelToJSONObject() as! [AnyHashable : Any]) { data in
                        successBlock(data)
                    }
                    kKeyWindow.addSubview(view)
                }else if type == 3 {
                    /// 红包已退款，当前用户未领取
                    let view = FLookRedPacketView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight));
                    view.sessionId = sessionId
                    view.loadData(dataDict, modelDict: model.modelToJSONObject() as! [AnyHashable : Any]) { data in
                        successBlock(data)
                    }
                    kKeyWindow.addSubview(view)
                }else if type == 4 || type == 5 {
                    /// 当前用户领取已领取过当前红包，展示领取详细信息
                    /// 当红包是个人/专属 ，当前非目标领取用户，直接显示查看领取详情
                    successBlock(response)
                }
            }else {
                SVProgressHUD.showError(withStatus: response["msg"] as? String ?? "")
            }
        }
    } failure: { error in
        
    }

}
