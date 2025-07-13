//
//  MWAddAddressViewController.swift
//  MassageW
//
//  Created by Amy on 2024/1/29.
//

import UIKit

@objcMembers class MWAddAddressViewController: MWBaseViewController {
    var isEdit:Bool = false
    var editIndex:Int = -1
    var editData:NSDictionary?
    private var tableView:UITableView?
    private var switchBtn:UIButton?
    private var dataList = [["title":"联系人","placeholder":"请输入收货人姓名"],["title":"手机号","placeholder":"请输入手机号码"],["title":"地区","placeholder":"请输入省市区"],["title":"详细地址","placeholder":"请输入街道、楼牌号等"]]
    override func viewDidLoad() {
        super.viewDidLoad()

        if isEdit {
            self.navigationItem.title = "编辑地址"
        }else{
            self.navigationItem.title = "新增地址"
        }
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreenWidth, height: kScreenHeight - kNavBarHeight), style: UITableView.Style.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = UIColor.white
        tableView?.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        tableView?.estimatedRowHeight = 0
        tableView?.estimatedSectionFooterHeight = 0
        tableView?.estimatedSectionHeaderHeight = 0
        tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView?.showsVerticalScrollIndicator = false
        tableView?.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 34))
        view.addSubview(tableView!)
        
        let footerView = UIView(frame: CGRectMake(0, 0, kScreenWidth, 52))
        
        let label = createLabel(text: "设置为默认地址", textColor: UIColor(rgb: 0x333333), font: UIFont.regularFont(withSize: 13))
        label.frame = CGRectMake(15, 17, kScreenWidth - 30, 18)
        footerView.addSubview(label)
        
        switchBtn = createImageButton(image: UIImage.icnOff, target: self, sel: #selector(switchBtnAction))
        switchBtn?.frame = CGRectMake(kScreenWidth - 51, 15, 36, 22)
        switchBtn?.setImage(UIImage.icnOn, for: UIControl.State.selected)
        footerView.addSubview(switchBtn!)
        
        tableView?.tableFooterView = footerView
        
        let saveBtn = createButton(title: "保存", font: UIFont.boldFont(withSize: 18), textColor: UIColor.white, target: self, sel: #selector(saveBtnAction))
        saveBtn.frame = CGRectMake((kScreenWidth - 298)/2, kScreenHeight - 19 - kHomeIndicatorHeight - 47, 298, 47)
        saveBtn.backgroundColor = UIColor(rgb: 0xB09964)
        saveBtn.layer.cornerRadius = 6
        saveBtn.layer.masksToBounds = true
        view.addSubview(saveBtn)
    }
    
    @objc func switchBtnAction() {
        switchBtn?.isSelected = !switchBtn!.isSelected
    }
    
    @objc func saveBtnAction() {
        
        var params:NSMutableDictionary = NSMutableDictionary()
        for i in 0..<dataList.count {
            let cell:MWAddAddressCell = tableView?.cellForRow(at: IndexPath(row: i, section: 0)) as! MWAddAddressCell
            if cell.inputTextField.text!.count == 0 {
                SVProgressHUD.showError(withStatus: self.dataList[i]["placeholder"])
                return
            }else{
                if(i == 0){
                    params["name"] = cell.inputTextField.text
                }else if( i == 1) {
                    params["phone"] = cell.inputTextField.text
                }else if( i == 2) {
                    params["address"] = cell.inputTextField.text
                }else if( i == 3) {
                    params["detail"] = cell.inputTextField.text
                }
            }
        }
        
        let postList:NSMutableArray = NSMutableArray()
        if (UserDefaults.standard.value(forKey: "kAddress") != nil) {
            postList.addObjects(from: UserDefaults.standard.value(forKey: "kAddress") as! [Any])
        }
        if switchBtn!.isSelected == true {
            params["isDefault"] = true
            
            for (index,item) in postList.enumerated() {
                (item as! NSMutableDictionary)["isDefault"] = false
                postList.replaceObject(at: index, with: item)
            }
        }
        if(isEdit && editIndex >= 0){
            postList.replaceObject(at: editIndex, with: params)
        }else{
            postList.add(params)
        }
        
        UserDefaults.standard.setValue(postList, forKey: "kAddress")
        self.navigationController?.popViewController(animated: true)
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

extension MWAddAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cellID"
        
        var cell:MWAddAddressCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? MWAddAddressCell
        
        if(cell == nil){
            cell = MWAddAddressCell.init(style: .default, reuseIdentifier: cellId)
            cell?.backgroundColor = UIColor.clear
            cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        }
        cell?.titleLabel?.text = self.dataList[indexPath.row]["title"]
        cell?.inputTextField.placeholder = self.dataList[indexPath.row]["placeholder"]
        if (editData != nil) {
            if(indexPath.row == 0){
                cell?.inputTextField.text = (editData!["name"] as! String)
            }else if( indexPath.row == 1) {
                cell?.inputTextField.text = (editData!["phone"] as! String)
            }else if( indexPath.row == 2) {
                cell?.inputTextField.text = (editData!["address"] as! String)
            }else if( indexPath.row == 3) {
                cell?.inputTextField.text = (editData!["detail"] as! String)
            }
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tableView didSelectRowAt")
    }
    
}
