//
//  CarouselAdsView.swift
//  DY-swift
//
//  Created by C on 16/10/9.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

//MARK: 常量
/// CELL标识符
let kCrsAdsCellId = "crsAdsCellIdentfier"
/// 最多创建Cell的数量
let kMaxCellNumber:NSInteger = 1000

class CarouselAdsView: UIView {

    //MARK: 控件属性
    /// collectionView
    @IBOutlet weak var crsAdsCollectionView: UICollectionView!
    /// flowlayout
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    /// pageControl
    @IBOutlet weak var crsAdsPageControl: UIPageControl!
    
    //MARK: 定义属性
    // 定时器属性
    var timer : Timer?
    
    //MARK: 数据模型属性
    var crsAdsMode:[CsrAdsMode]? {
        didSet{
            // 1. 校验是否为nil
            guard (crsAdsMode != nil) else { return }
            
            // 2. 设置pageControl
            crsAdsPageControl.numberOfPages = (crsAdsMode?.count)!
            
            // 3. 设置collectView展示页面为(crsAdsMode?.count数量的10倍且小于kMaxCellNumber - crsAdsMode?.count)
            // 目的让collectView不是默认显示第一页，而是从中间开始显示，能保证可向左侧滑动
            let offSetX = kScreenW * CGFloat((crsAdsMode?.count)! * 10)
            crsAdsCollectionView.setContentOffset(CGPoint(x: offSetX , y: 0), animated: false)
            
            // 4. 刷新collectView
            crsAdsCollectionView.reloadData()
            
            // 5. 开启定时器
            addTimer()
        }
    }
    
    
    //MARK: 控件生命周期
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1. 禁用此控件的autoresizingMASK [因为此控件所添加的父控件开启了,因此此控件也收到了印象，最后影响的看不到了此控件，所以禁用]
        autoresizingMask = UIViewAutoresizing()
        
        // 2. 设置UI属性
        setAttributeToAllUI()
    }
    
    
    //MARK: 重写父类属性
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 由于xib默认有控件大小，代码设置大小后最外层会随代码改变，所有要拿到最后控件的真正frame，必须在这里
        layout.itemSize = CGSize(width: kScreenW, height: self.frame.size.height)
    }
    
}


//MARK: 快速创建CarouselAdsView对象
extension CarouselAdsView{

    /// 从XIB中快速创建CarouselAdsView对象
    class func carouselAdsViewFromNib() -> CarouselAdsView{
        return Bundle.main.loadNibNamed("CarouselAdsView", owner: nil
            , options: nil)?.first as! CarouselAdsView
    }
}


//MARK: 设置化UI
extension CarouselAdsView{

    /// 给所有UI设置属性
    fileprivate func setAttributeToAllUI(){
    
        // 1. 设置collectView属性
        setAtrributeToCollectionView()
        
        // 2. 设置pageControl属性
        setAtrributeToPageControl()
        
    }
    
    /// 给collectView设置相关属性
    fileprivate func setAtrributeToCollectionView(){
    
        // 1. 设置layout布局
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        // 2. 设置collectView
        crsAdsCollectionView.showsHorizontalScrollIndicator = true
        crsAdsCollectionView.isPagingEnabled = true
        
        // 3. 注册collectViewCell
        crsAdsCollectionView.register(UINib(nibName: "CrsAdsCell", bundle: nil), forCellWithReuseIdentifier: kCrsAdsCellId)
    }
    
    /// 给pageControl设置相关属性
    fileprivate func setAtrributeToPageControl(){
        crsAdsPageControl.currentPage = 0
    }
    
}


//MARK: 定时器
extension CarouselAdsView{

    // 添加定时器
    fileprivate func addTimer(){
        
        if (timer != nil) {
            removerTimer()
        }
        
        let ktimeInterval = 3.0
        timer = Timer(timeInterval: ktimeInterval, target: self, selector: #selector(self.finishTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    // 关闭定时器
    fileprivate func removerTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    // 监听定时器
    @objc fileprivate func finishTimer(){
        
        // 滚动一页广告
        let offsetX = crsAdsCollectionView.contentOffset.x + kScreenW
        crsAdsCollectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

///MARK: 遵守UICollectionViewDataSource协议
extension CarouselAdsView:UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (crsAdsMode?.count ?? 0) * kMaxCellNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 1. 获取cell
        let crsAdsCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCrsAdsCellId, for: indexPath) as! CrsAdsCell
        
        // 2. 传入数据
        let row = (indexPath.row % (crsAdsMode?.count)!)
        crsAdsCell.csrAdsMode = crsAdsMode?[row]
        
        // 3. 返回数据
        return crsAdsCell
    }
}

///MARK: 遵守UICollectionViewDelegate协议
extension CarouselAdsView:UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 关闭定时器
        removerTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 开启定时器
        addTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 计算scollView应该滚动到的页数
        let scrollViewPageNumb:Int = Int((scrollView.contentOffset.x + kScreenW * 0.5) / kScreenW)
        
        // 计算pageControl应该滚动到的页数
        let pageCurrentNumb:Int = Int(scrollViewPageNumb % (crsAdsMode?.count)!)
        
        // 赋值给pagecontrol
        crsAdsPageControl.currentPage = pageCurrentNumb
        
    }
}


