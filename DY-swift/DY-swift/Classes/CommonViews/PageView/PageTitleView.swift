//
//  PageTitleView.swift
//  DY-Swift
//
//  Created by C on 16/10/1.
//  Copyright © 2016年 程旭东. All rights reserved.
//
//  说明： 这是页面切换所使用的标题工具条View

import UIKit

// MARK: 定义常量
private let titleTextNomalColor:(CGFloat,CGFloat,CGFloat) = (r:88.0,g:88.0,b:88.0)
private let titleTextHightColor:(CGFloat,CGFloat,CGFloat) = (r:255,g:128,b:0)

private let titleTextNomalFont:UIFont = UIFont.systemFont(ofSize: 15)
private let titleTextHightFont:UIFont = UIFont.boldSystemFont(ofSize: 17)

// MARK: 代理方法定义
protocol PageTitleViewDelegate:class{

    //  标题labe点击会调用：传出当前新索引、上一个旧索引
    func pageTitleViewA(_ pageTitleView:PageTitleView,didClickNewIndex:NSInteger,nextOldIndex:NSInteger)
}


class PageTitleView: UIView {
    
    // MARK: 存储属性
    fileprivate var titles:[String]                    //标题数组
    fileprivate var nextOldIndex:NSInteger = 0         //上一个旧索引
    fileprivate var newCurrentIndex:NSInteger = 0      //当前新的索引
    fileprivate var labels:[UILabel] = []              //存放所有子控件Label的数组
    weak var delegate:PageTitleViewDelegate?           //定义代理属性
    
    // MARK: 懒加载属性
    fileprivate lazy var pageScrollVeiw:UIScrollView = {//此控件的子视图:ScrollView
        
        [weak self] in
        
        let pageScrollView = UIScrollView()
        pageScrollView.frame = (self?.bounds)!
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.scrollsToTop = false
        pageScrollView.bounces = false
        pageScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return pageScrollView
        
    }()
    
    fileprivate lazy var pageBottomScrollLine:UIView = {//此控件的子视图：底部滚动条
        
        [weak self] in
        
        let pageBottomScrollLineW:CGFloat = (self?.bounds.size.width)! / CGFloat((self?.titles.count)!)
        let pageBottomScrollLineH:CGFloat = 2
        let pageBottomScrollLineX:CGFloat = 0
        let pageBottomScrollLineY:CGFloat = (self?.bounds.size.height)! - pageBottomScrollLineH
        
        let pageBottomScrollLine = UIView()
        pageBottomScrollLine.frame = CGRect(x: pageBottomScrollLineX, y: pageBottomScrollLineY, width: pageBottomScrollLineW, height: pageBottomScrollLineH)
        pageBottomScrollLine.backgroundColor = UIColor.orange
        
        return pageBottomScrollLine
        
    }()
    
    
    // MARK: 构造方法
    init(frame: CGRect,titles:[String]) {
        
        // 1. 子类创建构造方法，要先给自己内存属性属性赋值
        self.titles = titles
        
        // 2. 调用父类中，所需的那个构造方法(初始化父类中的所有存储属性)
        super.init(frame:frame)
        
        // 3. 初始化UI
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: 初始化UI
extension PageTitleView{
    
    fileprivate func setupUI(){
    
        // 1. 添加创建UIScrollview (因为此属性必然全局引用，所有创建属性，最终考虑懒加载最好)
        addSubview(pageScrollVeiw)

        // 2. 添加所有Label按钮
        setupAllLabels()
        
        // 3. 添加工具条
        setupBottomLine()
        
        // 4. 添加底部滚动条
        setupBottomScrollViewLine()
    }
    
    
    fileprivate func setupAllLabels(){
        
        let labelItemW = self.bounds.size.width/CGFloat(titles.count)
        let labelItemH = self.bounds.size.height
        let labelItemY:CGFloat = 0.0
        
        for (index,title) in self.titles.enumerated(){
        
            let labelItem = UILabel()
            
            labelItem.text = title
            changeLabelToNomal(labelItem)
            labelItem.textAlignment = NSTextAlignment.center
            labelItem.tag = index
            
            if index == newCurrentIndex {//默认首次创建第一个Label处于点击状态
                changeLabelToHight(labelItem)
            }
            
            let labelItemX = CGFloat(index) * labelItemW
            labelItem.frame = CGRect(x: labelItemX, y: labelItemY, width: labelItemW, height: labelItemH)
            
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.didClickTitleLabel(tapGes:)) )
            labelItem.addGestureRecognizer(tapGes)
            labelItem.isUserInteractionEnabled = true
            
            pageScrollVeiw.addSubview(labelItem)
            
            labels.append(labelItem)
        }
    }
    
