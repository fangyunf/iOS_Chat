
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import UIKit

@objcMembers
open class NEBaseChatMessageTipCell: UITableViewCell {
  var timeLabelHeightAnchor: NSLayoutConstraint? // 消息时间高度约束
var clickType = 0
  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    backgroundColor = .clear
    commonUI()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open func commonUI() {
    contentView.addSubview(timeLabel)
    timeLabelHeightAnchor = timeLabel.heightAnchor.constraint(equalToConstant: 22)
    NSLayoutConstraint.activate([
      timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
      timeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
      timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
      timeLabelHeightAnchor!,
    ])

    contentView.addSubview(contentLabel)
    NSLayoutConstraint.activate([
      contentLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
      contentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      contentLabel.widthAnchor.constraint(equalToConstant: chat_content_maxW),
    ])
      
      contentView.addSubview(linkBtn)
      linkBtn.addTarget(self, action: #selector(linkBtnAction), for: .touchUpInside)
  }
    
    @objc func linkBtnAction() {
        if clickType == 1 {
            NotificationCenter.default.post(name: NSNotification.Name("lookAnnouncement"), object: nil)
        }
    }

  func setModel(_ model: MessageTipsModel) {
    // time
    if let time = model.timeContent, !time.isEmpty {
      timeLabelHeightAnchor?.constant = chat_timeCellH
      timeLabel.text = time
      timeLabel.isHidden = false
    } else {
      timeLabelHeightAnchor?.constant = 0
      timeLabel.text = ""
      timeLabel.isHidden = true
    }
      if((model.text?.contains("群公告")) != nil && model.text!.contains("群公告")){
          clickType = 1
          linkBtn.isHidden = false
          let content = (model.text ?? "")+" 查看" as NSString
          let attStr = NSMutableAttributedString(string: content as String)
          
          attStr.addAttributes([NSAttributedString.Key.font:contentLabel.font as Any], range:  NSRange(location: 0, length: content.length))
          attStr.addAttributes([NSAttributedString.Key.foregroundColor:contentLabel.textColor as Any], range: NSRange(location: 0, length: content.length))
          let range = content.range(of: "查看")
          attStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14) as Any], range: range)
          attStr.addAttributes([NSAttributedString.Key.foregroundColor:HexRGB(0x8B5FD8) as Any], range: range)
          contentLabel.attributedText = attStr
          
          let contentWidth = content.size(withAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]).width
          let linkWidth = (" 查看" as NSString).size(withAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]).width
          print("Width ==== :\(linkWidth)  \(contentWidth)")
          if let time = model.timeContent, !time.isEmpty {
              linkBtn.frame = CGRectMake(kScreenWidth/2 + contentWidth/2 - linkWidth, 22, linkWidth, 22);
          }else{
              linkBtn.frame = CGRectMake(kScreenWidth/2 + contentWidth/2 - linkWidth, 0, linkWidth, 22);
          }
          
      } else if((model.text?.contains("sendUserId")) != nil && model.text!.contains("sendUserId") && (model.text?.contains("receiveUserId")) != nil && model.text!.contains("receiveUserId")){
          let dict = getDictionaryFromJSONString(model.text ?? "")
          var userId:String = ""
          if UserDefaults.standard.object(forKey: "CurrentUserId") != nil {
              userId = UserDefaults.standard.object(forKey: "CurrentUserId") as! String
          }
          if userId == dict?["receiveUserId"] as! String {
              contentLabel.text = "你 领取了 \(dict?["sendUserName"] ?? "") 的红包"
          }else if userId == dict?["sendUserId"] as! String {
              contentLabel.text = "\(dict?["receiveUserName"] ?? "") 领取了 你 的红包"
          }else {
              contentLabel.text = "\(dict?["receiveUserName"] ?? "") 领取了 \(dict?["sendUserName"] ?? "") 的红包"
          }
          
      } else{
          linkBtn.isHidden = true
          contentLabel.text = model.text
      }
    
  }

  public lazy var timeLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: NEKitChatConfig.shared.ui.messageProperties.timeTextSize)
    label.textColor = NEKitChatConfig.shared.ui.messageProperties.timeTextColor
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    label.accessibilityIdentifier = "id.messageTipText"
    return label
  }()

  public lazy var contentLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: NEKitChatConfig.shared.ui.messageProperties.timeTextSize)
      label.textColor = UIColor.lightGray//NEKitChatConfig.shared.ui.messageProperties.timeTextColor
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.accessibilityIdentifier = "id.messageTipText"
    return label
  }()
    
    public lazy var linkBtn: UIButton = {
      let button = UIButton()
      return button
    }()
}
