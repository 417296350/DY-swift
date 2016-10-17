//
//  RecommedBaseViewCell.swift
//  DY-swift
//
//  Created by C on 16/10/9.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

class RecommedBaseViewCell: UICollectionViewCell {
    
    // MARK: 控件数据 （所有继承此BaseCell的子CELL公用的控件属性）
    //房间背景图片
    @IBOutlet weak var roomBackgroudImageView: UIImageView!
    //主播名称
    @IBOutlet weak var anchorNameLabel: UILabel!
    //房间在线人数
    @IBOutlet weak var onlinePNumButton: UIButton!
    
    // MARK: 模型属性
    var rmdItemMode:RecommedItemMode? {
    
        didSet{
            // 1. 校验传入数据是否为空
            guard let rmdItemMode = rmdItemMode else { return }
            
            // 2. 给控件设置模型数据
            setDataModeToUI(rmdItemMode: rmdItemMode)
        }
    }
}



//MARK: 给控件传入数据
extension RecommedBaseViewCell{
    
    // 给RecommedNormalCell控件设置模型数据
    fileprivate func setDataModeToUI(rmdItemMode:RecommedItemMode){
        
        // 房间背景图片[房间封皮]
        guard let bgdImageURL = URL(string: rmdItemMode.vertical_src) else {return}
        roomBackgroudImageView.kf.setImage(with: bgdImageURL, placeholder: UIImage(named: "live_cell_default_phone"), options: nil, progressBlock: nil, completionHandler: nil);
        
        // 房间在线人数
        onlinePNumButton.setTitle("\(rmdItemMode.online)", for: .normal)
        
        // 主播名称
        anchorNameLabel.text = rmdItemMode.nickname
        
    }
    
}
