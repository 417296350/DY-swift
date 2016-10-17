//
//  RecommedViewMode.swift
//  DY-Swift
//
//  Created by C on 16/10/6.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit


class RecommedViewMode: NSObject {

    //MARK: 属性定义
    //-----------------暴露的属性
    var rmdAllGroupModes:[RecommedGroupMode] = []    //推荐人界面中collectView需要的存放所有组模型的数组
    var csrAdsModes:[CsrAdsMode] = []                //推荐人界面上方广告控件需要的存放广告模型数据的数组
    
    //-----------------内部使用的属性
    fileprivate lazy var rmdBigGroupMode:RecommedGroupMode = RecommedGroupMode()     //推荐人界面存放热门推荐模型的数组
    fileprivate lazy var rmdVerticaGroupMode:RecommedGroupMode = RecommedGroupMode()     //推荐人界面存放颜值组模型的数组
    fileprivate lazy var rmdHotCateModes:[RecommedGroupMode] = []
                                //推荐人界面存放热门游戏组模型的数组
    
    
    fileprivate var isRequstBigDataSuccess:Bool = false     //请求推荐人热门数据是否成功
    fileprivate var isRequstVerticaSuccess:Bool = false     //请求推荐人颜值数据是否成功
    fileprivate var isRequstHotCateSuccess:Bool = false     //请求推荐人热门游戏数据是否成功

}


//MARK: 网络请求
extension RecommedViewMode{

    /// 请求网络，获取推荐界面数据
    func requsetRecommedData(finishCallBack:@escaping (_ isSuccess:Bool)->()){

        // 0. 创建一个组队列(用于判断异步请求是否结束)
        let group = DispatchGroup()
        
        // 1. 第零组热门推荐数据()
        requstBigData(group:group)
        
        // 2. 第一组颜值推荐数据()
        requsetVerticalData(group:group)
        
        // 3. 第二~十二组游戏推荐数据()
        requsetHotCateData(group:group)
        
        // 4. 利用group判断上面三个异步网络请求是否都执行完，执行完则有顺序的添加模型到数组中
        group.notify(queue: DispatchQueue.main) { 
            
            // 1.数组中存放RecommedGroupMode模型，存放顺序为:0组、1组、2~11组
            
            // 0组
            self.rmdAllGroupModes.append(self.rmdBigGroupMode)
            // 1组
            self.rmdAllGroupModes.append(self.rmdVerticaGroupMode)
            // 2~11组
            for value in self.rmdHotCateModes{
                self.rmdAllGroupModes.append(value)
            }
            
            // 2. 回调给外界
            if self.isRequstBigDataSuccess || self.isRequstVerticaSuccess || self.isRequstHotCateSuccess{//如果有一组数据请求成功，则回到给外界就告诉成功了
                
                finishCallBack(true)
                
            }else{//否则，告诉外界获取数据失败
                
                finishCallBack(false)
            }
            
        }
        
    }
    
    /// 请求网络，获取轮播广告数据
    func requstCrsAdsData(finishCallBack:@escaping (_ isSuccess:Bool)->()){
        
        NetWorkTools.requsetData(method: .GET, urlString: nDouYuDNS+nDouYuCrsAds, parameters: ["version" : "2.300"]) { (ResponseResult) in
            
            // 0. 如果网络出错直接返回
            if ResponseResult.error != nil  {
                print("获取推荐轮播广告网络出错")
                finishCallBack(false)
                return
            }
            
            // 1.获取整体字典数据
            guard let resultDict = ResponseResult.jsonData as? [String : NSObject] else { return }
            
            // 2.根据data的key获取数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.字典转模型对象
            for dict in dataArray {
                self.csrAdsModes.append(CsrAdsMode(dict: dict))
            }
            
            // 4.回调告诉成功
            finishCallBack(true)
        }
    }
    
    
    /// 获取第0组热门推荐信息 （group：组队列——>用于判断异步请求是否结束）
    fileprivate func requstBigData(group:DispatchGroup? = nil) {

        // 在异步代码执行前，先把组队列添加一下
        if group != nil {
            group!.enter()
        }
        
        // 请求网络
        NetWorkTools.requsetData(method: .GET, urlString: nDouYuDNS + nDouYubigDataRoom, parameters: ["time" : NSDate.getTimeSince1970()]) { (ResponseResult) in
            
            // 0. 如果网络出错直接返回
            if ResponseResult.error != nil  {
                print("获取推荐信息网络出错")
                self.isRequstBigDataSuccess = false
                if group != nil {
                    group!.leave()
                }
                return
            }
            
            // 1. 判断返回数据最外层是否为字典
            guard let rmdDataDict = ResponseResult.jsonData as? [String:NSObject] else{ print("第零组热门推荐数据数据解析出错：数据最外层不是字典类型"); return }
            
            // 2. 判断rmdDataDict[data]是否为数组
            guard let rmdDataArr:[[String:NSObject]] = rmdDataDict["data"] as? Array else{
                print("第零组热门推荐数据数据解析出错:rmdDataDict[data]不是数组类型")
                return
            }
            
            // 3. 设置热门中组模型的数据(斗鱼针对热门部分没有返回组模型数据，但UI确需要，比如头部标题、头部内容图片等，所以既然斗鱼没有返回此数据，就在本地设置热门部分对应的组模型数据)
            self.rmdBigGroupMode.tag_name = "热门"
            self.rmdBigGroupMode.icon_name = "home_header_hot"
            
            // 4. 遍历数组,添加itemMode到组模型的数组属性中
            for value in rmdDataArr{
                let rmdBigMode = RecommedItemMode(dict: value)
                self.rmdBigGroupMode.itemModes.append(rmdBigMode)
            }
            
            // 5. 移除组队列(告诉系统这个异步线程结束，这样系统执行dispatch_notfi才明白)
            self.isRequstBigDataSuccess = true
            if group != nil {
                group!.leave()
            }
            
        }

    }
    
