//
//  UIRespond+DoubleRowViewExtention.swift
//  DY-swift
//
//  Created by C on 16/10/17.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

extension UIResponder{

    private struct AssociatedKeys {
        static var dbRowdataMode:NSObject?
    }
    
    
    // 所有展示的showItemCell接受数据的属性 [自定义]
    var dbRowdataMode: NSObject? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.dbRowdataMode) as? NSObject
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.dbRowdataMode, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
}
