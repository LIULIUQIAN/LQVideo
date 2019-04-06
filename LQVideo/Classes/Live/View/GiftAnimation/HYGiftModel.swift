//
//  HYGiftModel.swift
//  LQVideo
//
//  Created by Liuliuqian on 2019/4/6.
//  Copyright © 2019年 LLQ. All rights reserved.
//

import UIKit

class HYGiftModel: NSObject {
    
    var senderName : String = ""
    var senderURL : String = ""
    var giftName : String = ""
    var giftURL : String = ""
    
    init(senderName : String, senderURL : String, giftName : String, giftURL : String) {
        self.senderName = senderName
        self.senderURL = senderURL
        self.giftName = giftName
        self.giftURL = giftURL
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        
        guard  let object = object as? HYGiftModel else{
            return false
        }
        
        guard object.giftName == giftName && object.senderName == senderName else {
            return false
        }
        return true
    }

}
