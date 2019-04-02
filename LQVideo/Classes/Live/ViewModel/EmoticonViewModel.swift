//
//  EmoticonViewModel.swift
//  LQVideo
//
//  Created by 刘六乾 on 2019/4/2.
//  Copyright © 2019年 LLQ. All rights reserved.
//

import UIKit

class EmoticonViewModel {
    
    static let shareInstance : EmoticonViewModel = EmoticonViewModel()
    lazy var packages : [EmoticonPackage] = [EmoticonPackage]()
    init() {
        packages.append(EmoticonPackage(plistName: "QHNormalEmotionSort.plist"))
        packages.append(EmoticonPackage(plistName: "QHSohuGifSort.plist"))
    }

}
