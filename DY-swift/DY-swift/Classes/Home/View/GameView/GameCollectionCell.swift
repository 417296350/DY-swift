//
//  GameCollectionCell.swift
//  DY-swift
//
//  Created by C on 16/10/12.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

class GameCollectionCell: UICollectionViewCell {

    // MARK: 属性定义
    /// 游戏图标
    @IBOutlet weak var gameIcon: UIImageView!
    /// 游戏标题
    @IBOutlet weak var gameTitle: UILabel!
    
    // MARK: 数据模型定义
    var gameMode:GameMode? {
    
        didSet{        
            // 1. 校验数据是否为nil
            guard let gameMode = gameMode else { return }
            
            // 2. 数据传给控件
            setDataToUI(gameMode: gameMode)
        }

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

// MARK: 重写属性
extension GameCollectionCell{

    override func layoutSubviews() {
        super.layoutSubviews()

    }
}


// MARK: 给控件传递数据
extension GameCollectionCell{

    // 把模型的数据传递给控件
    fileprivate func setDataToUI(gameMode:GameMode){
    
        // 给游戏图标传入数据
        if let gameIconURL = URL(string: gameMode.icon_url){
            self.gameIcon.kf.setImage(with: gameIconURL)
        }else{
            self.gameIcon.image = UIImage(named: "home_more_btn")
        }
        
        // 给游戏标题传入数据
        self.gameTitle.text = gameMode.tag_name
        
    }
}
