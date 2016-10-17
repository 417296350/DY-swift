//
//  RecommedViewController.swift
//  DY-Swift
//
//  Created by C on 16/10/5.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

// 常量属性
///>>>>>>>>>>>>>>----------CarouselAdsView广告控件相关
fileprivate let kRmdCrsAdsViewH:CGFloat = kScreenW * 3/8

///>>>>>>>>>>>>>>----------RmdGameView推荐游戏控件相关
fileprivate let kRmdGameViewH:CGFloat = 85



class RecommedViewController: HomeBaseViewController {

    // MARK: 懒加载
    fileprivate lazy var rmdCrsAdsView:CarouselAdsView = {// 广告控件
    
        let rmdCrsAdsView = CarouselAdsView.carouselAdsViewFromNib()
        rmdCrsAdsView.frame = CGRect(x: 0, y: -(kRmdCrsAdsViewH + kRmdGameViewH), width: kScreenW, height: kRmdCrsAdsViewH)
        return rmdCrsAdsView
    }()
    
    fileprivate lazy var rmdGameView:RmdGameView = {// 推荐游戏控件
        let rmdGameView = RmdGameView.rmdGameViewFromNib()
        rmdGameView.frame = CGRect(x: 0, y: -kRmdGameViewH, width: kScreenW, height: kRmdGameViewH)
        return rmdGameView
    }()
    
    fileprivate lazy var rmdViewMode:RecommedViewMode = RecommedViewMode()
    
    
    // MARK: 控制器声明周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.初始化UI(父类调用了setupUI)
        
        // 2.网络请求
        requsetData()
    }
}


//MARK: 初始化
extension RecommedViewController{

    internal override func setupUI(){
        
        // 1.先调用super.setupUI,保证执行能调用父类的setupUI进行collectView的初始化
        super.setupUI()
        
        // 2.添加轮播广告 [根据需求是需要添加到collectView上，而不是view上]
        rmdCollectionView.addSubview(rmdCrsAdsView)
        
        // 3.添加游戏推荐 [根据需求是需要添加到collectView上，而不是view上]
        rmdCollectionView.addSubview(rmdGameView)
        
        // 4.设置collectView的内边距
        rmdCollectionView.contentInset = UIEdgeInsetsMake(+kRmdCrsAdsViewH + kRmdGameViewH, 0, 0, 0)
    }
}

//MARK: 网络请求部分
extension RecommedViewController{

    func requsetData(){
        
        // 1. 请求广告数据
        rmdViewMode.requstCrsAdsData { (isSuccess) in
            
            if isSuccess{
                //  把获取到的传递数据给广告控件
                self.rmdCrsAdsView.crsAdsMode = self.rmdViewMode.csrAdsModes
            }else{
                print("requstCrsAdsData():获取推荐界面的轮播广告数据失败")
            }
        }
        
        // 2. 请求推荐数据
        rmdViewMode.requsetRecommedData { [weak self] (isSuccess) in
            
            if isSuccess{
                
                //  2.1 把请求到的数据传递给父控件
                self?.rmdModes = (self?.rmdViewMode.rmdAllGroupModes)!
                
                //  2.2 给游戏推荐传递数据
                self?.rmdGameView.rmdGroupModes = self?.rmdViewMode.rmdAllGroupModes
                
            }else{
                print("requsetRecommedData():获取推荐界面数据失败")
            }
        }
        
    }
    
}



//MARK: 重写父类遵守过的UICollectionViewDataSource数据源部分方法
// 因为父类已经遵守了UICollectionViewDataSource协议，所以子类扩展后面不需要在遵守
extension RecommedViewController{

    // 重写这个方法，是为了单独处理一下颜值Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1{//如果第一组的颜值cell，则自己处理
            
            let prettyCell = collectionView.dequeueReusableCell(withReuseIdentifier: kRmdPrettyCellIdentifer, for: indexPath) as! RecommedPrettyCell
            let rmdGroupMode:RecommedGroupMode = rmdModes[indexPath.section]
            prettyCell.rmdItemMode = rmdGroupMode.itemModes[indexPath.row]
            return prettyCell
            
        }else{//否则皆为普通cell，可统一由父类创建处理
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }
}

//MARK: 遵守UICollectionViewDelegateFlowLayout布局的代理方法
extension RecommedViewController:UICollectionViewDelegateFlowLayout{
    
    // 为了单独处理颜值cell 和 普通cell 的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {//可随意指定CELL的大小
        
        // 1. 初始化size属性
        var itemSize:CGSize
        
        // 2. 判断情况，设置cell大小
        if indexPath.section == 1 {//第一组情况下设置cell大小(颜值cell)
            itemSize = CGSize(width: KItemPrettyCellW, height: kItemPrettyCellH)
        }else{//其他组情况下设置cell大小(普通cell)
            itemSize = CGSize(width: KItemNoramlCellW, height: kItemNoramlCellH)
        }
        
        // 3.返回cell的Size
        return itemSize
    }
    
}

