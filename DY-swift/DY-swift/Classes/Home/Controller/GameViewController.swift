//
//  GameViewController.swift
//  DY-swift
//
//  Created by C on 16/10/12.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

//MARK: >>>>>>>>>常量属性定义
fileprivate let kEdegMargin:CGFloat = 10.0
fileprivate let kGameCellW:CGFloat = (kScreenW - 2 * kEdegMargin) / 3
fileprivate let kGameCellH:CGFloat = kGameCellW * 6/5
fileprivate let kGameHeaderCellW:CGFloat = kScreenW
fileprivate let kGameHeaderCellH:CGFloat = 30

fileprivate let kGameCellId = "gameCellId"
fileprivate let KGameHeaderCellId = "kRmdHeaderCellId"

class GameViewController: UIViewController {
    
    

    // MARK: 懒加载
    fileprivate lazy var gameCollectionView:UICollectionView = {//UICollectionView
    
        [weak self] in
        
        // 1. 设置layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kGameCellW, height: kGameCellH)
        layout.headerReferenceSize = CGSize(width: kGameHeaderCellW, height: kGameHeaderCellH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kEdegMargin, bottom: 0, right: kEdegMargin)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 2. 创建UICollectionView 且 设置属性
        let collectionView = UICollectionView(frame:(self?.view.bounds)! , collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 3. 注册Cell
        /// 头部Cell
        collectionView.register(UINib(nibName: "RecommedHeaderView", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader , withReuseIdentifier: KGameHeaderCellId)
        
        /// 身体Cell
        collectionView.register(UINib(nibName: "GameCollectionCell", bundle: nil), forCellWithReuseIdentifier: kGameCellId)
        
        return collectionView
        
    }()
    
    fileprivate lazy var gameViewMode:GameViewMode = {
    
        let gameViewMode = GameViewMode()
        return gameViewMode
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始化UI
        setupUI()
        
        // 获取网络数据
        requsetData()
    }

}


//MARK: 初始化UI
extension GameViewController{

    fileprivate func setupUI(){
    
        // 添加UICollectionView
        view.addSubview(gameCollectionView)
    }
    
}


// MARK: 获取网络数据
extension GameViewController{
    
    fileprivate func requsetData(){
        
        // 获取Game游戏界面数据
        gameViewMode.getData { (isSuccess) in
            
            if isSuccess{
                self.gameCollectionView.reloadData()
            }
        }
        
    }
}



// MARk: 遵守UICollectionViewDataSource协议
extension GameViewController:UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameViewMode.gameModes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // 0. 定义reusableView
        let reusableView:UICollectionReusableView
        
        // 1. 如果是头部header
        if kind == UICollectionElementKindSectionHeader {
            
            // 1.1 获取头部headerCell
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: KGameHeaderCellId, for: indexPath)
            
            // 1.2 校验view类型是否为RecommedHeaderView
            guard  let headView:RecommedHeaderView = reusableView as? RecommedHeaderView else { return reusableView }
            
            // 1.3 传入头部数据
            headView.titleLabel.text = "全部"
            headView.iconImageView.image = UIImage(named: "Img_orange")
            headView.moreBtn.isHidden = true
            
        }else{
            reusableView = UICollectionReusableView()
        }
        
        // 2. 返回reusableView
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:GameCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellId, for: indexPath) as! GameCollectionCell
        
        cell.gameMode = gameViewMode.gameModes[indexPath.row]
        
        return cell
    }
    
}


// MARK: 遵守UICollectionViewDelegate协议
extension GameViewController:UICollectionViewDelegate{

    
}
