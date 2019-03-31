//
//  HomeViewModel.swift
//  XMGTV
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 coderwhy. All rights reserved.
//  MVVM --> M(model)V(View)C(Controller网络请求/本地存储数据(sqlite)) --> 网络请求
// ViewModel : RAC/RxSwift

import UIKit

class HomeViewModel {
    lazy var anchorModels = [AnchorModel]()
}

extension HomeViewModel {
    func loadHomeData(type : HomeType, index : Int,  finishedCallback : @escaping () -> ()) {
        
        for _ in 0..<48{
            let md = AnchorModel()
            md.roomid = 1092240
            md.name = "美女直播"
            md.pic51 = "http://img2.ph.126.net/9zADa8NFFR0mqj8WnTEOQw==/2858378388597099017.jpg"
            md.pic74 = "http://img2.ph.126.net/9zADa8NFFR0mqj8WnTEOQw==/2858378388597099017.jpg"
            md.live = 0 // 是否在直播
            md.push = 0 // 直播显示方式
            md.focus = 100 // 关注数
            self.anchorModels.append(md)
        }
        finishedCallback()
        
        NetworkTools.requestData(.get, URLString: "http://qf.56.com/home/v4/moreAnchor.ios", parameters: ["type" : type.type, "index" : index, "size" : 48], finishedCallback: { (result) -> Void in
            
//            guard let resultDict = result as? [String : Any] else { return }
//            guard let messageDict = resultDict["message"] as? [String : Any] else { return }
//            guard let dataArray = messageDict["anchors"] as? [[String : Any]] else { return }
//
//            for (index, dict) in dataArray.enumerated() {
//                let anchor = AnchorModel(dict: dict)
//                anchor.isEvenIndex = index % 2 == 0
//                self.anchorModels.append(anchor)
//            }
//
           
        })
    }
}
