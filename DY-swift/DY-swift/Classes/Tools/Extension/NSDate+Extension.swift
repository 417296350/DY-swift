//
//  NSDate+Extension.swift
//  DY-swift
//
//  Created by C on 16/10/7.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit


extension NSDate{

    /// 返回当前时间距离1970年的秒数(返回类型->字符串)
    class func getTimeSince1970()->String{
        return "\(NSDate().timeIntervalSince1970)"
    }
}
