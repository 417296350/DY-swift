//
//  AmuseViewMode.swift
//  DY-swift
//
//  Created by C on 16/10/15.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

class AmuseViewMode: NSObject {

    //MARK: 属性定义
    //-----------------暴露的属性
    var rmdAmuseGroupModes:[RecommedGroupMode] = []    //推荐人界面中collectView需要的存放所有组模型的数组
}


// 网络请求
extension AmuseViewMode{

    // 获取娱乐界面展示数据
    func requestData(finishCallBack:@escaping (_ isSuccess:Bool)->()){
        
        // 定义参数
        NetWorkTools.requsetData(method: .GET, urlString: nDouYuDNS + nDouYuAmuse) { (ResponseResult) in
            
            // 0. 如果网络出错直接返回
            if ResponseResult.error != nil  {
                print("获取推荐信息网络出错")
                finishCallBack(false)
                return
            }
            
            
            // 1. 判断返回数据最外层是否为字典
            guard let rmdDataDict = ResponseResult.jsonData as? [String:NSObject] else{ print("第零组热门推荐数据数据解析出错：数据最外层不是字典类型"); return }
            
            // 2. 判断rmdDataDict[data]是否为数组
            guard let rmdDataArr:[[String:NSObject]] = rmdDataDict["data"] as? Array else{
                print("第零组热门推荐数据数据解析出错:rmdDataDict[data]不是数组类型")
                return
            }
            
            
            // 3. 遍历数组,添加itemMode到组模型的数组属性中
            for value in rmdDataArr{
                let rmdBigMode = RecommedGroupMode(dict: value)
                self.rmdAmuseGroupModes.append(rmdBigMode)
            }
            
            // 4. 回调
            finishCallBack(true)
    }
}

}
