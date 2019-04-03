//
//  GiftPackage.swift
//  LQVideo
//
//  Created by 刘六乾 on 2019/4/3.
//  Copyright © 2019年 LLQ. All rights reserved.
//

import UIKit

class GiftPackage: BaseModel {

   @objc var t : Int = 0
   @objc var title : String = ""
   @objc var list : [GiftModel] = [GiftModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list" {
            if let listArray = value as? [[String : Any]] {
                for listDict in listArray {
                    list.append(GiftModel(dict: listDict))
                }
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
}
