//
//  RmdGameView.swift
//  DY-swift
//
//  Created by C on 16/10/9.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

//MARK: 常量属性
let kRmdGameCellId = "RmdGameCellIdentifer"

class RmdGameView: UIView {
    
    //MARK: 控件属性
    @IBOutlet weak var collectView: UICollectionView!
    
    //MARK: 数据模型属性
    ////////////////// 推荐组模型
    var rmdGroupModes:[RecommedGroupMode]? {
        
        didSet{
            
            // 1. 移除热门组 和 颜值组 (剩下的游戏组就是需要的数据组了)
            rmdGroupModes?.removeFirst()
            rmdGroupModes?.removeFirst()
            
            // 2. 在最后在添加一组更多按钮
            let lastGroupMode = RecommedGroupMode()
            lastGroupMode.tag_name = "更多"
            rmdGroupModes?.append(lastGroupMode)
            
            // 3. 刷新collectView
            collectView.reloadData()
        }
    }
    
    //MARK: 数据模型属性
    /////////////////// 推荐游戏模型
    var rmdGameModes:[GameMode]? {
        
        didSet{
            // 1. 刷新collectView
            collectView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1. 清空此控件autoresizingMASK属性
        autoresizingMask = UIViewAutoresizing()
        
        // 2. 初始化collectView
        
        // 3. 注册cell
        collectView.register(UINib(nibName: "RmdGameCell", bundle: nil), forCellWithReuseIdentifier: kRmdGameCellId)
    }
}


//MARK: 快速创建RmdGameView对象
extension RmdGameView{

    /// 通过XIB创建RmdGameView对象
    class func rmdGameViewFromNib()->RmdGameView{
        return Bundle.main.loadNibNamed("RmdGameView", owner: nil, options: nil)?.first as! RmdGameView
    }
}

//MARK: 遵守collectViewDataSource数据协议
extension RmdGameView:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rmdGroupModes?.count ?? rmdGameModes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 1. 获取cell
        let cell = collectView.dequeueReusableCell(withReuseIdentifier: kRmdGameCellId, for: indexPath) as! RmdGameCell
        
        // 2. 传入数据
        if rmdGameModes?.count != 0 {
            cell.groupMode = rmdGroupModes?[indexPath.row]
        }
        
        if  rmdGameModes?.count !=  0{
            cell.gameMode = rmdGameModes?[indexPath.row]
        }
        

        // 3. 返回cell
        return cell
    }
}
