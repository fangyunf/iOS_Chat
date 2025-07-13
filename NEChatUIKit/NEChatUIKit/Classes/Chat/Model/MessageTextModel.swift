
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NECommonKit
import NIMSDK
import CryptoSwift

@objcMembers
open class MessageTextModel: MessageContentModel {
  public var attributeStr: NSMutableAttributedString?
  public var textHeight: CGFloat = 0

  public required init(message: NIMMessage?) {
    super.init(message: message)
    type = .text

      let str = MessageTextModel.aes_decrypt(message?.text ?? "", aes_key: "wallstreetimchat")
      if message?.isOutgoingMsg != nil && message?.isOutgoingMsg == true {
          attributeStr = NEEmotionTool.getAttWithStr(str: str.count == 0 ? message?.text ?? "" : str, font: UIFont.systemFont(ofSize: NEKitChatConfig.shared.ui.messageProperties.messageTextSize), color: .black)
      }else{
          attributeStr = NEEmotionTool.getAttWithStr(str: str.count == 0 ? message?.text ?? "" : str, font: UIFont.systemFont(ofSize: NEKitChatConfig.shared.ui.messageProperties.messageTextSize), color: .black)
      }

    if let remoteExt = message?.remoteExt, let dic = remoteExt[yxAtMsg] as? [String: AnyObject] {
      dic.forEach { (key: String, value: AnyObject) in
        if let contentDic = value as? [String: AnyObject] {
          if let array = contentDic[atSegmentsKey] as? [AnyObject] {
            if let models = NSArray.yx_modelArray(with: MessageAtInfoModel.self, json: array) as? [MessageAtInfoModel] {
              models.forEach { model in
                if attributeStr?.length ?? 0 > model.end {
                    attributeStr?.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(model.start, model.end - model.start + atRangeOffset))
                }
              }
            }
          }
        }
      }
    }

    let textSize = attributeStr?.finalSize(.systemFont(ofSize: NEKitChatConfig.shared.ui.messageProperties.messageTextSize), CGSize(width: chat_text_maxW, height: CGFloat.greatestFiniteMagnitude)) ?? .zero

    textHeight = textSize.height
    contentSize = CGSize(width: textSize.width + chat_content_margin * 2, height: textHeight + chat_content_margin * 2)
    height = contentSize.height + chat_content_margin * 2 + fullNameHeight
  }
    
    class func aes_decrypt(_ str:String , aes_key:String) -> String{
        
        //decode base64
        
        let data = Data(base64Encoded: str, options: .ignoreUnknownCharacters) ?? Data()
        
        var decrypted: [UInt8] = []
        
        do {
            
            // decode AES
            decrypted = try AES(key: Array(aes_key.utf8), blockMode: ECB(), padding: .pkcs7).decrypt(data.bytes);
            
        } catch {
            print(error.localizedDescription)
            return str
        }
        
        //解密结果从data转成string 转换失败  返回""
//        return ""
        return String(bytes: Data(decrypted).bytes, encoding: .utf8) ?? ""
        
    }
}
