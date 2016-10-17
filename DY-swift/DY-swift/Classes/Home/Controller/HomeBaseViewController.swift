//
//  HomeBaseViewController.swift
//  DY-swift
//
//  Created by C on 16/10/13.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit


// 常量属性
///>>>>>>>>>>>>>>----------collectView相关
fileprivate let kMinLineSpacing:CGFloat = 0.0    //collectView最小行距
fileprivate let kMinItemSpacing:CGFloat = 10.0   //collectView中Cell最小间隔

let KItemNoramlCellW:CGFloat = (kScreenW - kMinItemSpacing * 3) * 0.5
//collectView中普通Cell宽度
let kItemNoramlCellH:CGFloat = KItemNoramlCellW * 3 / 4
//collectView中普通Cell宽度
let KItemPrettyCellW:CGFloat = KItemNoramlCellW
//collectView中颜值Cell宽度
let kItemPrettyCellH:CGFloat = KItemNoramlCellW * 4 / 3
//collectView中颜值Cell高度

fileprivate let kItemHeaderH:CGFloat = 50.0                         //collectView中Header高度

fileprivate let kRmdHeaderCellNibName = "RecommedHeaderView"   //collectVeiw中header的nib名称
fileprivate let kRmdNormalCellNibName = "RecommedNormalCell"   //collectVeiw中普通Cell的nib名称
fileprivate let kRmdPrettyCellNibName = "RecommedPrettyCell"   //collectVeiw中颜值Cell的nib名称

fileprivate let kRmdHeaderCellIdentifer = "kRmdHeaderCellId"  //collectVeiw中header的identifier
fileprivate let kRmdNormalCellIdentifer = "kRmdNormalCellId"  //collectVeiw中普通Cell的identifier
let kRmdPrettyCellIdentifer = "kRmdPrettyCellId"  //collectVeiw中颜值Cell的identifier

class HomeBaseViewController: UIViewController {

    
    // MARK: 懒加载
    lazy var rmdCollectionView:UICollectionView = {//创建collectView
        
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
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // 2.x 设置collecttion内边距，让处于Y负值的控件内容显示出来
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
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
    
    // MARK: 传入的数据
    var rmdModes:[RecommedGroupMode] = [RecommedGroupMode]() {
    
        didSet{
            rmdCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化UI
        setupUI()
    }

}


//MARK: 初始化
extension HomeBaseViewController{
    
    func setupUI(){
        
        // 1.添加UICollectionView
        view.addSubview(rmdCollectionView)
        
    }
}


//MARK: 遵守UICollectionViewDataSource数据源方法
extension HomeBaseViewController:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rmdModes.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rmdGroupMode:RecommedGroupMode = rmdModes[section]
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
            headView.rmdGroupMode = self.rmdModes[indexPath.section]
            
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
        // 显示普通cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRmdNormalCellIdentifer, for: indexPath) as! RecommedNormalCell
        
        // 2. 传入数据
        let rmdGroupMode:RecommedGroupMode = rmdModes[indexPath.section]
        cell.rmdItemMode = rmdGroupMode.itemModes[indexPath.row]
        
        // 3. 返回cell
        return cell
        
    }
}


//MARK: 遵守UICollectionViewDelegate数据源方法
extension HomeBaseViewController:UICollectionViewDelegate{

}
