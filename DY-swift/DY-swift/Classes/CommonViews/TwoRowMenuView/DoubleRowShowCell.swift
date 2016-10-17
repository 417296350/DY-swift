//
//  AmuseShowCell.swift
//  DY-swift
//
//  Created by C on 16/10/17.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

//MARK: - 常量属性

class DoubleRowShowCell: UICollectionViewCell {
    
    // 对外暴露的属性
    /// cellNibName属性
    var showCellNibName:String? = nil
    /// cellIdentifier属性
    var showCellIdnetifer:String? = nil
    /// 每一页要展示Cell的数量 [默认为8]
    var showCellNubOfSection:NSInteger = 8
    
    //MARK: 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    //MARK: 数据属性
    var dataModes:[AnyObject]?{
        
        didSet{
            // 1. 校验
            guard  dataModes != nil else { return }
            
            // 2. 因为特殊原因，所以在这里注册cell
            collectionView.register(UINib(nibName: showCellNibName!, bundle: nil), forCellWithReuseIdentifier: showCellIdnetifer!)
            
            // 3. 刷新
            collectionView.reloadData()
        }
    }
    
    //MARK: VIEW生命周期
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置ItemCell大小
        layout.itemSize = CGSize(width: collectionView.frame.size.width/CGFloat(showCellNubOfSection)*2.0, height: collectionView.frame.size.height * 0.5)
    }
}


//MARK: - 遵守UICollectionViewDataSource协议
extension DoubleRowShowCell:UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(showCellIdnetifer)
        // 1. 创建Cell：如果外面指定cell，则创建cell，否则默认创建娱乐cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: showCellIdnetifer!, for: indexPath)
        
        // 2. 传递数据
        cell.dbRowdataMode = dataModes?[indexPath.row] as!RecommedGroupMode?
        
        // 3. 返回Cell
        return cell
    }
}







