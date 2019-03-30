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

        // Do any additional setup after loading the view.
        setupUI()
    }
    

}

//MARK:- ui
extension HomeViewController{
    
    fileprivate func setupUI(){
        setupNav()
        
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
    
}

//MARK:- 点击事件
extension HomeViewController{
    
    @objc fileprivate func followItemClick() {
        print("aaa")
    }
    
}

