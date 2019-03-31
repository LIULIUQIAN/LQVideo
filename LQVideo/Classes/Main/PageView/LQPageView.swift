//
//  LQPageView.swift
//  LQVideo
//
//  Created by Liuliuqian on 2019/3/31.
//  Copyright © 2019年 LLQ. All rights reserved.
//

import UIKit

class LQPageView: UIView {

    // MARK: 定义属性
    fileprivate var titles : [String]!
    fileprivate var style : LQTitleStyle!
    fileprivate var childVcs : [UIViewController]!
    fileprivate weak var parentVc : UIViewController!
    
    fileprivate var titleView : LQTitleView!
    fileprivate var contentView : LQContentView!
    
    // MARK: 自定义构造函数
    init(frame: CGRect, titles : [String], style : LQTitleStyle, childVcs : [UIViewController], parentVc : UIViewController) {
        super.init(frame: frame)
        
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        parentVc.automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK:- 设置界面内容
extension LQPageView {
    fileprivate func setupUI() {
        let titleH : CGFloat = 44
        let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        titleView = LQTitleView(frame: titleFrame, titles: titles, style : style)
        titleView.delegate = self
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
        contentView = LQContentView(frame: contentFrame, childVcs: childVcs, parentViewController: parentVc)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        addSubview(contentView)
    }
}


// MARK:- 设置HYContentView的代理
extension LQPageView : LQContentViewDelegate {
    func contentView(_ contentView: LQContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: LQContentView) {
        titleView.contentViewDidEndScroll()
    }
}


// MARK:- 设置HYTitleView的代理
extension LQPageView : LQTitleViewDelegate {
    func titleView(_ titleView: LQTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}
