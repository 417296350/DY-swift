//
//  GameViewMode.swift
//  DY-swift
//
//  Created by C on 16/10/12.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

class GameViewMode: NSObject {

    // MARK: 对外暴露的属性
    var gameModes:[GameMode] = [GameMode]()
    
}


// MARK: 网络请求
extension GameViewMode{

    // 获取数据
    func getData(finishCallBack:@escaping ((_ isSuccess:Bool)->())){
        
        // 获取斗鱼游戏界面数据
        getGameData(finishCallBack: finishCallBack)

    }
    
    // 获取斗鱼游戏界面数据
    fileprivate func getGameData(finishCallBack:@escaping ((_ isSuccess:Bool)->())){
        
        NetWorkTools.requsetData(method: .GET, urlString: "http://capi.douyucdn.cn/api/v1/getColumnDetail", parameters: ["shortName" : "game"]) { (ResponseResult) in
            
            // 1. 先判断是否出错
            if (ResponseResult.error != nil) {
                print("GameViewMode: 获取游戏数据失败")
                finishCallBack(false)
                return
            }
            
            // 2. 判断数据是否合理
            guard let responseJSon = ResponseResult.jsonData as? [String:NSObject]  else{
                print("GameViewMode: 解析数据失败，最外层返回数据不是字典")
                return
            }
            
            guard let data:[[String:NSObject]] = responseJSon["data"] as? [[String:NSObject]] else{
                print("GameViewMode: 解析数据失败，第二层返回数据不是数组")
                return
            }
            
            // 3. 解析数据
            for valueDict in data{
                
                let gameMode:GameMode = GameMode(dict: valueDict)
                self.gameModes.append(gameMode)
            }
            
            // 4. 回调
            finishCallBack(true)

        }

    }
}