    /// 获取第1组颜值推荐信息 （group：组队列——>用于判断异步请求是否结束）
    fileprivate func requsetVerticalData(group:DispatchGroup? = nil){
    
        // 在异步代码执行前，先把组队列添加一下
        if group != nil {
            group!.enter()
        }
        
        // 定义参数
        let parameters = ["limit" : "4", "offset" : "0", "time" : NSDate.getTimeSince1970()]
        
        // 请求网络
        NetWorkTools.requsetData(method: .GET, urlString: nDouYuDNS + nDouYuVerticalRoom, parameters: parameters) { (ResponseResult) in
            
            // 0. 如果网络出错直接返回
            if ResponseResult.error != nil  {
                self.isRequstVerticaSuccess = false
                if group != nil {
                    group!.leave()
                }
                return
            }
            
            // 1. 判断返回数据最外层是否为字典
            guard let rmdDataDict = ResponseResult.jsonData as? [String:NSObject] else{ print("第零组热门推荐数据数据解析出错：数据最外层不是字典类型"); return }
            
            // 2. 判断rmdDataDict[data]是否为数组
            guard let rmdDataArr:[[String:NSObject]] = rmdDataDict["data"] as? Array else{
                print("第零组热门推荐数据数据解析出错:rmdDataDict[data]不是数组类型")
                return
            }
            
            // 3. 设置热门中组模型的数据(斗鱼针对热门部分没有返回组模型数据，但UI确需要，比如头部标题、头部内容图片等，所以既然斗鱼没有返回此数据，就在本地设置热门部分对应的组模型数据)
            self.rmdVerticaGroupMode.tag_name = "颜值"
            self.rmdVerticaGroupMode.icon_name = "home_header_phone"
            
            // 4. 遍历数组,添加itemMode到组模型的数组属性中
            for value in rmdDataArr{
                let rmdBigMode = RecommedItemMode(dict: value)
                self.rmdVerticaGroupMode.itemModes.append(rmdBigMode)
            }
            
            // 5. 移除组队列(告诉系统这个异步线程结束，这样系统执行dispatch_notfi才明白)
            self.isRequstVerticaSuccess = true
            if group != nil {
                group!.leave()
            }
        }
    }
    
    /// 获取第2~11热门游戏推荐信息 （group：组队列——>用于判断异步请求是否结束）
    fileprivate func requsetHotCateData(group:DispatchGroup? = nil){
        
        // 在异步代码执行前，先把组队列添加一下
        if group != nil {
            group!.enter()
        }
        
        // 定义参数
        let parameters = ["limit" : "4", "offset" : "0", "time" : NSDate.getTimeSince1970()]
        
        NetWorkTools.requsetData(method: .GET, urlString: nDouYuDNS + nDouYuHotCate, parameters: parameters) { (ResponseResult) in
            
            // 0. 如果网络出错直接返回
            if ResponseResult.error != nil  {
                print("获取推荐信息网络出错")
                self.isRequstHotCateSuccess = false
                if group != nil {
                    group!.leave()
                }
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
                self.rmdHotCateModes.append(rmdBigMode)
            }
            
            // 4. 移除组队列(告诉系统这个异步线程结束，这样系统执行dispatch_notfi才明白)
            self.isRequstHotCateSuccess = true
            if group != nil {
                group!.leave()
            }
            
        }
    }
    
    
}
