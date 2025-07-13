//
//  FRedPacketMessageCell.swift
//  Fiesta
//
//  Created by Amy on 2024/6/12.
//

import UIKit
import NEChatUIKit
import NIMSDK

@objcMembers
class FRedPacketMessageCell: NormalChatMessageBaseCell {
    public let contentRedViewLeft = FRedPacketView()
    public let contentRedViewRight = FRedPacketView()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonUI()
    }
    
    func commonUI() {
        commonUILeft()
        commonUIRight()
    }
    
    func commonUILeft() {
        contentRedViewLeft.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageLeft.addSubview(contentRedViewLeft)
        NSLayoutConstraint.activate([
            contentRedViewLeft.rightAnchor.constraint(equalTo: bubbleImageLeft.rightAnchor, constant: 0),
            contentRedViewLeft.leftAnchor.constraint(equalTo: bubbleImageLeft.leftAnchor, constant: 0),
            contentRedViewLeft.topAnchor.constraint(equalTo: bubbleImageLeft.topAnchor, constant: 0),
            contentRedViewLeft.bottomAnchor.constraint(
                equalTo: bubbleImageLeft.bottomAnchor,
                constant: 0
            ),
        ])
    }
    
    func commonUIRight() {
        contentRedViewRight.translatesAutoresizingMaskIntoConstraints = false
       
        
        bubbleImageRight.addSubview(contentRedViewRight)
        NSLayoutConstraint.activate([
            contentRedViewRight.rightAnchor.constraint(equalTo: bubbleImageRight.rightAnchor, constant: 0),
            contentRedViewRight.leftAnchor.constraint(equalTo: bubbleImageRight.leftAnchor, constant: 0),
            contentRedViewRight.topAnchor.constraint(equalTo: bubbleImageRight.topAnchor, constant: 0),
            contentRedViewRight.bottomAnchor.constraint(
                equalTo: bubbleImageRight.bottomAnchor,
                constant: 0
            ),
        ])
    }
    
    override func showLeftOrRight(showRight: Bool) {
        super.showLeftOrRight(showRight: showRight)
        contentRedViewLeft.isHidden = showRight
        contentRedViewRight.isHidden = !showRight
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setModel(_ model: MessageContentModel, _ isSend: Bool) {
        model.contentSize.width = 258
        model.contentSize.height = 134
        super.setModel(model, isSend)
        guard let isSend = model.message?.isOutgoingMsg else {
            return
        }
        let contentCardView = isSend ? contentRedViewRight : contentRedViewLeft
        if let m = model as? MessageCustomModel {
            if let object = m.message?.messageObject as? NIMCustomObject {
                if let cardModel = object.attachment as? FRedPacketMessageModel {
                    bubbleImageLeft.backgroundColor = UIColor.clear
                    bubbleImageRight.backgroundColor = UIColor.clear
                    
                    bubbleImageLeft.image = nil
                    bubbleImageRight.image = nil
                    
                    /// 红包
                    var imgStr = cardModel.customType == 21 ? (isSend ? "icn_msg_red_packet_e_s" : "icn_msg_red_packet_e") : (isSend ? "icn_msg_red_packet_s" : "icn_msg_red_packet")
                    if cardModel.customType == 28 {
                        imgStr = isSend ? "bg_message_tran" : "bg_message_tran"
                    }
                    
                    contentCardView.nameLabel.text = cardModel.customType == 21 ? "专属红包" : "拼手气红包"
                    
                    contentCardView.backImgView.image = UIImage(named: imgStr)
                    if cardModel.customType == 21 {
                        contentCardView.titleLabel.text = cardModel.toUserName?.count != 0 ? cardModel.toUserName : cardModel.title
                    }else if cardModel.customType == 28 {
                        if cardModel.toUserId == FUserModel.sharedUser().userID {
                            contentCardView.titleLabel.text = "你收到了一笔转账"
                        }else{
                            contentCardView.titleLabel.text = "你发起了一笔转账"
                        }
                        
                        contentCardView.nameLabel.text = "转账"
                    }else{
                        contentCardView.titleLabel.text = cardModel.title?.count == 0 ? "恭喜发财，大吉大利" : cardModel.title
                    }
                    
                    contentCardView.amountLabel.text = String(format: "¥%.2f", cardModel.amount/100)
                    contentCardView.amountLabel.isHidden = false
                    
                    let time = (Int(cardModel.createTime ?? "") ?? 0) / 1000
                    let timeStr = String(format: "%ld", time)
                    contentCardView.timeLabel.text  = FDataTool.updata(forNumberTimeYear: timeStr, formatter: "YYYY-MM-dd HH:mm:ss")
                    
                    contentCardView.whiteView.isHidden = !cardModel.received
                    
//                    if cardModel.customType == 28  {
                        contentCardView.lineView.isHidden = true
                        contentCardView.amountLabel.mas_remakeConstraints {  (make) in
                            make?.left.equalTo()(contentCardView.backImgView)?.offset()(75)
                            make?.right.equalTo()(contentCardView.backImgView)?.offset()(-25)
                            make?.top.equalTo()(contentCardView.backImgView)?.offset()(43)
                            make?.height.offset()(21)
                        }
                        contentCardView.titleLabel.mas_remakeConstraints {  (make) in
                            make?.left.equalTo()(contentCardView.backImgView)?.offset()(75)
                            make?.right.equalTo()(contentCardView.backImgView)?.offset()(-25)
                            make?.top.equalTo()(contentCardView.backImgView)?.offset()(15)
                            make?.height.offset()(21)
                        }
                    if cardModel.customType == 28  {
                        contentCardView.nameLabel.textColor = .white
                        contentCardView.timeLabel.textColor = .white
                    }else{
                        contentCardView.nameLabel.textColor = .white
                        contentCardView.timeLabel.textColor = .white
                    }
                    
//                        contentCardView.nameLabel.mas_remakeConstraints {  make in
//                            make?.left.equalTo()(contentCardView.backImgView)?.offset()(15)
//                            make?.bottom.equalTo()(contentCardView.backImgView)?.offset()(-8)
//                            make?.height.offset()(17)
//                            make?.width.offset()(100)
//                        }
//                        contentCardView.timeLabel.mas_remakeConstraints {  (make) in
//                            make?.bottom.equalTo()(contentCardView.backImgView)?.offset()(-8)
//                            make?.left.equalTo()(contentCardView.backImgView)?.offset()(90)
//                            make?.height.offset()(17)
//                            make?.width.offset()(153)
//                        }
//                    }else{
//                        contentCardView.lineView.isHidden = false
//                        contentCardView.amountLabel.mas_remakeConstraints {  (make) in
//                            make?.left.equalTo()(contentCardView.backImgView)?.offset()(25)
//                            make?.right.equalTo()(contentCardView.backImgView)?.offset()(-25)
//                            make?.top.equalTo()(contentCardView.backImgView)?.offset()(43)
//                            make?.height.offset()(21)
//                        }
//                        contentCardView.titleLabel.mas_remakeConstraints {  (make) in
//                            make?.left.equalTo()(contentCardView.backImgView)?.offset()(25)
//                            make?.right.equalTo()(contentCardView.backImgView)?.offset()(-25)
//                            make?.top.equalTo()(contentCardView.backImgView)?.offset()(15)
//                            make?.height.offset()(21)
//                        }
//                        contentCardView.nameLabel.textColor = .white
//                        contentCardView.timeLabel.textColor = .white
////                        contentCardView.nameLabel.mas_remakeConstraints {  make in
////                            make?.left.equalTo()(contentCardView.backImgView)?.offset()(15)
////                            make?.bottom.equalTo()(contentCardView.backImgView)?.offset()(-8)
////                            make?.height.offset()(17)
////                            make?.width.offset()(100)
////                        }
////                        contentCardView.timeLabel.mas_remakeConstraints {  (make) in
////                            make?.bottom.equalTo()(contentCardView.backImgView)?.offset()(-8)
////                            make?.left.equalTo()(contentCardView.backImgView)?.offset()(90)
////                            make?.height.offset()(17)
////                            make?.width.offset()(153)
////                        }
//                    }
                }
            }
        }
    }
    
}