    fileprivate func setupBottomLine(){
        
        let bottomLineW:CGFloat = pageScrollVeiw.contentSize.width
        let bottomLineH:CGFloat = 1.0
        let bottomLineX:CGFloat = 0
        let bottomLineY:CGFloat = bounds.size.height - bottomLineH
        
        let bottomLine = UIView()
        bottomLine.frame = CGRect(x: bottomLineX, y: bottomLineY, width: bottomLineW, height: bottomLineH)
        bottomLine.backgroundColor = UIColor.gray
        
        addSubview(bottomLine)
    }
    
    fileprivate func setupBottomScrollViewLine(){
        
        addSubview(pageBottomScrollLine)
    }
}

// MARK: 点击UI变化处理
extension PageTitleView{

    /// 根据传入的新、旧Label点击索引，来识别这个两个Label，且相应的改变两个LabelUI状态
    fileprivate func changeLabelState(_ newDidIndex:NSInteger,oldIndex:NSInteger,progress:CGFloat = 1.0){
        
        print(progress)
        

        for (index,label) in labels.enumerated(){
            
            if  index == oldIndex {
                changeLabelToNomal(label)
            }
            
            if index == newDidIndex {
                changeLabelToHight(label)
            }
        }


    }
    
    /// 修改Label状态为默认状态
    fileprivate func changeLabelToNomal(_ label:UILabel){
        label.textColor = UIColor(rgbGanso:titleTextNomalColor)
        label.font = titleTextNomalFont
    }
    
    /// 修改Label状态为高亮状态
    fileprivate func changeLabelToHight(_ label:UILabel){
        label.textColor = UIColor(rgbGanso:titleTextHightColor)
        label.font = titleTextHightFont
    }
    
    
    /// 根据index修改滚动条的位置
    fileprivate func changeBottomScrollLineFrame(_ newDidIndex:NSInteger){
        
        UIView.animate(withDuration: 0.56) {
            self.pageBottomScrollLine.frame.origin.x = CGFloat(newDidIndex) * self.pageBottomScrollLine.frame.size.width
        }
        
    }
    
    // 根据progress修改滚动条的位置
    fileprivate func changeBottomScrollLineFrame(_ progress:CGFloat,newIndex: NSInteger, oldIndex: NSInteger){
        
        // 0. 获取新、旧label
        let oldLabel = labels[oldIndex]
        let newLabel = labels[oldIndex]
        // 1. 计算滚动条滚动位置
        let startPostionX = oldLabel.frame.origin.x
        let detalMove = pageBottomScrollLine.frame.size.width * progress
        pageBottomScrollLine.frame.origin.x = startPostionX + detalMove
    }
}

// MARK: 处理点击事件
extension PageTitleView{

    /// 标题Label点击事件
    @objc fileprivate func didClickTitleLabel(tapGes:UITapGestureRecognizer){
        
        // 0. 保存旧索引属性
        nextOldIndex = newCurrentIndex
    
        // 1. 获取被点击的Label 及 被点击Label的索引
        let didClickLabel:UILabel = tapGes.view as! UILabel
        let didClickIndex:NSInteger = didClickLabel.tag
        
        // 2. 更新当前新的索引
        newCurrentIndex = didClickIndex
        
        // 3. 根据传入新、旧索引修改UI
        changeLabelState(newCurrentIndex, oldIndex: nextOldIndex)
        
        // 4. 更新滚动条的位置
        changeBottomScrollLineFrame(newCurrentIndex)
        
        // 5. 代理通知label点击索引的改变
        guard let exsitDelegate = delegate else {
            print("PageContentView的未设置代理属性")
            return
        }
        exsitDelegate.pageTitleViewA(self, didClickNewIndex: newCurrentIndex, nextOldIndex: nextOldIndex)
    }
}


// MARK: 对外的公共方法
extension PageTitleView{

    func switchTitleView(_ oldIndex:NSInteger,newIndex:NSInteger,progress:CGFloat){
        
        // 1. 切换新、旧按钮
        changeLabelState(newIndex, oldIndex: oldIndex,progress: progress)
        
        // 2. 移动底部工具条
        changeBottomScrollLineFrame(progress,newIndex: newIndex, oldIndex: oldIndex)
        
        // 3. 记录当前索引
        newCurrentIndex = newIndex
    }
}



