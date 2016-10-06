//
//  UIBarButtonItem+Extension.swift
//  DY-Swift
//
//  Created by C on 16/10/1.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

// MARK: UIBarButtonItem构造方法的扩展
extension UIBarButtonItem{

    /// 通过传入的参数来返回一个UIBarButtonItem(注意：此方法内置了默认参数)
    convenience init(imageName:String,highlightedImageName:String = "",size:CGSize = CGSize.zero) {
        
        // 1. 创建按钮
        let buttonItem:UIButton = UIButton()
        
        // 2. 设置属性（默认参数不设置图片点击高亮）
        buttonItem.setImage(UIImage(named: imageName), for: UIControlState.normal)
        if  highlightedImageName != "" {//不是内置参数，说明外界自己设置了此属性，那么就设置
            buttonItem.setImage(UIImage(named: highlightedImageName), for: UIControlState.highlighted)
        }
        
        // 3. 设置Frame（默认参数=按钮大小随图片大小而定）
        buttonItem.sizeToFit()
        if size != CGSize.zero {//不是内置参数，说明外界设置了此属性，那么就按照外面的来
            buttonItem.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        
        self.init(customView:buttonItem)
    }
    
}
