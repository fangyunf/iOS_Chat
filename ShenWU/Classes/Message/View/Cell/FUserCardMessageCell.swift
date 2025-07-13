//
//  FUserCardMessageCell.swift
//  Fiesta
//
//  Created by Amy on 2024/6/12.
//

import UIKit
import NEChatUIKit
import NIMSDK

class FUserCardMessageCell: NormalChatMessageBaseCell {
    public let contentCardViewLeft = UUChatBusinessCardView()
    public let contentCardViewRight = UUChatBusinessCardView()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonUI() {
        commonUILeft()
        commonUIRight()
    }
    
    open func commonUILeft() {
        contentCardViewLeft.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageLeft.addSubview(contentCardViewLeft)
        bubbleImageLeft.image = nil;
        NSLayoutConstraint.activate([
            contentCardViewLeft.rightAnchor.constraint(equalTo: bubbleImageLeft.rightAnchor, constant: 0),
            contentCardViewLeft.leftAnchor.constraint(equalTo: bubbleImageLeft.leftAnchor, constant: 0),
            contentCardViewLeft.topAnchor.constraint(equalTo: bubbleImageLeft.topAnchor, constant: 0),
            contentCardViewLeft.bottomAnchor.constraint(
                equalTo: bubbleImageLeft.bottomAnchor,
                constant: 0
            ),
        ])
    }
    
    open func commonUIRight() {
        contentCardViewRight.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageRight.addSubview(contentCardViewRight)
        bubbleImageRight.image = nil;
        NSLayoutConstraint.activate([
            contentCardViewRight.rightAnchor.constraint(equalTo: bubbleImageRight.rightAnchor, constant: 0),
            contentCardViewRight.leftAnchor.constraint(equalTo: bubbleImageRight.leftAnchor, constant: 0),
            contentCardViewRight.topAnchor.constraint(equalTo: bubbleImageRight.topAnchor, constant: 0),
            contentCardViewRight.bottomAnchor.constraint(
                equalTo: bubbleImageRight.bottomAnchor,
                constant: 0
            ),
        ])
    }
    
    override open func showLeftOrRight(showRight: Bool) {
        super.showLeftOrRight(showRight: showRight)
        contentCardViewLeft.isHidden = showRight
        contentCardViewRight.isHidden = !showRight
    }
    
    override func setModel(_ model: MessageContentModel, _ isSend: Bool) {
        model.contentSize.width = 230
        model.contentSize.height = 80
        super.setModel(model, isSend)
        guard let isSend = model.message?.isOutgoingMsg else {
            return
        }
        let contentCardView = isSend ? contentCardViewRight : contentCardViewLeft
        if let m = model as? MessageCustomModel {
            if let object = m.message?.messageObject as? NIMCustomObject {
                if let cardModel = object.attachment as? FUserCardMessageModel {
                    /// 名片
                    contentCardView.headerIconImgV.sd_setImage(with: URL(string: cardModel.avatar ?? ""), placeholderImage: UIImage(named: "avatar_person"))
                    contentCardView.nameLabel.text = cardModel.name
                }
            }
        }
    }
    
}



open class UUChatBusinessCardView : UIView {
    public let headerIconImgV : UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 15
        img.layer.masksToBounds = true
        return img
    }()
    public let nameLabel : UILabel = {
        let label = UILabel()
        label.font = regularFont(16)
        label.textColor = UIColor(hexString: "000000")
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func commonUI() {
        let backImgV: UIImageView = UIImageView()
        backImgV.backgroundColor = UIColor(rgb: 0x19C77A, alpha: 0.3)
        backImgV.layer.cornerRadius = 10
        backImgV.layer.masksToBounds = true
//        backImgV.image = UIImage(named: "bg_msg_card")
        
        let stateLabel = UILabel()
        stateLabel.text = "个人名片"
        stateLabel.textColor = UIColor(hexString: "#333333")
        stateLabel.font = regularFont(12)
        stateLabel.textAlignment = .left
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(hexString: "#333333")
        
        addSubview(backImgV)
        addSubview(headerIconImgV)
        addSubview(nameLabel)
        addSubview(stateLabel)
        addSubview(lineView)
        
        backImgV.mas_makeConstraints { [self] make in
            make?.left.equalTo()(self)?.offset()(0)
            make?.top.equalTo()(self)?.offset()(0)
            make?.height.offset()(80)
            make?.width.offset()(230)
        }
        headerIconImgV.mas_makeConstraints { [self] (make) in
            make?.left.equalTo()(self)?.offset()(12)
            make?.top.equalTo()(self)?.offset()(10)
            make?.width.offset()(39)
            make?.height.offset()(39)
        }
        nameLabel.mas_makeConstraints { [self] (make) in
            make?.left.equalTo()(headerIconImgV.mas_right)?.offset()(8)
            make?.centerY.equalTo()(headerIconImgV)?.offset()(0)
            make?.right.equalTo()(self)?.offset()(-12)
        }
        stateLabel.mas_makeConstraints { [self] (make) in
            make?.left.equalTo()(headerIconImgV)?.offset()(0)
            make?.bottom.equalTo()(self)?.offset()(-4)
            make?.height.offset()(17)
        }
        
        lineView.mas_makeConstraints { [self] (make) in
            make?.left.equalTo()(backImgV)?.offset()(12)
            make?.right.equalTo()(backImgV)?.offset()(-12)
            make?.bottom.equalTo()(self)?.offset()(-25)
            make?.height.offset()(1)
        }
    }
    
}

