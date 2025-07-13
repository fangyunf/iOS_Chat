//
//  MWBaseViewController.swift
//  MassageW
//
//  Created by Amy on 2024/1/20.
//

import UIKit

class MWBaseViewController: UIViewController {

    var tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        tapGestureRecognizer.addTarget(self, action: #selector(keyboardHide))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func keyboardHide() {
        self.view.endEditing(true)
    }

    func setNavRightBtn(_ imageName:String, _ sel:Selector){
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imageName), for: UIControl.State.normal)
        btn.addTarget(self, action: sel, for: UIControl.Event.touchUpInside)
        btn.frame = CGRectMake(0, 0, 44, 44)
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        let barBtn = UIBarButtonItem.init(customView: btn)
        self.navigationItem.rightBarButtonItem = barBtn
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
