//
//  RecommedPrettyCell.swift
//  DY-Swift
//
//  Created by C on 16/10/5.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

class RecommedPrettyCell: RecommedBaseViewCell {

    //MARK: 控件属性 (特有控件 -- 公共控件全部放在父类RecommedBaseViewCell中了)
    // 地区按钮
    @IBOutlet weak var regionButton: UIButton!

    
    //MARK: 模型属性
    override var rmdItemMode:RecommedItemMode? {
    
        didSet{
            // 1. 校验传入数据是否为空
            guard let rmdItemMode = rmdItemMode else { return }
            
            // 2. 先把公共控件属性到父控件中统一赋值处理
            super.rmdItemMode = rmdItemMode
            
            // 3. 在设置给当前控件中特有的控件进行赋值
            setDataModeToUI(rmdItemMode: rmdItemMode)
        }
       
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}


//MARK: 给控件传入数据
extension RecommedPrettyCell{

    // 给RecommedPrettyCell控件设置模型数据
    fileprivate func setDataModeToUI(rmdItemMode:RecommedItemMode){  
        // 给地区按钮传入数据
        regionButton.setTitle(rmdItemMode.anchor_city, for: .normal)
    }
}
