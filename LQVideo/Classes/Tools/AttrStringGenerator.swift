//
//  AttrStringGenerator.swift
//  LQVideo
//
//  Created by Liuliuqian on 2019/4/5.
//  Copyright © 2019年 LLQ. All rights reserved.
//

import UIKit
import Kingfisher

class AttrStringGenerator {

    
}
extension AttrStringGenerator{
    
    class func generateJoinLeaveRoom(_ username : String, _ isJoin : Bool) -> NSAttributedString{
        
        let roomString = "\(username) " + (isJoin ? "进入房间" : "离开房间")
        let roomMAttr = NSMutableAttributedString(string: roomString)
        
        roomMAttr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], range: NSRange(location: 0, length: username.count))
        return roomMAttr
    }
    
    class func generateTextMessage(_ username : String, _ message : String) -> NSAttributedString {
        let chatMessage = "\(username): \(message)"
        let chatMsgMAttr = NSMutableAttributedString(string: chatMessage)
        chatMsgMAttr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], range: NSRange(location: 0, length: username.count))
        
        let pattern = "\\[.*?\\]"

        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else{
            return chatMsgMAttr
        }

        let results = regex.matches(in: chatMessage, options: [], range: NSRange(location: 0, length: chatMessage.count))
        for i in (0..<results.count).reversed() {
            let result = results[i]
            let emoticonName = (chatMessage as NSString).substring(with: result.range)

            guard let image = UIImage(named: emoticonName) else{
                continue
            }

            let attachment = NSTextAttachment()
            attachment.image = image
            let font = UIFont.systemFont(ofSize: 15)
            attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
            let imageAttrStr = NSAttributedString(attachment: attachment)
            chatMsgMAttr.replaceCharacters(in: result.range, with: imageAttrStr)

        }
    
        return chatMsgMAttr;
    }

    class func generateGiftMessage(_ giftname : String, _ giftURL : String, _ username : String) -> NSAttributedString {
        
        let sendGiftMsg = "\(username) 赠送 \(giftname) "
        let sendGiftMAttrMsg = NSMutableAttributedString(string: sendGiftMsg)
        sendGiftMAttrMsg.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], range: NSRange(location: 0, length: username.count))
        
        let range = (sendGiftMsg as NSString).range(of: giftname)
        sendGiftMAttrMsg.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.brown], range: range)
        
        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: giftURL) else {
            return sendGiftMAttrMsg
        }
        
        let attacment = NSTextAttachment()
        attacment.image = image
        let font = UIFont.systemFont(ofSize: 15)
        attacment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
        let imageAttrStr = NSAttributedString(attachment: attacment)
        
        // 6.将imageAttrStr拼接到最后
        sendGiftMAttrMsg.append(imageAttrStr)
        
        return sendGiftMAttrMsg
    }
}

