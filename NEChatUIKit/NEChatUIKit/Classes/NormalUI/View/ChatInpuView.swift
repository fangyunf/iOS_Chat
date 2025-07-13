// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation

@objcMembers
open class ChatInputView: NEBaseChatInputView {
  public var backViewHeightConstraint: NSLayoutConstraint?
  public var toolsBarTopMargin: NSLayoutConstraint?

  override open func commonUI() {
      backgroundColor = UIColor(hexString: "0xffffff")
      addSubview(bgView)
      NSLayoutConstraint.activate([
        bgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
        bgView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
        bgView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
        bgView.heightAnchor.constraint(equalToConstant: 54),
      ])
      addSubview(lineView)
      NSLayoutConstraint.activate([
        lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 47),
        lineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -kScreenWidth + 47.5),
        lineView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
        lineView.heightAnchor.constraint(equalToConstant: 44),
      ])
    addSubview(textView)
    textView.delegate = self
    textviewLeftConstraint = textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 63)
    textviewRightConstraint = textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -63)
    NSLayoutConstraint.activate([
      textviewLeftConstraint!,
      textviewRightConstraint!,
      textView.topAnchor.constraint(equalTo: topAnchor, constant: 13),
      textView.heightAnchor.constraint(equalToConstant: 38),
    ])
      textView.attributedPlaceholder = getPlaceHolder(text: "请输入您要发送的信息")
    textInput = textView

    backViewHeightConstraint = backView.heightAnchor.constraint(equalToConstant: 44)
    insertSubview(backView, belowSubview: textView)
    NSLayoutConstraint.activate([
        backView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
      backView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15-34),
      backView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      backViewHeightConstraint!,
    ])
      
      addSubview(voiceLabel)
      NSLayoutConstraint.activate([
        voiceLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 64),
        voiceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -104),
        voiceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
        voiceLabel.heightAnchor.constraint(equalToConstant: 38),
      ])
      let longGes = UILongPressGestureRecognizer(target: self, action: #selector(clickLabel(recognizer: )))
      voiceLabel.addGestureRecognizer(longGes)

//    addSubview(expandButton)
//    NSLayoutConstraint.activate([
//      expandButton.topAnchor.constraint(equalTo: topAnchor, constant: 7),
//      expandButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
//      expandButton.heightAnchor.constraint(equalToConstant: 40),
//      expandButton.widthAnchor.constraint(equalToConstant: 44.0),
//    ])
//    expandButton.setImage(coreLoader.loadImage("normal_input_unfold"), for: .normal)
//    expandButton.addTarget(self, action: #selector(didClickExpandButton), for: .touchUpInside)
      
      addSubview(voiceButton)
      NSLayoutConstraint.activate([
        voiceButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        voiceButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
        voiceButton.heightAnchor.constraint(equalToConstant: 44),
        voiceButton.widthAnchor.constraint(equalToConstant: 34),
      ])
      voiceButton.tag = 5;
      voiceButton.addTarget(self, action: #selector(buttonEvent(button: )), for: .touchUpInside)
      
      addSubview(emjioButton)
      NSLayoutConstraint.activate([
        emjioButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        emjioButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -22-34),
        emjioButton.heightAnchor.constraint(equalToConstant: 44),
        emjioButton.widthAnchor.constraint(equalToConstant: 34),
      ])
      emjioButton.tag = 6;
      emjioButton.addTarget(self, action: #selector(buttonEvent(button: )), for: .touchUpInside)
      
      addSubview(addButton)
      NSLayoutConstraint.activate([
        addButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        addButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
        addButton.heightAnchor.constraint(equalToConstant: 44),
        addButton.widthAnchor.constraint(equalToConstant: 34),
      ])
      addButton.tag = 8;
      addButton.addTarget(self, action: #selector(buttonEvent(button: )), for: .touchUpInside)

    let imageNames = ["mic", "emoji", "photo", "add"]
    let imageNamesSelected = ["mic_selected", "emoji_selected", "photo", "add_selected"]

    var items = [UIButton]()
    for i in 0 ..< imageNames.count {
      let button = UIButton(type: .custom)
      button.setImage(UIImage.ne_imageNamed(name: imageNames[i]), for: .normal)
      button.setImage(UIImage.ne_imageNamed(name: imageNamesSelected[i]), for: .selected)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
      button.tag = i + 5
      button.accessibilityIdentifier = "id.chatMessageActionItemBtn"
      items.append(button)
    }
      
     

    stackView = UIStackView(arrangedSubviews: items)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fillEqually
      stackView.isHidden = true
    toolsBarTopMargin = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 54)
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.leftAnchor.constraint(equalTo: leftAnchor),
      stackView.rightAnchor.constraint(equalTo: rightAnchor),
      stackView.heightAnchor.constraint(equalToConstant: 54),
      toolsBarTopMargin!,
    ])

    greyView.translatesAutoresizingMaskIntoConstraints = false
      greyView.backgroundColor = UIColor(hexString: "0xffffff")
    greyView.isHidden = true
    addSubview(greyView)
    NSLayoutConstraint.activate([
      greyView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
      greyView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
      greyView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
      greyView.heightAnchor.constraint(equalToConstant: 400),
    ])

    addSubview(contentView)
      contentView.backgroundColor = UIColor(hexString: "0xffffff")
    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.leftAnchor.constraint(equalTo: leftAnchor),
      contentView.rightAnchor.constraint(equalTo: rightAnchor),
      contentView.heightAnchor.constraint(equalToConstant: contentHeight),
      contentView.topAnchor.constraint(equalTo: topAnchor, constant: 54),
    ])

    recordView.isHidden = true
    recordView.translatesAutoresizingMaskIntoConstraints = false
    recordView.delegate = self
    recordView.backgroundColor = UIColor(hexString: "0xffffff")
    contentView.addSubview(recordView)
    NSLayoutConstraint.activate([
      recordView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
      recordView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
      recordView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
      recordView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
    ])

    contentView.addSubview(emojiView)

    contentView.addSubview(chatAddMoreView)

    setupMultipleLineView()
    multipleLineExpandButton.setImage(coreLoader.loadImage("normal_input_fold"), for: .normal)
  }

  override open func restoreNormalInputStyle() {
    super.restoreNormalInputStyle()
    textView.returnKeyType = .send
    textView.removeAllAutoLayout()
    textView.removeConstraints(textView.constraints)
    insertSubview(textView, aboveSubview: backView)
    textviewLeftConstraint = textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 7)
    textviewRightConstraint = textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -44)
    if chatInpuMode == .normal {
      NSLayoutConstraint.activate([
        textviewLeftConstraint!,
        textviewRightConstraint!,
        textView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
        textView.heightAnchor.constraint(equalToConstant: 40),
      ])
      backViewHeightConstraint?.constant = 46
      toolsBarTopMargin?.constant = 46
      titleField.isHidden = true
    } else if chatInpuMode == .multipleSend {
      titleField.isHidden = false
      NSLayoutConstraint.activate([
        textviewLeftConstraint!,
        textviewRightConstraint!,
        textView.topAnchor.constraint(equalTo: topAnchor, constant: 45),
        textView.heightAnchor.constraint(equalToConstant: 45),
      ])

      titleField.removeAllAutoLayout()
      insertSubview(titleField, belowSubview: textView)
      NSLayoutConstraint.activate([
        titleField.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 4),
        titleField.rightAnchor.constraint(equalTo: expandButton.leftAnchor),
        titleField.topAnchor.constraint(equalTo: backView.topAnchor),
        titleField.heightAnchor.constraint(equalToConstant: 40),
      ])

      backViewHeightConstraint?.constant = 54
      toolsBarTopMargin?.constant = 54
    }
  }

  override open func changeToMultipleLineStyle() {
    super.changeToMultipleLineStyle()
    textView.removeAllAutoLayout()
    multipleLineView.addSubview(textView)
    textView.removeConstraints(textView.constraints)
    textView.returnKeyType = .default
    titleField.isHidden = false

    NSLayoutConstraint.activate([
      textView.leftAnchor.constraint(equalTo: multipleLineView.leftAnchor, constant: 13),
      textView.rightAnchor.constraint(equalTo: multipleLineView.rightAnchor, constant: -16),
      textView.topAnchor.constraint(equalTo: multipleLineView.topAnchor, constant: 48),
      textView.heightAnchor.constraint(equalToConstant: 183),
    ])

    if titleField.superview == nil || titleField.superview != multipleLineView {
      titleField.removeAllAutoLayout()
      multipleLineView.addSubview(titleField)
      NSLayoutConstraint.activate([
        titleField.leftAnchor.constraint(equalTo: multipleLineView.leftAnchor, constant: 16),
        titleField.rightAnchor.constraint(equalTo: multipleLineView.rightAnchor, constant: -56),
        titleField.topAnchor.constraint(equalTo: multipleLineView.topAnchor, constant: 5),
        titleField.heightAnchor.constraint(equalToConstant: 40),
      ])
    }
  }

  override open func setMuteInputStyle() {
    super.setMuteInputStyle()
    backView.backgroundColor = UIColor(hexString: "0xffffff")
  }

  override open func setUnMuteInputStyle() {
    super.setUnMuteInputStyle()
    backView.backgroundColor = .white
  }
    
    
}
