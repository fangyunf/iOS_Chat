
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

@objcMembers
open class ConversationListCell: NEBaseConversationListCell {
  override open func setupSubviews() {
    super.setupSubviews()

    NSLayoutConstraint.activate([
      headImge.leftAnchor.constraint(
        equalTo: contentView.leftAnchor,
        constant: NEConstant.screenInterval
      ),
      headImge.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      headImge.widthAnchor.constraint(equalToConstant: 45),
      headImge.heightAnchor.constraint(equalToConstant: 45),
    ])

    NSLayoutConstraint.activate([
      title.leftAnchor.constraint(equalTo: headImge.rightAnchor, constant: 11),
      title.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: -5),
      title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      title.heightAnchor.constraint(equalToConstant: 22),
    ])

    NSLayoutConstraint.activate([
      notifyMsg.rightAnchor.constraint(equalTo: redTagView.leftAnchor, constant: -5),
      notifyMsg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 37),
      notifyMsg.widthAnchor.constraint(equalToConstant: 13),
      notifyMsg.heightAnchor.constraint(equalToConstant: 13),
    ])
  }

  override func initSubviewsLayout() {
    if NEKitConversationConfig.shared.ui.conversationProperties.avatarType == .rectangle {
      headImge.layer.cornerRadius = NEKitConversationConfig.shared.ui.conversationProperties.avatarCornerRadius
    } else if NEKitConversationConfig.shared.ui.conversationProperties.avatarType == .cycle {
        headImge.layer.cornerRadius = 4
    } else {
      headImge.layer.cornerRadius = 4
    }
  }

  override open func configData(sessionModel: ConversationListModel?) {
    super.configData(sessionModel: sessionModel)

    // backgroundColor
    if let session = sessionModel?.recentSession?.session {
      let isTop = topStickInfos[session] != nil
      if isTop {
        contentView.backgroundColor = NEKitConversationConfig.shared.ui.conversationProperties.itemStickTopBackground ?? UIColor(hexString: "0xf7f7f7")
      } else {
          contentView.backgroundColor = NEKitConversationConfig.shared.ui.conversationProperties.itemBackground ?? UIColor.white
      }
        bgView.backgroundColor = contentView.backgroundColor;
    }
  }
}
