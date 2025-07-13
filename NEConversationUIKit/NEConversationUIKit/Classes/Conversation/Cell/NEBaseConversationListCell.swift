
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK
import UIKit

@objcMembers
open class NEBaseConversationListCell: UITableViewCell {
//  private var viewModel = ConversationViewModel()
  public var topStickInfos = [NIMSession: NIMStickTopSessionInfo]()
  private let repo = ConversationRepo.shared
  private var timeWidth: NSLayoutConstraint?

  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSubviews()
    initSubviewsLayout()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open func setupSubviews() {
    selectionStyle = .none
    if let bgColor = NEKitConversationConfig.shared.ui.conversationProperties.itemBackground {
      backgroundColor = bgColor
    }
      contentView.addSubview(bgView)
    contentView.addSubview(headImge)
      
    contentView.addSubview(redAngleView)
      
    contentView.addSubview(title)
      
    contentView.addSubview(subTitle)
    contentView.addSubview(timeLabel)
    contentView.addSubview(notifyMsg)
      contentView.addSubview(headFrameImge)
      contentView.addSubview(levelImgView)
      contentView.addSubview(memberCodeLabel)
      contentView.addSubview(redTagView)
//      contentView.addSubview(lineView)
    NSLayoutConstraint.activate([
      redAngleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
      redAngleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 41),
      redAngleView.heightAnchor.constraint(equalToConstant: 14),
      redAngleView.widthAnchor.constraint(equalToConstant: 23),
    ])
      
