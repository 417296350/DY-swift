//
//  RecommedViewController.swift
//  DY-Swift
//
//  Created by C on 16/10/5.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

// 常量属性
///>>>>>>>>>>>>>>----------collectView相关
let kMinLineSpacing:CGFloat = 0.0    //collectView最小行距
let kMinItemSpacing:CGFloat = 10.0   //collectView中Cell最小间隔

let KItemNoramlCellW:CGFloat = (kScreenW - kMinItemSpacing * 3) * 0.5
                                                        //collectView中普通Cell宽度
let kItemNoramlCellH:CGFloat = KItemNoramlCellW * 3 / 4
                                                        //collectView中普通Cell宽度
let KItemPrettyCellW:CGFloat = KItemNoramlCellW
                                                        //collectView中颜值Cell宽度
let kItemPrettyCellH:CGFloat = KItemNoramlCellW * 4 / 3
                                                        //collectView中颜值Cell高度

let kItemHeaderH:CGFloat = 60.0                         //collectView中Header高度

let kRmdHeaderCellNibName = "RecommedHeaderView"   //collectVeiw中header的nib名称
let kRmdNormalCellNibName = "RecommedNormalCell"   //collectVeiw中普通Cell的nib名称
let kRmdPrettyCellNibName = "RecommedPrettyCell"   //collectVeiw中颜值Cell的nib名称

let kRmdHeaderCellIdentifer = "kRmdHeaderCellId"  //collectVeiw中header的identifier
let kRmdNormalCellIdentifer = "kRmdNormalCellId"  //collectVeiw中普通Cell的identifier
let kRmdPrettyCellIdentifer = "kRmdPrettyCellId"  //collectVeiw中颜值Cell的identifier

///>>>>>>>>>>>>>>----------CarouselAdsView广告控件相关
let kRmdCrsAdsViewH:CGFloat = kScreenW * 3/8

///>>>>>>>>>>>>>>----------RmdGameView推荐游戏控件相关
let kRmdGameViewH:CGFloat = 85



class RecommedViewController: UIViewController {

    // MARK: 懒加载
    fileprivate lazy var rmdCollectionView:UICollectionView = {//创建collectView
        
        [weak self] in
        
        // 0. 统一确定cell、header大小
        
        let itemHeaderW:CGFloat = kScreenW
    
        // 1. 创建、设置layout
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumLineSpacing = kMinLineSpacing
        collectionLayout.minimumInteritemSpacing = kMinItemSpacing
        collectionLayout.sectionInset = UIEdgeInsetsMake(0, kMinItemSpacing, 0, kMinItemSpacing)
        collectionLayout.itemSize = CGSize(width:KItemNoramlCellW , height: kItemNoramlCellH)
        collectionLayout.headerReferenceSize = CGSize(width: itemHeaderW, height: kItemHeaderH)
        collectionLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        // 2. 创建、设置collection
        let collectionView:UICollectionView = UICollectionView(frame: (self?.view.bounds)!, collectionViewLayout: collectionLayout)
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 2.x 设置collecttion内边距，让处于Y负值的控件内容显示出来
        collectionView.contentInset = UIEdgeInsets(top: kRmdCrsAdsViewH+kRmdGameViewH, left: 0, bottom: 0, right: 0)
        
        
        // 3. 注册header
        let headerNib = UINib(nibName: kRmdHeaderCellNibName, bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kRmdHeaderCellIdentifer)
        
        // 4. 注册cell  (普通cell  和  颜值cell)
        let normalCell = UINib(nibName: kRmdNormalCellNibName, bundle: nil)
        let prettyCell = UINib(nibName: kRmdPrettyCellNibName, bundle: nil)
        collectionView.register(normalCell, forCellWithReuseIdentifier: kRmdNormalCellIdentifer)
        collectionView.register(prettyCell, forCellWithReuseIdentifier: kRmdPrettyCellIdentifer)
        
        // 5. 返回collectView
        return collectionView
        
    }()
    
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
        
        // 初始化UI
        setupUI()
        
        // 网络请求
        requsetData()
    }
}


//MARK: 初始化
extension RecommedViewController{

    fileprivate func setupUI(){
        
        // 1.添加UICollectionView
        view.addSubview(rmdCollectionView)
        
        // 2.添加轮播广告 [根据需求是需要添加到collectView上，而不是view上]
        rmdCollectionView.addSubview(rmdCrsAdsView)
        
        // 3.添加游戏推荐 [根据需求是需要添加到collectView上，而不是view上]
        rmdCollectionView.addSubview(rmdGameView)
        
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
                
                // 2.1 把请求到的数据传递给游戏推荐控件
                self?.rmdGameView.rmdGroupModes = self?.rmdViewMode.rmdAllGroupModes
                
                // 2.2 刷新推荐人的collectView控件
                self?.rmdCollectionView.reloadData()
                
            }else{
                print("requsetRecommedData():获取推荐界面数据失败")
            }
        }
        
    }
    
}

//MARK: 遵守UICollectionViewDataSource数据源方法
extension RecommedViewController:UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rmdViewMode.rmdAllGroupModes.count
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rmdGroupMode:RecommedGroupMode = rmdViewMode.rmdAllGroupModes[section]
        return (rmdGroupMode.itemModes.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // 0. 定义reusableView
        let reusableView:UICollectionReusableView
        
        // 1. 如果是头部header
        if kind == UICollectionElementKindSectionHeader {
            
            // 1.1 获取头部headerCell
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kRmdHeaderCellIdentifer, for: indexPath)
            
            // 1.2 校验view类型是否为RecommedHeaderView
            guard  let headView:RecommedHeaderView = reusableView as? RecommedHeaderView else { return reusableView }
            
            // 1.3 传入头部数据
            headView.rmdGroupMode = self.rmdViewMode.rmdAllGroupModes[indexPath.section]
            
        }else{
            reusableView = UICollectionReusableView()
        }
        
        // 2. 返回reusableView
        return reusableView
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 0. 定义cell
        var cell:RecommedBaseViewCell
        
        // 1. 获取cell
        if indexPath.section == 1 {//0组显示颜值cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRmdPrettyCellIdentifer, for: indexPath) as! RecommedPrettyCell
        }else{//非1组显示普通cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRmdNormalCellIdentifer, for: indexPath) as! RecommedNormalCell
        }
        
        // 2. 传入数据
        let rmdGroupMode:RecommedGroupMode = rmdViewMode.rmdAllGroupModes[indexPath.section]
        cell.rmdItemMode = rmdGroupMode.itemModes[indexPath.row]
        
        // 3. 返回cell
        return cell
        
    }
}

//MARK: 遵守UICollectionViewDelegateFlowLayout布局的代理方法
extension RecommedViewController:UICollectionViewDelegateFlowLayout{
    
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
