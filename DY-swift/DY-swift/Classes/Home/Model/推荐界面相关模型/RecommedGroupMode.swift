//
//  RecommedGroupMode.swift
//  DY-swift
//
//  Created by C on 16/10/7.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

class RecommedGroupMode: NSObject {

    //MARK: 定义推荐组模型属性
    /// 定义组的标题（默认""）
    var tag_name : String = ""
    /// 定义组的图标（默认home_header_normal）
    var icon_name : String = "home_header_normal"
    /// 游戏对应的图标
    var icon_url: String?
    /// 定义组内Items数组（默认home_header_normal）
    var room_list : [[String:NSObject]]? {
        
        didSet{ 
            // 1.判断如果room_list为nil则返回
            guard let room_list = room_list else { return  }
            
            // 2.监听：从把传进来的room_list数组中提取出字典，转化为RecommedItemMode模型，再把模型存入items属性中
            for value in room_list{
                let item = RecommedItemMode(dict: value)
                itemModes.append(item)
            }
        }
    }
    
    /// 定义主播的模型对象数组
    var itemModes : [RecommedItemMode] =  [RecommedItemMode]()
    
    //MARK: 构造方法
    override init(){
        super.init()
    }
    
    init(dict:[String:NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
}

//MARK: 监听KVC
extension RecommedGroupMode{
    
    // 如果进入字典存在key 但模型中不存在此key 会调用此方法
    // 重写能防止上述问题出现而崩溃
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
    
}

//MARK: 打印模型中所有属性
extension RecommedGroupMode{
    
    override var description: String{
        let properties = ["tag_name", "icon_name", "room_list", "itemModes"]
        return "\(dictionaryWithValues(forKeys: properties))\n"
    }
}
