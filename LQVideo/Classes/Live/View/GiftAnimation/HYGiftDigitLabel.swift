//
//  HYGiftDigitLabel.swift
//  LQVideo
//
//  Created by Liuliuqian on 2019/4/6.
//  Copyright © 2019年 LLQ. All rights reserved.
//

import UIKit

class HYGiftDigitLabel: UILabel {

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        context?.setLineWidth(5)
        context?.setLineJoin(.round)
        context?.setTextDrawingMode(.stroke)
        textColor = UIColor.orange
        super.drawText(in: rect)
        
        context?.setTextDrawingMode(.fill)
        textColor = UIColor.white
        super.drawText(in: rect)
        
    }
    
    func showDigitAnimation(_ complection : @escaping () -> ())  {
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
        }, completion: {isFinished in
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [], animations: {
                self.transform = CGAffineTransform.identity
            }, completion: { (isFinished) in
                complection()
            })
        })
    }
}
