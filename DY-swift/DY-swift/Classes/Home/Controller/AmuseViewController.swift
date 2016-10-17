//
//  AmuseViewController.swift
//  DY-swift
//
//  Created by C on 16/10/13.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

//MARK: - 常量属性
let kAmuserHeaderViewH:CGFloat = 200.0

class AmuseViewController: HomeBaseViewController {

    // MARK: 懒加载
    /// --- view属性
    fileprivate lazy var amuseHeaderView:DoubleRowMenuVIew = {//头部View
        
        let amuseHeaderView:DoubleRowMenuVIew = DoubleRowMenuVIew.doubleRowMenuVIewFormNib()
        amuseHeaderView.frame = CGRect(x: 0, y: -kAmuserHeaderViewH, width: kScreenW, height: kAmuserHeaderViewH)
        amuseHeaderView.showCellNibName = "RmdGameCell"
        amuseHeaderView.showCellIdnetifer = "RmdGameCellIdentifer"
        amuseHeaderView.showCellNubOfSection = 8
        return amuseHeaderView
    
    }()
    
    /// --- viewMode属性
    fileprivate lazy var amuseViewMode:AmuseViewMode = AmuseViewMode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化UI
        setupUI()
        
        // 获取网络数据
        requsetData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}

//MARK: 初始化UI
extension AmuseViewController{

    override func setupUI() {
        
        // 1. 先父类初始化collectView控件
        super.setupUI()

        // 2. 创建collectView的头部header
        rmdCollectionView.addSubview(amuseHeaderView)
        
        // 3. 设置collectView内边距
        rmdCollectionView.contentInset = UIEdgeInsets(top: kAmuserHeaderViewH, left: 0, bottom: 0, right: 0)
    }
}


//MARK: 网络请求部分
extension AmuseViewController{
    
    func requsetData(){

        // 2. 请求推荐数据
        amuseViewMode.requestData{ [weak self] (isSuccess) in
            
            if isSuccess{
                
                // 2.1 把请求到的数据传递给游戏推荐控件
                self?.rmdModes = (self?.amuseViewMode.rmdAmuseGroupModes)!
                
                // 2.2 把数据传递给头部控件  
                var tempGroups = (self?.amuseViewMode.rmdAmuseGroupModes)!
                tempGroups.removeFirst()
                self?.amuseHeaderView.dataModes = tempGroups
                
            }else{
                print("requsetRecommedData():获取推荐界面数据失败")
            }
        }
        
    }
    
}
