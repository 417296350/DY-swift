//
//  RmdGameCell.swift
//  DY-swift
//
//  Created by C on 16/10/9.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

class RmdGameCell: UICollectionViewCell {

    //MARK: 控件属性
    /// 图片控件
    @IBOutlet weak var imageView: UIImageView!
    /// 标题控件
    @IBOutlet weak var titelLabel: UILabel!
    
    //MARK: 数据模型属性
    ////// 组模型
    var groupMode:RecommedGroupMode? {
    
        didSet{
            // 1. 校验模型数据是否为nil
            guard let groupMode = groupMode   else { return }
            
            // 2. 给控件传入模型数据
            setGroupDataModeToUI(rmdGroupMode: groupMode)
        }
    }
    
    ////// 游戏模型
    var gameMode:GameMode? {
        
        didSet{
            // 1. 校验模型数据是否为nil
            guard let gameMode = gameMode   else { return }
            
            // 2. 给控件传入模型数据
            setGameDataModeToUI(rmdGmaeMode: gameMode)
        }
    }
    
    ////// 两组滚动控件DoubleRowMenuVIew的数据模型
    override var dbRowdataMode: NSObject?{
    
        didSet{
        
            // 1. 校验模型数据是否为nil
            guard let dbRowdataMode = dbRowdataMode   else { return }
            
            // 2. 校验是否能转化为RecommedGroupMode模型
            guard let groupMode:RecommedGroupMode = dbRowdataMode as? RecommedGroupMode else { return }
            
            // 3. 给控件传入模型数据
            setGroupDataModeToUI(rmdGroupMode: groupMode)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    
    // 重写属性
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}


//MARK: 给控件传入数据
extension RmdGameCell{
    
    // 给RecommedHeaderView控件设置模型数据
    fileprivate func setGroupDataModeToUI(rmdGroupMode:RecommedGroupMode){
        
        // 头部icon
        if let iconURL = URL(string: rmdGroupMode.icon_url ?? "" ) {
            imageView.kf.setImage(with: iconURL)
        } else {
            imageView.image = UIImage(named: "home_more_btn")
        }
        
        // 头部标题
        titelLabel.text = rmdGroupMode.tag_name
        
    }
    
    
    // 给RecommedHeaderView控件设置模型数据
    fileprivate func setGameDataModeToUI(rmdGmaeMode:GameMode){
        
        // 头部icon
        if let iconURL = URL(string: rmdGmaeMode.icon_url ) {
            imageView.kf.setImage(with: iconURL)
        } else {
            imageView.image = UIImage(named: "home_more_btn")
        }
        
        // 头部标题
        titelLabel.text = rmdGmaeMode.tag_name
        
    }
    
}
