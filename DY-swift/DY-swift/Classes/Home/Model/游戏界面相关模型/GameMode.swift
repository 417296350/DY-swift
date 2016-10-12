//
//  GameMode.swift
//  DY-swift
//
//  Created by C on 16/10/12.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

class GameMode: NSObject {
    
    // MARK:- 定义属性
    var tag_name : String = ""
    var icon_url : String = ""
    
    
    // MARK: 构造函数
    init(dict:[String:NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
}


// KVC处理
extension GameMode{

    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
