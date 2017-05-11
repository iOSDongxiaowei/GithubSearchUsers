//
//  GSUUsersTableViewCell.swift
//  GithubSearchUsers
//
//  Created by dongxiaowei on 2017/5/10.
//  Copyright © 2017年 iOSDongxiaowei. All rights reserved.
//

import UIKit

class GSUUsersTableViewCell: UITableViewCell {


    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func insertCell(userItem:(name : String?, language : String?, avatar : String?))
    {
        self.keyLabel.text = "用户名:" + (userItem.name ?? "")
        self.valueLabel.text = "使用最多的语言:" + (userItem.language ?? "")
        self.avatarImageView.sd_setImage(with: URL(string: userItem.avatar ?? ""))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
