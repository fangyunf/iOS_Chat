
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

@objc
@objcMembers
open class NEChatUIKitClient: NSObject {
  public static let instance = NEChatUIKitClient()
  private var customRegisterDic = [String: UITableViewCell.Type]()
  public var moreAction = [NEMoreItemModel]()
    
  override init() {
      let photo = NEMoreItemModel()
      photo.image = UIImage(named: "icn_more_album")
      photo.title = "相册"
      photo.type = .photo
      moreAction.append(photo)
      
      let picture = NEMoreItemModel()
      picture.image = UIImage(named: "icn_more_carme")
      picture.title = "拍摄"
      picture.type = .takePicture
      moreAction.append(picture)
  }

  /// 获取更多面板数据
  /// - Returns: 返回更多操作数据
  open func getMoreActionData(sessionType: NIMSessionType) -> [NEMoreItemModel] {
    var more = [NEMoreItemModel]()
    moreAction.forEach { model in
      if model.type != .rtc {
        more.append(model)
      } else if sessionType == .P2P {
        more.append(model)
      }
    }

    if let chatInputMenu = NEKitChatConfig.shared.ui.chatInputMenu {
      chatInputMenu(&more)
    }

    return more
  }

  /// 新增聊天页针对自定义消息的cell扩展，以及现有cell样式覆盖
  open func regsiterCustomCell(_ registerDic: [String: UITableViewCell.Type]) {
    registerDic.forEach { (key: String, value: UITableViewCell.Type) in
      customRegisterDic[key] = value
    }
  }

  open func getRegisterCustomCell() -> [String: UITableViewCell.Type] {
    customRegisterDic
  }
}
