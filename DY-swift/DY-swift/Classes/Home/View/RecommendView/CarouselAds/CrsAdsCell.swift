//
//  CrsAdsCell.swift
//  DY-swift
//
//  Created by C on 16/10/9.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

class CrsAdsCell: UICollectionViewCell {
    
    //MARK: 控件属性
    /// 图片
    @IBOutlet weak var imageView: UIImageView!
    /// 文字内容
    @IBOutlet weak var label: UILabel!
    
    //MARK: 数据模型属性
    var csrAdsMode:CsrAdsMode? {
        didSet{
            // 1. 校验模型数据是否为nil
            guard let csrAdsMode = csrAdsMode else { return }
            
            // 2. 把数据内容传给控件
            setDataModeToUI(csrAdsMode: csrAdsMode)
        }
    }
    
}


//MARK: 给控件传入数据
extension CrsAdsCell{
    
    // 给RecommedHeaderView控件设置模型数据
    fileprivate func setDataModeToUI(csrAdsMode:CsrAdsMode){
        
        // 头部icon
        let imageURL = URL(string: csrAdsMode.pic_url)
        imageView.kf.setImage(with: imageURL)
        
        // 头部标题
        label.text = csrAdsMode.title
        
    }
}
