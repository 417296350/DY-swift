//
//  NetWorkTools.swift
//  DY-swift
//
//  Created by C on 16/10/7.
//  Copyright © 2016年 程旭东. All rights reserved.
//
//  @escaping : 准许函数结束后闭包仍然执行(适合异步)

import UIKit
import Alamofire

//MARK: 定义GET、POST枚举
enum MethodType{
    case GET
    case POST
}

//MARK: 定义请求参数类型
typealias Parameters = [String : Any]

//MARK: 定义请求结果回调闭包
typealias FinishCallBack = (_ response:ResponseResult)->Swift.Void

//MARK: 定义请求结果回调返回外界的结构体参数
struct ResponseResult{

    var request: URLRequest?
    
    var response: HTTPURLResponse?
    
    var data:Data?
    var jsonData:AnyObject?
    
    var error:Error?
    var isSuccess:Bool?
}



class NetWorkTools: NSObject {
    
    /// 单例
    static let shareNetWork:NetWorkTools = NetWorkTools()

}

//MAKR: 脱离开业务的网络请求
extension NetWorkTools{

    /// 获取数据Data Request
    class func requsetData(method:MethodType,urlString:String,parameters:Parameters?=nil,finishCallBack:@escaping FinishCallBack){
        
        let methodType = (method == .GET ? HTTPMethod.get : HTTPMethod.post)
        
        Alamofire.request(urlString, method: methodType, parameters: parameters).response{ (DataResponse) in
            
            // 处理返回参数
            let responseResult = NetWorkTools.shareNetWork.responseResult(dataResponse: DataResponse)
            
            // 回调
            finishCallBack(responseResult)
            
        }
        
    }
}


//MAKR: 包含业务的网络请求
extension NetWorkTools{
    
}

//MAKR: 把返回的相应数据解析成ResponseResult结构体
extension NetWorkTools{

    func responseResult(dataResponse:DefaultDataResponse)->ResponseResult{
        
        // 1. 初始化ResponseResult结构体
        var responseResult:ResponseResult = ResponseResult()
        
        // 2. 赋值请求和相应参数
        responseResult.request = dataResponse.request
        responseResult.request = dataResponse.request

        // 3. 判断网络情况
        if (dataResponse.error == nil) {
            
            responseResult.isSuccess = true
            
            responseResult.data = dataResponse.data
            
            do {
               // 如果能解析成JSON，则解析JSON给jsonData属性
               responseResult.jsonData =  try JSONSerialization.jsonObject(with: dataResponse.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                
            }catch{
                // 不能解析，则jsonData属性为nil
                responseResult.jsonData = nil
            }
           
            
        }else{
            responseResult.isSuccess = false
            responseResult.error = dataResponse.error
           
        }

        
        return responseResult
    }
}
