//
//  MainTabBarVC.swift
//  DY-Swift
//
//  Created by C on 16/9/30.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {

    // 存放索要添加所有控制器的storyboard文件名、bar图片的数组[数组元素为元祖]
    let childVCArr = [(storyboardName:"Home",imageName:"btn_home"),(storyboardName:"Live",imageName:"btn_live"),(storyboardName:"Follow",imageName:"btn_column"),(storyboardName:"Profile",imageName:"btn_user")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 添加子首页、直播、关注、我控制器
        addChildsToMainTabBarVC(childVCArr)
       
    }

}


// MARK: 控制器初始化
extension MainTabBarVC {
    
    // 添加子首页、直播、关注、我控制器
    fileprivate func addChildsToMainTabBarVC(_ childVCArr: [(storyboardName:String,imageName:String)]) -> () {
        
        for childItem in childVCArr {
            addChildVC(childItem.storyboardName, imageName:childItem.imageName);
        }
    }

    // 添加子控制器
    fileprivate func addChildVC(_ storyboardName:String!,imageName:String!)->(){
        
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        
        guard let vc = sb.instantiateInitialViewController() else {
            print("func：addChildVC 中没有找到控制器")
            return
        }
        
        vc.tabBarItem.title = storyboardName
        vc.tabBarItem.image = UIImage(named: imageName + "_normal")
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_seleted")
        
        addChildViewController(vc)
        
    }
}


