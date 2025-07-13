
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NECommonUIKit
import NECoreKit
import UIKit

@objcMembers
open class ChatBaseViewController: UIViewController, UIGestureRecognizerDelegate {
  var topConstant: CGFloat = 0
  public let navigationView = NENavigationView()

  override open var title: String? {
    get {
      super.title
    }

    set {
      super.title = newValue
      navigationView.navTitle.text = newValue
    }
  }

  override open func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
      view.backgroundColor = .clear
      navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg_common_top"), for: .default)
    if !NEKitChatConfig.shared.ui.messageProperties.showTitleBar {
      navigationController?.isNavigationBarHidden = true
      return
    }

    if let useSystemNav = NEConfigManager.instance.getParameter(key: useSystemNav) as? Bool, useSystemNav {
      navigationController?.isNavigationBarHidden = false
      setupBackUI()
      topConstant = NEConstant.navigationAndStatusHeight
    } else {
      navigationController?.isNavigationBarHidden = true
      topConstant = NEConstant.navigationAndStatusHeight
      navigationView.translatesAutoresizingMaskIntoConstraints = false
      navigationView.addBackButtonTarget(target: self, selector: #selector(backEvent))
      navigationView.addMoreButtonTarget(target: self, selector: #selector(toSetting))
      view.addSubview(navigationView)
      NSLayoutConstraint.activate([
        navigationView.leftAnchor.constraint(equalTo: view.leftAnchor),
        navigationView.rightAnchor.constraint(equalTo: view.rightAnchor),
        navigationView.topAnchor.constraint(equalTo: view.topAnchor),
        navigationView.heightAnchor.constraint(equalToConstant: topConstant),
      ])
        
        navigationView.moreButton.setImage(UIImage.ne_imageNamed(name: "three_point"), for: .normal)
        navigationView.backButton.setImage(UIImage.init(named: "icn_nav_back"), for: .normal)
    }
      setupBackUI()
      navigationView.backgroundColor = UIColor.clear
      let topImgView = UIImageView(frame: CGRectMake(0, 0, kScreenWidth, 267))
      topImgView.image = UIImage(named: "bg_common_top")
      topImgView.layer.masksToBounds = true
      self.view.addSubview(topImgView)
      self.view.sendSubviewToBack(topImgView)
      
      navigationView.navTitle.textColor = UIColor.black
  }

  private func setupBackUI() {
      let image = UIImage.ne_imageNamed(name: "icn_nav_back")
    let backItem = UIBarButtonItem(
      image: image,
      style: .plain,
      target: self,
      action: #selector(backEvent)
    )
//    backItem.accessibilityIdentifier = "id.backArrow"
    navigationItem.leftBarButtonItem = backItem
    navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem()
      navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .white
  }

  func backEvent() {
    navigationController?.popViewController(animated: true)
  }

  func toSetting() {}
}
