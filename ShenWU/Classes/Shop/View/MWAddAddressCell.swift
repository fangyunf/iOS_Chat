//
//  MWAddAddressCell.swift
//  MassageW
//
//  Created by Amy on 2024/1/29.
//

import UIKit

class MWAddAddressCell: UITableViewCell {
    var titleLabel:UILabel?
    var inputTextField:UITextField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = createLabel(text: "", textColor: UIColor(rgb: 0x333333), font: UIFont.boldFont(withSize: 14))
        titleLabel?.frame = CGRectMake(15, 0, 56, 55)
        titleLabel?.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(titleLabel!)
        
        inputTextField.frame = CGRectMake(87, 0, kScreenWidth - 87 - 15, 55)
        inputTextField.textColor = UIColor.black
        inputTextField.font = UIFont.regularFont(withSize: 13)
        self.contentView.addSubview(inputTextField)
        
        let lineView = UIView()
        lineView.frame = CGRectMake(86, 55, kScreenWidth - 86 - 15, 0.5)
        lineView.backgroundColor = UIColor(rgb: 0xe9e9e9)
        self.contentView.addSubview(lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
