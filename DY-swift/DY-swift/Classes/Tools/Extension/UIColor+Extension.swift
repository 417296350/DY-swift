//
//  UIColor+Extension.swift
//  DY-Swift
//
//  Created by C on 16/10/1.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit


// MARK: UIColor构造方法的扩展
extension UIColor{

    /// 快捷通过RGA设置UIColor颜色
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    /// 快捷通过元祖来设置RGA完成UIColor颜色
    convenience init(rgbGanso:(r:CGFloat,g:CGFloat,b:CGFloat)) {
        self.init(red: rgbGanso.r/255.0, green: rgbGanso.g/255.0, blue: rgbGanso.b/255.0, alpha: 1)
    }
    
    /// 随机色
    class func randomColor() -> (UIColor){
        return UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
    }
}
