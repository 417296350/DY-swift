
//
//  HomeViewController.swift
//  DY-Swift
//
//  Created by C on 16/10/1.
//  Copyright © 2016年 程旭东. All rights reserved.
//

import UIKit

private let kPageTitleViewH:CGFloat = 45.0

class HomeViewController: UIViewController {


    // MARK: 懒加载属性
    fileprivate lazy var pageTitleView:PageTitleView = {//标题工具条View
        
        [weak self] in
        
        let titles:[String] = ["推荐","游戏","娱乐","趣玩"]
        
        let pageTitelViewX:CGFloat = 0
        let pageTitelVeiwY:CGFloat = kStateBarH + kNavagationBarH
        let pageTitelVeiwW:CGFloat = kScreenW
        let pageTitelVeiwH:CGFloat = kPageTitleViewH
        
        let pageTitelView = PageTitleView(frame: CGRect(x: pageTitelViewX, y: pageTitelVeiwY, width: pageTitelVeiwW, height: pageTitelVeiwH), titles: titles)
        pageTitelView.delegate = self
        
        return pageTitelView
        
    }()
    
    fileprivate lazy var pageContentView:PageContentView = {//切换内容View
    
        [weak self] in
        
        // 确定Frame
        let pageContentViewX:CGFloat = 0
        let pageContentViewY:CGFloat = (self?.pageTitleView.frame.maxY)!
        let pageContentViewW:CGFloat = (self?.view.bounds.size.width)!
        let pageContentViewH:CGFloat = kScreenH - pageContentViewY - kTabBarH - 5
        let pageContentViewF:CGRect = CGRect(x: pageContentViewX, y: pageContentViewY, width: pageContentViewW, height: pageContentViewH)
        
        // 确定子控制器
        var chilidVCs:[UIViewController] = [UIViewController]()
        let recommedVC = RecommedViewController()
        let gameVC = GameViewController()
        chilidVCs.append(recommedVC)
        chilidVCs.append(gameVC)
        chilidVCs.append(UIViewController())
        chilidVCs.append(UIViewController())
        
        
        let pageContentView:PageContentView = PageContentView(frame: pageContentViewF, parentVC: self!, childVCs: chilidVCs)
        pageContentView.delegate = self
        return pageContentView
    }()
    
    
    // MARK: 控制器生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 不需要控制器自动调整UIScrollview的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 2. 初始化UI
        setupUI()
        
    }
}


// MARK: VC初始化
extension HomeViewController{
    
    fileprivate func setupUI(){
    
        // 初始化控制器的导航栏
        setupNavgationBar()
        
        // 初始化控制器View上的PageTitleView
        setupPageTitleView()
        
        // 初始化控制器View上的PageContentView
        setupPageContentView()
    }
    
    
    
    fileprivate func setupNavgationBar(){
        
        // 设置左边导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        // 设置右边导航栏按钮
        let Itemsize:CGSize = CGSize(width: 35, height: 35)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highlightedImageName: "Image_my_history_click",size:Itemsize)
        let searchItem  = UIBarButtonItem(imageName: "btn_search", highlightedImageName: "btn_search_clicked",size:Itemsize)
        let qrcodeItem  = UIBarButtonItem(imageName: "Image_scan", highlightedImageName: "Image_scan_click",size:Itemsize)
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
        
    }
    
    fileprivate func setupPageTitleView(){
        view.addSubview(pageTitleView)
    }
    
    fileprivate func setupPageContentView(){
        view.addSubview(pageContentView)
    }
    
}


// MARK: 遵守PageTitleViewDelegate代理方法
extension HomeViewController:PageTitleViewDelegate{
    
    func pageTitleViewA(_ pageTitleView: PageTitleView, didClickNewIndex: NSInteger, nextOldIndex: NSInteger) {
        
        // 把标题label点击索引变化的告诉PageContentView，让他内部发生改变
        pageContentView.switchContentView(didClickNewIndex)
    }

}

extension HomeViewController:PageContentViewDeleagte{

    func pageContentView(_ pageContentView: PageContentView, progress: CGFloat, newScrollIndex: NSInteger, oldScrollInde: NSInteger) {
        
        pageTitleView.switchTitleView(oldScrollInde, newIndex: newScrollIndex, progress: progress)
    }
}
