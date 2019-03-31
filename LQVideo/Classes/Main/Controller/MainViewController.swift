//
//  MainViewController.swift
//  LQVideo
//
//  Created by Liuliuqian on 2019/3/30.
//  Copyright © 2019年 LLQ. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVc("Home")
        addChildVc("Rank")
        addChildVc("Discover")
        addChildVc("Profile")
    }
    
    fileprivate func addChildVc(_ storyName : String){
        let childVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        addChild(childVc)
    }
    

}
