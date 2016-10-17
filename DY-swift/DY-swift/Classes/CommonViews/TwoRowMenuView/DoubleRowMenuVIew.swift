//
//  DoubleRowMenuVIew.swift
//  DY-swift
//
//  Created by C on 16/10/17.
//  Copyright © 2016年 程旭东. All rights reserved.
//
//  1.创建对象doubleRowMenuVIewFormNib
//  2.设置frame
//  3.创建自己的最终要展示的Cell,进行布局。
//  4.设置showCellNibName、showCellIdnetifer、showCellNubOfSection
//  5.传入数据dataModes type [AnyObject]

import UIKit

//MARK: - 常量属性
let kDoubelRowCellName = "DoubleRowShowCell"
let kDoubelRowCellId = "DoubleRowShowCell"

class DoubleRowMenuVIew: UIView {
    
    //MARK: -------------------- 对外暴露属性
    /// 最后要展示CELL的xib名称
    var showCellNibName:String? = nil
    /// 最后要展示CELL的ID名称
    var showCellIdnetifer:String? = nil
    /// 每一页要展示Cell的数量 [默认为8]
    var showCellNubOfSection:NSInteger = 8
    /// 数据属性
    var dataModes:[AnyObject]?{
        
        didSet{
            // 1. 校验
            guard  dataModes != nil else { return }
            
            // 2. 因为特殊原因，需要这里注册Cell
            collectionView.register(UINib(nibName: kDoubelRowCellName, bundle: nil), forCellWithReuseIdentifier: kDoubelRowCellId)
            
            // 2. 刷新
            collectionView.reloadData()
        }
    }
    
    
    //MARK: 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var pageControl: UIPageControl!
    

    //MARK: VIEW生命周期
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 跳转autoresing属性无效[因为父类已经开启，会影响到子类，而此控件不希望开启这个属性，所以这里需要处理]
        autoresizingMask = UIViewAutoresizing()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置容器上的Cell大小[容器Cell大小等于CollectionView大小]
        layout.itemSize = CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}


//MARK: - 快速创建View
extension DoubleRowMenuVIew{

    /// 快速加载xib创建veiw
    class func doubleRowMenuVIewFormNib()->DoubleRowMenuVIew{
        return Bundle.main.loadNibNamed("DoubleRowMenuVIew", owner: nil, options: nil)?.first as! DoubleRowMenuVIew
    }
}


//MARK: - 遵守UICollectionViewDataSource协议
extension DoubleRowMenuVIew:UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if dataModes == nil {
            return 0
        }
        
        pageControl.numberOfPages = ((dataModes?.count)!/showCellNubOfSection) + 1
        
        return ((dataModes?.count)!/showCellNubOfSection) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:DoubleRowShowCell = collectionView.dequeueReusableCell(withReuseIdentifier: kDoubelRowCellId, for: indexPath) as! DoubleRowShowCell
        
        setupDataTo(cell: cell, IndexPath: indexPath)
        
        
        return cell
    }
    
    /// 给Cell传递数据
    private func setupDataTo(cell:DoubleRowShowCell,IndexPath:IndexPath){
    
        // 1. 传递外界所指定的CellId、CellXib对应的名称
        cell.showCellIdnetifer = showCellIdnetifer
        cell.showCellNibName = showCellNibName
        
        // 2. 数据模型数组
        let startNumb = IndexPath.row * showCellNubOfSection
        var endNumb = ((IndexPath.row + 1) * 8) - 1

        if endNumb > (dataModes?.count)! {
            endNumb = (dataModes?.count)! - 1
        }
    
        cell.dataModes = Array(dataModes![startNumb...endNumb])
        
    }
}


//MARK: - 遵守UICollectionViewDelegate协议
extension DoubleRowMenuVIew:UICollectionViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
