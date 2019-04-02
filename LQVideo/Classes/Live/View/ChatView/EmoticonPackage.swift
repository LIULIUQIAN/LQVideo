//
//  EmoticonPackage.swift
//  LQVideo
//
//  Created by 刘六乾 on 2019/4/2.
//  Copyright © 2019年 LLQ. All rights reserved.
//

import UIKit

class EmoticonPackage {

    lazy var emoticons : [Emoticon] = [Emoticon]()
    
    init(plistName : String) {
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil) else {
            return
        }
        
        guard let emotionArray = NSArray(contentsOfFile: path) as? [String] else {
            return
        }
        
        for str in emotionArray {
            emoticons.append(Emoticon(emoticonName: str))
        }
    }
    
}
