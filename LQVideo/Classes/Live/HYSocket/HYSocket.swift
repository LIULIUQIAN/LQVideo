//
//  HYSocket.swift
//  User
//
//  Created by Liuliuqian on 2019/4/4.
//  Copyright © 2019年 LLQ. All rights reserved.
//

import UIKit
import SwiftSocket

protocol HYSocketDelegate : class {
    func socket(_ socket : HYSocket, joinRoom user : UserInfo)
    func socket(_ socket : HYSocket, leaveRoom user : UserInfo)
    func socket(_ socket : HYSocket, chatMsg : ChatMessage)
    func socket(_ socket : HYSocket, giftMsg : GiftMessage)
}


class HYSocket: NSObject {
    
    weak var delegate : HYSocketDelegate?
    fileprivate var tcpClient : TCPClient
    var timer: Timer?
    fileprivate var userInfo : UserInfo = {
        var userInfo = UserInfo()
        userInfo.name = "why88"
        userInfo.level = 20
        return userInfo
    }()
    
    init(addr : String, port : Int) {
        tcpClient = TCPClient(address: addr, port: Int32(port))
    }

}

extension HYSocket {
    func connectServer() -> Bool {

        switch tcpClient.connect(timeout: 5) {
            case .success:
                return true
            default:
                return false
        }
    }
    

    @objc func updataSecond() {
        guard let lMsg = self.tcpClient.read(4) else {
            return
        }
        // 1.读取长度的data
        let headData = NSData(bytes: lMsg, length: 4)//Data(bytes: lMsg, count: 4)
        var length : Byte = 0
        headData.getBytes(&length, length: 4)


        // 2.读取类型
        guard let typeMsg = self.tcpClient.read(2) else {
            return
        }
        let typeData = NSData(bytes: typeMsg, length: 2)//Data(bytes: typeMsg, count: 2)
        var type : Byte = 0
        typeData.getBytes(&type, length: 2)
        print(type)

        // 2.根据长度, 读取真实消息
        guard let msg = self.tcpClient.read(Int(length)) else {
            return
        }
        let data = NSData(bytes: msg, length: Int(length))

        // 3.处理消息
        DispatchQueue.main.async {
            self.handleMsg(type: Int(type), data: data)
            print("客户端接收到一个消息")
            let msgStr = String(data: data as Data, encoding: String.Encoding.utf8) ?? "消息有问题"
            print(msgStr)
        }
    }

    
    func startReadMsg() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updataSecond), userInfo: nil, repeats: true)

        timer!.fire()
    }
    
    fileprivate func handleMsg(type : Int, data : NSData) {
        switch type {
        case 0, 1:
            let user = try! UserInfo(jsonUTF8Data: data as Data)
            type == 0 ? delegate?.socket(self, joinRoom: user) : delegate?.socket(self, leaveRoom: user)
        case 2:
            let chatMsg = try! ChatMessage(jsonUTF8Data: data as Data)
            delegate?.socket(self, chatMsg: chatMsg)
        case 3:
            let giftMsg = try! GiftMessage(jsonUTF8Data: data as Data)
            delegate?.socket(self, giftMsg: giftMsg)
        default:
            print("未知类型")
        }
    }
    
}

extension HYSocket {
    func sendJoinRoom() {
        // 1.获取消息的长度
        let msgData = try! userInfo.jsonUTF8Data()
        
        // 2.发送消息
        sendMsg(data: msgData, type: 0)
    }
    
    func sendLeaveRoom() {
        // 1.获取消息的长度
        let msgData = try! userInfo.jsonUTF8Data()
        
        // 2.发送消息
        sendMsg(data: msgData, type: 1)
    }
    
    func sendTextMsg(message : String) {
        
        // 1.创建TextMessage类型
        var chatMsg = ChatMessage()
        chatMsg.user = userInfo
        chatMsg.text = message

        // 2.获取对应的data
        let chatData = try! chatMsg.jsonUTF8Data()

        // 3.发送消息到服务器
        sendMsg(data: chatData, type: 2)
    }
    
    func sendGiftMsg(giftName : String, giftURL : String, giftCount : String) {
        // 1.创建GiftMessage
        var giftMsg = GiftMessage()
        giftMsg.user = userInfo
        giftMsg.giftname = giftName
        giftMsg.giftURL = giftURL
        giftMsg.giftCount = giftCount
        
        // 2.获取对应的data
        let giftData = try! giftMsg.jsonUTF8Data()
        
        // 3.发送礼物消息
        sendMsg(data: giftData, type: 3)
    }
    
    func sendHeartBeat() {
        // 1.获取心跳包中的数据
        let heartString = "I am is heart beat;"
        let heartData = heartString.data(using: .utf8)!
        
        // 2.发送数据
        sendMsg(data: heartData, type: 100)
    }
    
    func sendMsg(data : Data, type : Int) {
        // 1.将消息长度, 写入到data
        var length = data.count
        let headerData = Data(bytes: &length, count: 4)
        
        // 2.消息类型
        var tempType = type
        let typeData = Data(bytes: &tempType, count: 2)
        
        // 3.发送消息
        let totalData = headerData + typeData + data

       _ = tcpClient.send(data: totalData)
        
        let msgStr = String(data: totalData, encoding: String.Encoding.utf8) ?? "消息有问题"
         print("发送消息="+msgStr)
        
    }
}
