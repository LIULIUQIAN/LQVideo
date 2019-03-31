//
//  LQNavigationController.swift
//  LQVideo
//
//  Created by Liuliuqian on 2019/3/30.
//  Copyright © 2019年 LLQ. All rights reserved.
//

import UIKit

class LQNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let targets = interactivePopGestureRecognizer?.value(forKey: "_targets")  as? [NSObject] else {return}
        let targetObjc = targets[0]
        let target = targetObjc.value(forKey: "target")
        let action = Selector(("handleNavigationTransition:"))
        
        let panGes = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(panGes)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }

    
}
