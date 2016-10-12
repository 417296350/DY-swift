//
//  PageContentView.swift
//  DY-Swift
//
//  Created by C on 16/10/1.
//  Copyright © 2016年 程旭东. All rights reserved.
//
//  说明： 这是页面切换所使用的内容View

import UIKit

private let cellIdentifier = "pageContentViewCell"

protocol PageContentViewDeleagte:class {
    
    // pageContentView滑动会触发的方法
    func pageContentView(_ pageContentView:PageContentView,progress:CGFloat,newScrollIndex:NSInteger,oldScrollInde:NSInteger)
}

class PageContentView: UIView {

    // MARK: 存储属性
    fileprivate weak var parentVC:UIViewController?    ///父控制器(两个控制器正在互相引用)
    fileprivate let childVCs:[UIViewController]        ///子控制器数组
    fileprivate var currentOffX:CGFloat = 0            ///当前CollectionView的X偏移量
    fileprivate var progress:CGFloat = 0               ///当前CollectionView滚动偏移量
    fileprivate var oldScrollIndex:NSInteger = 0       ///滚动前后CollectionView的内容页索引
    fileprivate var newScrollIndex:NSInteger = 0       ///完成滚动后CollectionView的内容页索引
    weak var delegate:PageContentViewDeleagte?         ///代理
    var isAllowDodelegate:Bool = true                  ///代理
    
    
    // MARK: 懒加载属性
    fileprivate lazy var pageCollectionView:UICollectionView = {//当前视图中的子视图:UICollectionView视图
    
        [weak self] in
        
        // 1. 设置layout布局
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.itemSize = CGSize(width: (self?.bounds.size.width)!, height: (self?.bounds.size.height)!)
        
        // 2. 创建设置UICollectionView
        let collectionView:UICollectionView = UICollectionView(frame: (self?.bounds)!, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        // 3. 注册Cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        return collectionView
        
    }()
    
    
    // MARK: 构造方法
    init(frame: CGRect,parentVC:UIViewController,childVCs:[UIViewController]) {
        
        // 1. self的存储属性初始化
        self.parentVC = parentVC
        self.childVCs = childVCs
        
        // 2. 根据需求调用父控制器的构造方法(同时间接初始化了父控制器中的所有存储属性)
        super.init(frame:frame)
        
        // 3. 初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: 初始化UI
extension PageContentView{

    fileprivate func setupUI(){
        
        // 1. 把所有子控制器添加到父控制器中
        addAllChildVCToParentVC()
        
        // 2. 添加创建UICollectionView （因为全局都会用，所有定义属性，最后考虑用懒加载）
        setupCollectionView()
    }
    
    fileprivate func addAllChildVCToParentVC(){
    
        for (childVC) in self.childVCs{
            
            guard let exsitParentVC = parentVC else {
                print("未传入父控制器parentVC")
                return
            }
            exsitParentVC.addChildViewController(childVC)
        }
    }
    
    fileprivate func setupCollectionView(){
        addSubview(pageCollectionView)
    }
}

// MARK: 修改UI
extension PageContentView{

    /// 根据传入的索引，把控制器内容切换到指定索引的内容中去
    fileprivate func changeMoveToContentView(_ index:NSInteger){
        let offsetX:CGFloat = CGFloat(index) * pageCollectionView.frame.size.width
        pageCollectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
    
}


// MARK: UICollectionViewDateSource
extension PageContentView:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 1. 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        // 2. 循环引用（循环引用导致的拿出的那个Cell内容还是上一次的，这里清空这Cell）
        for subView in cell.contentView.subviews{
            subView.removeFromSuperview()
        }
        
        // 3. 设置Cell内容
//        childVCs[indexPath.row].view.backgroundColor = UIColor.randomColor()
        cell.contentView.addSubview(childVCs[indexPath.row].view)
        
        // 4. 返回Cell
        return cell
    }
}


// MARK: UICollectionViewDelegate
extension PageContentView:UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // 开始拖拽这个代码方法最适合记录当前继承Scrollview控件的偏移量
        currentOffX = scrollView.contentOffset.x
        
        // 开启执行代理（只有手动拖动时候才会走这个代理，系统设置让滚动的情况不会来）
        isAllowDodelegate = true
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 0.判断是否是点击事件
        if isAllowDodelegate == false { return }
    
        // 如果是按钮点击，不应该进入这个里的滚动
        if isAllowDodelegate == false { return }
        
        // 0. 获取滚动过程中的偏移量
        let scrollingOffX = scrollView.contentOffset.x
        
        // 1. 计算滚动偏移量距滚动前内容所处在偏移量的差：scrollingOffX - currentOffX
        let detalOffX = scrollingOffX - currentOffX
        
        // 2. 获取每次滚动一页的最大距离(默认就scrollView的宽度)
        let scrollMaxW = scrollView.frame.size.width
        
        // 3. 向右滚动
        if detalOffX < 0 {
            
            // 1.计算progress
            progress = 1 - (scrollingOffX / scrollMaxW - floor(scrollingOffX / scrollMaxW))
            
            // 2.计算targetIndex
            newScrollIndex = Int(scrollingOffX / scrollMaxW)
            
            // 3.计算sourceIndex
            oldScrollIndex = newScrollIndex + 1
            if oldScrollIndex >= childVCs.count {
                oldScrollIndex = childVCs.count - 1
            }
            
            // 3.4 判断滚动结束后把新、旧索进行再次确定计算(右侧滚动算法无需这一步)
            
        }
        
        // 4. 向左滚动
        if detalOffX > 0 {
            
            // 1.计算progress
            progress = scrollingOffX / scrollMaxW - floor(scrollingOffX / scrollMaxW)
            
            // 2.计算sourceIndex
            oldScrollIndex = Int(scrollingOffX / scrollMaxW)
            
            // 3.计算targetIndex
            newScrollIndex = oldScrollIndex + 1
            if newScrollIndex >= childVCs.count {
                newScrollIndex = childVCs.count - 1
            }
            
            // 4.如果完全划过去
            if scrollingOffX - currentOffX == scrollMaxW {
                progress = 1
                newScrollIndex = oldScrollIndex
            }
            
        }
        
        // 4. 代理通知
        guard let exsiteDelgate = delegate else {
            print("PageContentViewDeleagte没有设置代理")
            return
        }
        if  isAllowDodelegate == true  {
            exsiteDelgate.pageContentView(self, progress: progress, newScrollIndex: newScrollIndex, oldScrollInde: oldScrollIndex)
        }
        
    }
    
}


// MARK: 对外公用的方法
extension PageContentView{

    /// 根据传入的索引，来切换内容控制器的内容
    internal func switchContentView(_ newIndex:NSInteger){
        
        // 0. 设置可执行代理 (防止循环:点击label(label内部已经对相关属性做调整了)->发生滚动->滚动后代理又去设置lable相关属性（因为第一步已经设置了，没必要）)
        isAllowDodelegate = false
        
        // 1. 把UICollectionView内容切换到指定索引对应的内容去
        changeMoveToContentView(newIndex)


    }
}


