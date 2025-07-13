//
//  FAppHeader.swift
//  Fiesta
//
//  Created by Amy on 2024/6/5.
//


public let kKeyWindow = UIApplication.shared.keyWindow ?? UIWindow()

public let kRootVC = kKeyWindow.rootViewController ?? UIViewController()

public let kScale = (kScreenWidth/375.0)

public let kScreenWidth = UIScreen.main.bounds.width

public let kScreenHeight = UIScreen.main.bounds.height

public let kDevice_Is_iPhoneX: Bool = {
        if kScreenWidth > 736 {
                return true
        } else {
                return false
        }
}()

public let kHeightSafeTop = kDevice_Is_iPhoneX ? CGFloat(24.0) : CGFloat(0.0)

public let kStatusBarHeight = UIApplication.shared.statusBarFrame.height

public let kNavBarHeight = kStatusBarHeight + CGFloat(44.0)

public let kHomeIndicatorHeight: CGFloat = kKeyWindow.safeAreaInsets.bottom

public let kTabBarHeight = kDevice_Is_iPhoneX ? CGFloat(kHomeIndicatorHeight + 49.0) : CGFloat(49.0)
