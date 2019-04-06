//
//  HYGiftChannelView.swift
//  04-礼物动画展示
//
//  Created by 小码哥 on 2016/12/17.
//  Copyright © 2016年 xmg. All rights reserved.
//

import UIKit

enum HYGiftChannelState {
    case idle
    case animating
    case willEnd
    case endAnimating
}

class HYGiftChannelView: UIView {
    
    // MARK: 控件属性
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var giftDescLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var digitLabel: HYGiftDigitLabel!
    
    //缓存数量 相同礼物使用同一个ChannelView 数量加一
    fileprivate var cacheNumber : Int = 0
    //礼物的数量
    fileprivate var currentNumber : Int = 0
    var state : HYGiftChannelState = .idle
    
    var complectionCallback : ((HYGiftChannelView) -> Void)?
    
    var giftModel : HYGiftModel? {
        didSet {
            // 1.对模型进行校验
            guard let giftModel = giftModel else {
                return
            }
            
            // 2.给控件设置信息
            iconImageView.image = UIImage(named: giftModel.senderURL)
            senderLabel.text = giftModel.senderName
            giftDescLabel.text = "送出礼物：【\(giftModel.giftName)】"
            giftImageView.setImage(giftModel.giftURL, "prop_g")
            
            // 3.将ChanelView弹出
            state = .animating
            performAnimation()
        }
    }
}


// MARK:- 设置UI界面
extension HYGiftChannelView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.layer.cornerRadius = frame.height * 0.5
        iconImageView.layer.cornerRadius = frame.height * 0.5
        bgView.layer.masksToBounds = true
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.green.cgColor
    }
}


// MARK:- 对外提供的函数
extension HYGiftChannelView {
    func addOnceToCache() {
        
        if state == .willEnd {
            performDigitAnimation()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        } else {
            cacheNumber += 1
        }
        
    }
    
    class func loadFromNib() -> HYGiftChannelView {
        return Bundle.main.loadNibNamed("HYGiftChannelView", owner: nil, options: nil)?.first as! HYGiftChannelView
    }
}


// MARK:- 执行动画代码
extension HYGiftChannelView {
    fileprivate func performAnimation() {
        digitLabel.alpha = 1.0
        digitLabel.text = " x1 "
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.frame.origin.x = 0
        }, completion: { isFinished in
            self.performDigitAnimation()
        })
    }
    
    fileprivate func performDigitAnimation() {
        currentNumber += 1
        digitLabel.text = " x\(currentNumber) "
        digitLabel.showDigitAnimation {
            
            if self.cacheNumber > 0 {
                self.cacheNumber -= 1
                self.performDigitAnimation()
            } else {
                self.state = .willEnd
                self.perform(#selector(self.performEndAnimation), with: nil, afterDelay: 3.0)
            }
            
        }
    }
    
    @objc fileprivate func performEndAnimation() {
        
        state = .endAnimating
        
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.x = UIScreen.main.bounds.width
            self.alpha = 0.0
        }, completion: { isFinished in
            self.currentNumber = 0
            self.cacheNumber = 0
            self.giftModel = nil
            self.frame.origin.x = -self.frame.width
            self.state = .idle
            self.digitLabel.alpha = 0.0
            
            if let complectionCallback = self.complectionCallback {
                complectionCallback(self)
            }
        })
    }
}
