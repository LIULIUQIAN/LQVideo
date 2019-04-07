//
//  LiveViewController.swift
//  XMGTV
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit
import Kingfisher

private let kChatToolsViewHeight : CGFloat = 44
private let kGiftlistViewHeight : CGFloat = kScreenH * 0.5
private let kChatContentViewHeight : CGFloat = 200

class RoomViewController: UIViewController,Emitterable {
    
    // MARK: 控件属性
    @IBOutlet weak var bgImageView: UIImageView!
    
    fileprivate lazy var chatToolsView : ChatToolsView = ChatToolsView.loadFromNib()
    fileprivate lazy var giftListView : GiftListView = GiftListView.loadFromNib()
    fileprivate lazy var chatContentView : ChatContentView = ChatContentView.loadFromNib()
    fileprivate lazy var giftContainerView : HYGiftContainerView = HYGiftContainerView(frame: CGRect(x: 0, y: 100, width: 250, height: 90))
    fileprivate lazy var gifView : AnimatedImageView = AnimatedImageView()
    fileprivate lazy var socket : HYSocket = HYSocket(addr: "192.168.31.168", port: 8080)
    fileprivate var heartBeatTimer : Timer?
    
    // MARK: 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // 3.连接聊天服务器
        if socket.connectServer() {
            print("连接成功")
            socket.startReadMsg()
            addHeartBeatTimer()
            socket.sendJoinRoom()
            socket.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        socket.sendLeaveRoom()
    }
    
    deinit {
        heartBeatTimer?.invalidate()
        heartBeatTimer = nil
    }
}


// MARK:- 设置UI界面内容
extension RoomViewController {
    fileprivate func setupUI() {
        setupBlurView()
        setupBottomView()
        setupGiftView()
    }
    
    fileprivate func setupBlurView() {
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
    
    fileprivate func setupBottomView() {
        // 0.设置Chat内容的View
        chatContentView.frame = CGRect(x: 0, y: view.bounds.height - 44 - kChatContentViewHeight, width: view.bounds.width, height: kChatContentViewHeight)
        chatContentView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        view.addSubview(chatContentView)
        
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        chatToolsView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatToolsView.delegate = self
        view.addSubview(chatToolsView)
        
        // 2.设置giftListView
        giftListView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftlistViewHeight)
        giftListView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(giftListView)
        giftListView.delegate = self
    }
    
    fileprivate func setupGiftView(){
        view.addSubview(giftContainerView)
        
        gifView.contentMode = .scaleAspectFit
        gifView.frame = CGRect(x: (kScreenW - 100)/2, y: 200, width: 100, height: 100)
        gifView.delegate = self
        gifView.repeatCount = .once
        gifView.backgroundColor = UIColor.clear
        view.addSubview(gifView)
    }
}


// MARK:- 事件监听
extension RoomViewController {
    @IBAction func exitBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatToolsView.inputTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.giftListView.frame.origin.y = kScreenH
        })
    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            chatToolsView.inputTextField.becomeFirstResponder()
        case 1:
            print("点击了分享")
        case 2:
            UIView.animate(withDuration: 0.25, animations: {
                self.giftListView.frame.origin.y = kScreenH - kGiftlistViewHeight
            })
        case 3:
            print("点击了更多")
        case 4:
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
            sender.isSelected ? startEmittering(point) : stopEmittering()
        default:
            fatalError("未处理按钮")
        }
    }
}

// MARK:- 监听键盘的弹出
extension RoomViewController {
    @objc fileprivate func keyboardWillChangeFrame(_ note : Notification) {
        let duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToolsViewHeight
        
        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: 7)!)
            let endY = inputViewY == (kScreenH - kChatToolsViewHeight) ? kScreenH : inputViewY
            self.chatToolsView.frame.origin.y = endY
            
            let contentEndY = inputViewY == (kScreenH - kChatToolsViewHeight) ? (kScreenH - kChatContentViewHeight - 44) : endY - kChatContentViewHeight
            self.chatContentView.frame.origin.y = contentEndY
        })
    }
}



// MARK:- 监听用户输入的内容
extension RoomViewController : ChatToolsViewDelegate, GiftListViewDelegate {
    func chatToolsView(toolView: ChatToolsView, message: String) {
        socket.sendTextMsg(message: message)
    }
    
    func giftListView(giftView: GiftListView, giftModel: GiftModel) {
        socket.sendGiftMsg(giftName: giftModel.subject, giftURL: giftModel.img2, giftCount: "1")
        
        //TODO -本地测试效果使用
        let gift1 = HYGiftModel(senderName: "都教授", senderURL: "icon2", giftName: giftModel.subject, giftURL: giftModel.img2)
        giftContainerView.showGiftModel(gift1)
        
        guard let url = URL(string: giftModel.gUrl) else {
            return
        }
        let animatedImageViewResource = ImageResource(downloadURL: url, cacheKey: "\(url)-animated_imageview")
        gifView.kf.setImage(with: animatedImageViewResource)
        gifView.isHidden = false
    }
}


// MARK:- 给服务器发送即时消息
extension RoomViewController {
    
    fileprivate func addHeartBeatTimer() {
        heartBeatTimer = Timer(fireAt: Date(), interval: 120, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
        RunLoop.main.add(heartBeatTimer!, forMode: .common)
    }
    
    @objc fileprivate func sendHeartBeat() {
        socket.sendHeartBeat()
    }
}


// MARK:- 接受聊天服务器返回的消息
extension RoomViewController : HYSocketDelegate {
    func socket(_ socket: HYSocket, joinRoom user: UserInfo) {
        chatContentView.insertMsg(AttrStringGenerator.generateJoinLeaveRoom(user.name, true))
    }
    
    func socket(_ socket: HYSocket, leaveRoom user: UserInfo) {
        chatContentView.insertMsg(AttrStringGenerator.generateJoinLeaveRoom(user.name, false))
    }
    
    func socket(_ socket: HYSocket, chatMsg: ChatMessage) {
        // 1.通过富文本生成器, 生产需要的富文本
        let chatMsgMAttr = AttrStringGenerator.generateTextMessage(chatMsg.user.name, chatMsg.text)
        // 2.将文本的属性字符串插入到内容View中
        chatContentView.insertMsg(chatMsgMAttr)
    }
    
    func socket(_ socket: HYSocket, giftMsg: GiftMessage) {
        // 1.通过富文本生成器, 生产需要的富文本
        let giftMsgAttr = AttrStringGenerator.generateGiftMessage(giftMsg.giftname, giftMsg.giftURL, giftMsg.user.name)
        // 2.将文本的属性字符串插入到内容View中
        chatContentView.insertMsg(giftMsgAttr)
        
        let gift1 = HYGiftModel(senderName: giftMsg.user.name, senderURL: "icon1", giftName: giftMsg.giftname, giftURL: giftMsg.giftURL)
        giftContainerView.showGiftModel(gift1)
        
        let url = URL(string: "https://raw.githubusercontent.com/onevcat/Kingfisher-TestImages/master/DemoAppImage/GIF/3.gif")!
        
        let animatedImageViewResource = ImageResource(downloadURL: url, cacheKey: "\(url)-animated_imageview")
        gifView.kf.setImage(with: animatedImageViewResource)
        gifView.isHidden = false
    }
}

// MARK:- 接受聊天服务器返回的消息
extension RoomViewController : AnimatedImageViewDelegate{
    
    func animatedImageViewDidFinishAnimating(_ imageView: AnimatedImageView){
        gifView.isHidden = true
    }
    
}

