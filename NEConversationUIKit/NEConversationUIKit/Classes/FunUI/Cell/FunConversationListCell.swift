// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

@objcMembers
open class FunConversationListCell: NEBaseConversationListCell {
  var contentModel: ConversationListModel?

  override open func setupSubviews() {
    super.setupSubviews()
    NSLayoutConstraint.activate([
      headImge.leftAnchor.constraint(
        equalTo: contentView.leftAnchor,
        constant: NEConstant.screenInterval
      ),
      headImge.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      headImge.widthAnchor.constraint(equalToConstant: 55),
      headImge.heightAnchor.constraint(equalToConstant: 55),
    ])

    title.font = .systemFont(ofSize: NEKitConversationConfig.shared.ui.conversationProperties.itemTitleSize > 0 ? NEKitConversationConfig.shared.ui.conversationProperties.itemTitleSize : 17)
    NSLayoutConstraint.activate([
      title.leftAnchor.constraint(equalTo: headImge.rightAnchor, constant: 12),
      title.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: -5),
      title.topAnchor.constraint(equalTo: headImge.topAnchor, constant: 4),
    ])

    let bottomLine = UIView()
    bottomLine.translatesAutoresizingMaskIntoConstraints = false
    bottomLine.backgroundColor = .funConversationListLineBorderColor
    contentView.addSubview(bottomLine)
    NSLayoutConstraint.activate([
      bottomLine.leftAnchor.constraint(equalTo: title.leftAnchor),
      bottomLine.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      bottomLine.heightAnchor.constraint(equalToConstant: 0.5),
      bottomLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])

    NSLayoutConstraint.activate([
      notifyMsg.rightAnchor.constraint(equalTo: redTagView.leftAnchor, constant: -5),
      notifyMsg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 37),
      notifyMsg.widthAnchor.constraint(equalToConstant: 14),
      notifyMsg.heightAnchor.constraint(equalToConstant: 14),
    ])
  }

  override func initSubviewsLayout() {
    if NEKitConversationConfig.shared.ui.conversationProperties.avatarType == .rectangle {
      headImge.layer.cornerRadius = NEKitConversationConfig.shared.ui.conversationProperties.avatarCornerRadius
    } else if NEKitConversationConfig.shared.ui.conversationProperties.avatarType == .cycle {
      headImge.layer.cornerRadius = 24.0
    } else {
      headImge.layer.cornerRadius = 4.0
    }
  }

  override open func configData(sessionModel: ConversationListModel?) {
    super.configData(sessionModel: sessionModel)
    contentModel = sessionModel

    // backgroundColor
    if let session = sessionModel?.recentSession?.session {
      let isTop = topStickInfos[session] != nil
      if isTop {
        contentView.backgroundColor = NEKitConversationConfig.shared.ui.conversationProperties.itemStickTopBackground ?? .funConversationBackgroundColor
      } else {
        contentView.backgroundColor = NEKitConversationConfig.shared.ui.conversationProperties.itemBackground ?? .white
      }
    }
  }
}