open class FRedPacketView : UIView {
    public let backImgView: UIImageView = {
       let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.layer.masksToBounds = true
        imgV.layer.cornerRadius = 4;
        return imgV
    }()
    public let whiteView: UIView = {
        let v:UIView = UIView()
        v.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        v.isHidden = true
        return v
    }()
    public let titleLabel : UILabel = {
       let l = UILabel()
        l.font = semiboldFont(18)
        l.textColor = UIColor(hexString: "#FFFFFF")
        l.textAlignment = .left
        return l
    }()
    public var nameLabel: UILabel = {
        let l : UILabel = UILabel()
        l.font = regularFont(14)
        l.textColor = .white
        l.text = "红包"
        l.isHidden = false
        return l
    }()
    public var amountLabel: UILabel = {
        let l : UILabel = UILabel()
        l.font = semiboldFont(18)
        l.textColor = .white
        l.text = "0.00"
        l.isHidden = true
        return l
    }()
    public let lineView: UIView = {
        let v:UIView = UIView()
        v.backgroundColor = .white
        return v
    }()
    /// 时间label
    public var timeLabel :  UILabel  = {
        let l : UILabel = UILabel()
        l.text = "发包时间"
        l.textColor = UIColor.white
        l.textAlignment = .right
        l.font = regularFont(14)
        l.isHidden = false
        return l
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func commonUI() {
        backgroundColor = UIColor.clear
        
        addSubview(backImgView)
        addSubview(titleLabel)
        addSubview(nameLabel)
        addSubview(amountLabel)
        addSubview(timeLabel)
        addSubview(lineView)
        addSubview(whiteView)
        backImgView.mas_makeConstraints { [self] (make) in
            make?.left.equalTo()(self)?.offset()(0)
            make?.top.equalTo()(self)?.offset()(0)
            make?.height.offset()(90)
            make?.width.offset()(258)
        }
        amountLabel.mas_makeConstraints { [self] (make) in
            make?.left.equalTo()(self.backImgView)?.offset()(25)
            make?.right.equalTo()(self.backImgView)?.offset()(-25)
            make?.top.equalTo()(self.backImgView)?.offset()(43)
            make?.height.offset()(21)
        }
        titleLabel.mas_makeConstraints { [self] (make) in
            make?.left.equalTo()(self.backImgView)?.offset()(25)
            make?.right.equalTo()(self.backImgView)?.offset()(-25)
            make?.top.equalTo()(self.backImgView)?.offset()(15)
            make?.height.offset()(21)
        }
        nameLabel.mas_makeConstraints { [self] make in
            make?.left.equalTo()(self.backImgView)?.offset()(15)
            make?.bottom.equalTo()(self.backImgView)?.offset()(-4)
            make?.height.offset()(17)
            make?.width.offset()(100)
        }
        timeLabel.mas_makeConstraints { [self] (make) in
            make?.bottom.equalTo()(self.backImgView)?.offset()(-4)
            make?.left.equalTo()(self.backImgView)?.offset()(90)
            make?.height.offset()(17)
            make?.width.offset()(153)
        }
        lineView.mas_makeConstraints { [self] (make) in
            make?.bottom.equalTo()(self.backImgView)?.offset()(-30)
            make?.left.equalTo()(self.backImgView)?.offset()(15)
            make?.right.equalTo()(self.backImgView)?.offset()(-15)
            make?.height.offset()(1)
        }
        whiteView.mas_makeConstraints { [self] make in
            make?.left.equalTo()(self)?.offset()(0)
            make?.right.equalTo()(self)?.offset()(0)
            make?.height.offset()(90)
        }
    }
}
