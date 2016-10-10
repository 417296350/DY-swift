//
//  RecommedHeaderView.swift
//  DY-Swift
//
//  Created by C on 16/10/5.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit
import Kingfisher

class RecommedHeaderView: UICollectionReusableView {

    //MARK: 控件属性
    @IBOutlet weak var iconImageView: UIImageView!  //头部icon
    
    @IBOutlet weak var titleLabel: UILabel!         //头部标题
    
    //MARK: 模型属性
    var rmdGroupMode:RecommedGroupMode? {
        
        didSet{
            // 校验模型中是否存在数据
            guard let rmdGroupMode = rmdGroupMode else {return }
            // 给当前headerView控件设置数据
            self.setDataModeToUI(rmdGroupMode:rmdGroupMode)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}


//MARK: 给控件传入数据
extension RecommedHeaderView{

    // 给RecommedHeaderView控件设置模型数据
    fileprivate func setDataModeToUI(rmdGroupMode:RecommedGroupMode){
        
        // 头部icon
        iconImageView.image = UIImage(named: rmdGroupMode.icon_name)
        
        // 头部标题
        titleLabel.text = rmdGroupMode.tag_name
    
    }
}
