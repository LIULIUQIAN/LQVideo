//
//  HomeViewController.swift
//  LQVideo
//
//  Created by Liuliuqian on 2019/3/30.
//  Copyright © 2019年 LLQ. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK:- ui
extension HomeViewController{
    
    fileprivate func setupUI(){
        setupNav()
        setupContentView()
        
    }
    private func setupNav(){
        let logoImage = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(HomeViewController.followItemClick))
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        searchBar.placeholder = "主播昵称/房间号/链接"
        searchBar.searchBarStyle = .minimal
        let searchFiled = searchBar.value(forKey: "_searchField") as! UITextField
        searchFiled.textColor = UIColor.white
        navigationItem.titleView = searchBar
    }
    
    fileprivate func setupContentView() {
        // 1.获取数据
        let homeTypes = loadTypesData()
        
        // 2.创建主题内容
        let style = LQTitleStyle()
        style.isScrollEnable = true
        let pageFrame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 44)
 
        let titles = homeTypes.map({ $0.title })
        var childVcs = [AnchorViewController]()
        for type in homeTypes {
            let anchorVc = AnchorViewController()
            anchorVc.homeType = type
            childVcs.append(anchorVc)
        }
        let pageView = LQPageView(frame: pageFrame, titles: titles, style: style, childVcs: childVcs, parentVc: self)
        view.addSubview(pageView)
    }
    
    fileprivate func loadTypesData() -> [HomeType] {
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        let dataArray = NSArray(contentsOfFile: path) as! [[String : Any]]
        var tempArray = [HomeType]()
        for dict in dataArray {
            tempArray.append(HomeType(dict: dict))
        }
        return tempArray
    }
    
}

//MARK:- 点击事件
extension HomeViewController{
    
    @objc fileprivate func followItemClick() {
        print("aaa")
    }
    
}

