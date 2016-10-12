//
//  RmdGameCell.swift
//  DY-swift
//
//  Created by C on 16/10/9.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

class RmdGameCell: UICollectionViewCell {

    //MARK: 控件属性
    /// 图片控件
    @IBOutlet weak var imageView: UIImageView!
    /// 标题控件
    @IBOutlet weak var titelLabel: UILabel!
    
    //MARK: 数据模型属性
    var groupMode:RecommedGroupMode? {
    
        didSet{
            // 1. 校验模型数据是否为nil
            guard let groupMode = groupMode   else { return }
            
            // 2. 给控件传入模型数据
            setDataModeToUI(rmdGroupMode: groupMode)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    
    // 重写属性
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置圆角
        imageView.layer.cornerRadius = (imageView.frame.size.width * 0.5)
        imageView.layer.masksToBounds = true
    }
}


//MARK: 给控件传入数据
extension RmdGameCell{
    
    // 给RecommedHeaderView控件设置模型数据
    fileprivate func setDataModeToUI(rmdGroupMode:RecommedGroupMode){
        
        // 头部icon
        if let iconURL = URL(string: rmdGroupMode.icon_url ?? "" ) {
            imageView.kf.setImage(with: iconURL)
        } else {
            imageView.image = UIImage(named: "home_more_btn")
        }
        
        // 头部标题
        titelLabel.text = rmdGroupMode.tag_name
        
    }
}
