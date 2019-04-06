//
//  HYGiftContainerView.swift
//  LQVideo
//
//  Created by Liuliuqian on 2019/4/6.
//  Copyright © 2019年 LLQ. All rights reserved.
//

import UIKit

private let kChannelCount = 2
private let kChannelViewH : CGFloat = 40
private let kChannelMargin : CGFloat = 10

class HYGiftContainerView: UIView {

    fileprivate lazy var channelViews: [HYGiftChannelView] = [HYGiftChannelView]()
    fileprivate lazy var cacheGiftModels: [HYGiftModel] = [HYGiftModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension HYGiftContainerView {
    
    fileprivate func setupUI() {
        
        for i in 0..<kChannelCount{
            let y : CGFloat = (kChannelViewH + kChannelMargin) * CGFloat(i)
            
            let channelView = HYGiftChannelView.loadFromNib()
            channelView.frame = CGRect(x: 0, y: y, width: frame.width, height: kChannelViewH)
            channelView.alpha = 0.0
            addSubview(channelView)
            channelViews.append(channelView)
            
            channelView.complectionCallback = { channelView in

                guard self.cacheGiftModels.count != 0 else{
                    return
                }
                
                let firstGiftModel = self.cacheGiftModels.first!
                self.cacheGiftModels.removeFirst()
                channelView.giftModel = firstGiftModel
                
                for i in (0..<self.cacheGiftModels.count).reversed(){
                    let gifModel = self.cacheGiftModels[i]
                    if gifModel.isEqual(firstGiftModel) {
                        channelView.addOnceToCache()
                        self.cacheGiftModels.remove(at: i)
                    }
                }
                
            }
        }
    }
}

extension HYGiftContainerView {
    func showGiftModel(_ giftModel : HYGiftModel) {
        
        if let channelView = checkUsingChanelView(giftModel) {
            channelView.addOnceToCache()
            return
        }
        
        if let channelView = checkIdleChannelView() {
            channelView.giftModel = giftModel
            return
        }
        
        cacheGiftModels.append(giftModel)
    }
    
    private func checkUsingChanelView(_ giftModel : HYGiftModel) -> HYGiftChannelView? {
        
        for channelView in channelViews {
            if giftModel.isEqual(channelView.giftModel) && channelView.state != .endAnimating {
                return channelView
            }
        }
        return nil
    }
    
    private func checkIdleChannelView() -> HYGiftChannelView? {
        for channelView in channelViews {
            
            if channelView.state == .idle{
                return channelView
            }
        }
        return nil
    }
}
