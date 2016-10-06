//
//  AppDelegate.swift
//  DY-swift
//
//  Created by C on 16/10/6.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 设置项目主题
        UITabBar.appearance().tintColor = UIColor.orange
        
        return true
    }
    
    
}

