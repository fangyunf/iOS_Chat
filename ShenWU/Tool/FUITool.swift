//
//  FUITool.swift
//  Fiesta
//
//  Created by Amy on 2024/6/5.
//

import Foundation
import UIKit

public func createButton(title:String, font:UIFont, textColor:UIColor) -> UIButton {
    let btn = UIButton(type: UIButton.ButtonType.custom)
    btn.titleLabel?.font = font
    btn.setTitleColor(textColor, for: UIControl.State.normal)
    btn.setTitle(title, for: UIControl.State.normal)
    return btn
}

public func createButton(title:String, font:UIFont, textColor:UIColor, target:AnyObject, sel:Selector) -> UIButton {
    let btn = UIButton(type: UIButton.ButtonType.custom)
    btn.titleLabel?.font = font
    btn.setTitleColor(textColor, for: UIControl.State.normal)
    btn.setTitle(title, for: UIControl.State.normal)
    btn.addTarget(target, action: sel, for: UIControl.Event.touchUpInside)
    return btn
}

public func createImageButton(image:UIImage, target:AnyObject, sel:Selector) -> UIButton {
    let btn = UIButton(type: UIButton.ButtonType.custom)
    btn.setImage(image, for: UIControl.State.normal)
    btn.addTarget(target, action: sel, for: UIControl.Event.touchUpInside)
    return btn
}

public func createLabel(text:String, textColor:UIColor, font:UIFont) -> UILabel {
    return createLabel(text: text, textColor: textColor, font: font, alignment: NSTextAlignment.left, lineNum: 1)
}

public func createLabel(text:String, textColor:UIColor, font:UIFont, alignment:NSTextAlignment, lineNum:NSInteger) -> UILabel {
    let label = UILabel.init()
    label.font = font
    label.text = text
    label.textColor = textColor
    label.textAlignment = alignment
    label.numberOfLines = lineNum
    return label
}

public func createImageView(frame:CGRect, image:UIImage) -> UIImageView {
    let imageView = UIImageView(frame: frame)
    imageView.image = image
    return imageView
}

public func rangeOfString(string:NSString,
                   andInString inString:String) -> [NSRange] {
    
    var arrRange = [NSRange]()
    var _fullText = string
    var rang:NSRange = _fullText.range(of: inString)
    
    while rang.location != NSNotFound {
        var location:Int = 0
        if arrRange.count > 0 {
            if arrRange.last!.location + arrRange.last!.length <= string.length {
                location = arrRange.last!.location + arrRange.last!.length
            }
        }
        
        _fullText = NSString.init(string: _fullText.substring(from: rang.location + rang.length))
        
        if arrRange.count > 0 {
            rang.location += location
        }
        arrRange.append(rang)
        
        rang = _fullText.range(of: inString)
    }
    
    return arrRange
}

public func regularFont(_ s: CGFloat) -> UIFont {
    let font: UIFont = UIFont(name: "PingFangSC-Regular", size: s) ?? UIFont.systemFont(ofSize: s)
    return font
}

public func mediumFont(_ s: CGFloat) -> UIFont {
    let font: UIFont = UIFont(name: "PingFangSC-Medium", size: s) ?? UIFont.systemFont(ofSize: s)
    return font
}

public func semiboldFont(_ s: CGFloat) -> UIFont {
    let font: UIFont = UIFont(name: "PingFangSC-Semibold", size: s) ?? UIFont.systemFont(ofSize: s)
    return font
}
