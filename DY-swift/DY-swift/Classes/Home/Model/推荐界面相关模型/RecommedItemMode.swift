//
//  RecommedItemMode.swift
//  DY-swift
//
//  Created by C on 16/10/7.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

class RecommedItemMode: NSObject {

    //MARK: 定义推荐Item(Cell)模型数据

    /// 判断是手机直播还是电脑直播
    // 0 : 电脑直播 1 : 手机直播
    var isVertical : Int = 0
    /// 房间ID
    var room_id : Int = 0
    /// 房间名称
    var room_name : String = ""
    /// 房间图片对应的URLString
    var vertical_src : String = ""
    /// 主播昵称
    var nickname : String = ""
    /// 观看人数
    var online : Int = 0
    /// 所在城市
    var anchor_city : String = ""
    
    //MARK: 构造方法
    init(dict:[String:NSObject]){
        super.init()
        setValuesForKeys(dict)
    }
    
}

//MARK: 监听KVC
extension RecommedItemMode{

    // 如果进入字典存在key 但模型中不存在此key 会调用此方法
    // 重写能防止上述问题出现而崩溃
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    
    }
    
    
}

//MARK: 打印模型中所有属性
extension RecommedItemMode{

    override var description: String{
        let properties = ["isVertical", "room_id", "room_name", "vertical_src","nickname","online","anchor_city"]
        return "\(dictionaryWithValues(forKeys: properties))\n"
    }
}
