
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NEChatKit
import NECommonUIKit
import UIKit

@objcMembers
open class NEBaseChatTeamMemberCell: UITableViewCell {
  public lazy var headerView: NEUserHeaderView = {
    let header = NEUserHeaderView(frame: .zero)
    header.titleLabel.font = NEConstant.defaultTextFont(14)
    header.titleLabel.textColor = UIColor.white
    header.clipsToBounds = true
    header.translatesAutoresizingMaskIntoConstraints = false
    header.accessibilityIdentifier = "id.atCellHeaderView"
    return header
  }()

  public lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .ne_darkText
    label.accessibilityIdentifier = "id.atCellName"
    return label
  }()

  override open func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupUI()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  open func setupUI() {
    contentView.addSubview(headerView)
    NSLayoutConstraint.activate([
      headerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 21),
      headerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      headerView.widthAnchor.constraint(equalToConstant: 42),
      headerView.heightAnchor.constraint(equalToConstant: 42),
    ])

    contentView.addSubview(nameLabel)
    NSLayoutConstraint.activate([
      nameLabel.leftAnchor.constraint(equalTo: headerView.rightAnchor, constant: 14.0),
      nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -70),
    ])
  }

  open func configure(_ model: ChatTeamMemberInfoModel) {
      if let url = model.nimUser?.userInfo?.avatarUrl, !url.isEmpty {
        headerView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "avatar_person"))
        headerView.setTitle("")
      } else {
        headerView.image = UIImage(named: "avatar_person")
        headerView.setTitle(model.showNickInTeam())
        headerView.backgroundColor = UIColor.colorWithString(string: model.nimUser?.userId)
      }
      nameLabel.text = model.atNameInTeam()
  }
}