      NSLayoutConstraint.activate([
        redTagView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
        redTagView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 41),
        redTagView.heightAnchor.constraint(equalToConstant: 8),
        redTagView.widthAnchor.constraint(equalToConstant: 8),
      ])
      
    timeWidth = timeLabel.widthAnchor.constraint(equalToConstant: 0)
    timeWidth?.isActive = true
    NSLayoutConstraint.activate([
      timeLabel.rightAnchor.constraint(
        equalTo: contentView.rightAnchor,
        constant:-16
      ),
      timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
    ])

    NSLayoutConstraint.activate([
      subTitle.leftAnchor.constraint(equalTo: headImge.rightAnchor, constant: 11),
      subTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50),
      subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
      subTitle.heightAnchor.constraint(equalToConstant: 17),
    ])
  }

  func initSubviewsLayout() {}

  open func configData(sessionModel: ConversationListModel?) {
    guard let conversationModel = sessionModel else { return }

    if let userId = conversationModel.userInfo?.userId,
       let user = ChatUserCache.getUserInfo(userId) {
      conversationModel.userInfo = user
    }

    if conversationModel.recentSession?.session?.sessionType == .P2P {
      // p2p head image
      if let imageName = conversationModel.userInfo?.userInfo?.avatarUrl, !imageName.isEmpty {
        headImge.setTitle("")
        headImge.sd_setImage(with: URL(string: imageName), completed: nil)
        headImge.backgroundColor = .clear
      } else {
        headImge.setTitle(conversationModel.userInfo?.shortName(showAlias: false, count: 2) ?? "")
        headImge.sd_setImage(with: nil, placeholderImage: UIImage(named: "avatar_person"))
        headImge.backgroundColor = UIColor
          .colorWithString(string: conversationModel.userInfo?.userId)
      }

      // p2p nickName
      title.text = conversationModel.userInfo?.showName()

      // notifyForNewMsg
//      notifyMsg.isHidden = viewModel
//        .notifyForNewMsg(userId: conversationModel.userInfo?.userId)
      notifyMsg.isHidden = repo.isNeedNotify(userId: conversationModel.userInfo?.userId)

    } else if conversationModel.recentSession?.session?.sessionType == .team {
      // team head image
      if let imageName = conversationModel.teamInfo?.avatarUrl, !imageName.isEmpty {
        headImge.setTitle("")
        headImge.sd_setImage(with: URL(string: imageName), completed: nil)
        headImge.backgroundColor = .clear
      } else {
        headImge.setTitle("")
          headImge.sd_setImage(with: nil, placeholderImage: UIImage(named: "avatar_group"))
          headImge.backgroundColor = .clear
      }
      title.text = conversationModel.teamInfo?.getShowName()

      // notifyForNewMsg
//      let teamNotifyState = viewModel
//        .notifyStateForNewMsg(teamId: conversationModel.teamInfo?.teamId)
      let teamNotifyState = repo.isNeedNotifyForTeam(teamId: conversationModel.teamInfo?.teamId)
      notifyMsg.isHidden = teamNotifyState == .none ? false : true
    }
      redTagView.isHidden = notifyMsg.isHidden
      if redTagView.isHidden == false {
          if conversationModel.recentSession?.unreadCount ?? 0 > 0 {
              redTagView.isHidden = false
          }else{
              redTagView.isHidden = true
          }
      }
    // last message
    if let lastMessage = conversationModel.recentSession?.lastMessage {
      let text = contentForRecentSession(message: lastMessage)
      let mutaAttri = NSMutableAttributedString(string: text)
      if let sessionId = sessionModel?.recentSession?.session?.sessionId {
        let isAtMessage = NEAtMessageManager.instance?.isAtCurrentUser(sessionId: sessionId)
        if isAtMessage == true {
          let atStr = localizable("you_were_mentioned")
          mutaAttri.insert(NSAttributedString(string: atStr), at: 0)
          mutaAttri.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.ne_redText, range: NSMakeRange(0, atStr.count))
          mutaAttri.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: NEKitConversationConfig.shared.ui.conversationProperties.itemContentSize > 0 ? NEKitConversationConfig.shared.ui.conversationProperties.itemContentSize : 13), range: NSMakeRange(0, mutaAttri.length))
        }
      }
      subTitle.attributedText = mutaAttri // contentForRecentSession(message: lastMessage)
    } else {
      subTitle.attributedText = nil
    }

    // unRead message count
    if let unReadCount = conversationModel.recentSession?.unreadCount {
      if unReadCount <= 0 {
        redAngleView.isHidden = true
      } else {
        redAngleView.isHidden = notifyMsg.isHidden ? false : true
        if unReadCount <= 99 {
          redAngleView.text = "\(unReadCount)"
        } else {
          redAngleView.text = "99+"
        }
      }
    }

    // time
    if let rencentSession = conversationModel.recentSession {
      timeLabel
        .text =
        dealTime(time: timestampDescriptionForRecentSession(recentSession: rencentSession))
      if let text = timeLabel.text {
        let maxSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
        let attibutes = [NSAttributedString.Key.font: timeLabel.font]
        let labelSize = NSString(string: text).boundingRect(with: maxSize, attributes: attibutes, context: nil)
        timeWidth?.constant = labelSize.width + 1 // ceil()
      }
    }
  }

  func timestampDescriptionForRecentSession(recentSession: NIMRecentSession) -> TimeInterval {
    if let lastMessage = recentSession.lastMessage {
      return lastMessage.timestamp
    }

    return 0
  }

  func dealTime(time: TimeInterval) -> String {
    if time <= 0 {
      return ""
    }

    let targetDate = Date(timeIntervalSince1970: time)
    let fmt = DateFormatter()

    if targetDate.isToday() {
      fmt.dateFormat = localizable("hm")
      return fmt.string(from: targetDate)

    } else {
      if targetDate.isThisYear() {
        fmt.dateFormat = "MM/dd HH:mm"
        return fmt.string(from: targetDate)

      } else {
        fmt.dateFormat = "YYY/MM/dd HH:mm"
        return fmt.string(from: targetDate)
      }
    }
  }

  open func contentForRecentSession(message: NIMMessage) -> String {
    let text = NEMessageUtil.messageContent(message: message)
    return text
  }

  // MARK: lazy Method

  public lazy var headImge: NEUserHeaderView = {
    let headView = NEUserHeaderView(frame: .zero)
    headView.titleLabel.textColor = .white
    headView.titleLabel.font = NEConstant.defaultTextFont(16)
    headView.translatesAutoresizingMaskIntoConstraints = false
    headView.layer.cornerRadius = 3
    headView.clipsToBounds = true
    return headView
  }()
    
    public lazy var headFrameImge: UIImageView = {
      let frameImg = UIImageView()
        frameImg.frame = CGRectMake(18.5, 11, 41, 45)
      return frameImg
    }()
    
    public lazy var bgView: UIView = {
      let view = UIView()
        view.backgroundColor = UIColor.white
        view.frame = CGRectMake(0, 0, UIScreen.main.bounds.width, 62)
        view.layer.masksToBounds = true
      return view
    }()
    
    public lazy var lineView: UIView = {
      let view = UIView()
        view.backgroundColor = UIColor(hexString: "0xe6e6e6")
        view.frame = CGRectMake(18, 61, UIScreen.main.bounds.width - 36, 1)
        view.layer.masksToBounds = true
      return view
    }()
    
  // 单条会话未读数
  public lazy var redAngleView: RedAngleLabel = {
    let label = RedAngleLabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = NEConstant.defaultTextFont(10)
    label.textColor = .white
    label.text = "99+"
      label.textAlignment = .center
    label.backgroundColor = NEConstant.hexRGB(0x007AFF)
    label.textInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
    label.layer.cornerRadius = 7
    label.clipsToBounds = true
    label.isHidden = true
    return label
  }()
    
    public lazy var redTagView: UIView = {
      let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.isHidden = true
      return view
    }()

  // 会话列表会话名称
  public lazy var title: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = NEKitConversationConfig.shared.ui.conversationProperties.itemTitleColor
    label.font = .boldSystemFont(ofSize: 18)
    label.text = "Oliver"
    label.accessibilityIdentifier = "id.name"
    return label
  }()
    
    public lazy var levelImgView: UIImageView = {
      let imgView = UIImageView()
        
      return imgView
    }()
    
    public lazy var memberCodeLabel: UILabel = {
      var label = UILabel()
      label.textColor = UIColor(hexString: "#006CFF")
        label.backgroundColor = UIColor(hexString: "#006CFF", 0.16)
      label.font = .systemFont(ofSize: 10)
      label.text = ""
        label.textAlignment = .center
        label.layer.cornerRadius = 7.5
        label.layer.masksToBounds = true
      label.accessibilityIdentifier = "id.name"
      return label
    }()

  // 会话列表外露消息
  public lazy var subTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor(hexString: "#959595")
    label.font = UIFont.systemFont(ofSize: NEKitConversationConfig.shared.ui.conversationProperties.itemContentSize > 0 ? NEKitConversationConfig.shared.ui.conversationProperties.itemContentSize : 13)
    label.accessibilityIdentifier = "id.message"
    return label
  }()

  // 会话列表显示时间
  public lazy var timeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
      label.textColor = UIColor(hexString: "0x959595")//UIColor(hexString: "0x888888")
    label.font = .systemFont(ofSize: NEKitConversationConfig.shared.ui.conversationProperties.itemDateSize > 0 ? NEKitConversationConfig.shared.ui.conversationProperties.itemDateSize : 12)
    label.textAlignment = .right
    label.accessibilityIdentifier = "id.time"
    return label
  }()

  // 免打扰icon
  public lazy var notifyMsg: UIImageView = {
    let notify = UIImageView()
    notify.translatesAutoresizingMaskIntoConstraints = false
    notify.image = UIImage.ne_imageNamed(name: "noNeed_notify")
    notify.isHidden = true
    notify.accessibilityIdentifier = "id.mute"
    return notify
  }()
}
