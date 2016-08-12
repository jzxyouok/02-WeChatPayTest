//
//  ViewController.swift
//  02-WeChatPayTest
//
//  Created by zhaoyou on 16/8/2.
//  Copyright © 2016年 zhaoyou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        setupUI()
    }
    
    // MARK: - Initialization
    /**
     初始化UI
     */
    private func setupUI() {
        // 属性设置
        navigationItem.title = "微信支付测试demo"
        WXApiManager.shareInstance().myDelegate = self
        
        // 添加控件
        let titles = ["发送Text消息给微信", "发送Photo消息给微信", "发送Link消息给微信", "发送Music消息给微信", "发送Video消息给微信", "发送App消息给微信", "发送非gif表情给微信" ,"发送gif表情给微信", "微信授权登录", "发送文件消息给微信", "添加单张卡券至卡包", "发起微信支付"]
        
        for i in 0..<titles.count {
            let btn = UIButton()
            btn.setTitle(titles[i], forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(self.payBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            btn.backgroundColor = UIColor.brownColor()
            
            view.addSubview(btn)
            btn.frame = CGRect(x: 10, y: 70 + i*45, width: 200, height: 35)
        }
        
        // 布局控件
    }
    
    // MARK: - Private Method
    
    // MARK: - Action
    /// 支付按钮点击
    func payBtnClick(sender: UIButton) {
        switch sender.tag {
        case 100:
            print(sender.tag)
        case 101:
            print(sender.tag)
        case 102:
            print(sender.tag)
            WXApiRequestHandler.sendLinkURL("https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx860590ba932652a1&redirect_uri=http%3A%2F%2Fearth.51zhaoyou.com%2Flinda%2FActivity%2Fcut_activity%3Fuser_id%3D15158099791&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect", tagName: "测试tagName", title: "砍刀活动", desctiptions: "无朋友不砍刀，是兄弟就砍我一刀！", thumbImage: UIImage(named: "001")!, scene: WXSceneSession)
        case 103:
            print(sender.tag)
        case 104:
            print(sender.tag)
        case 105:
            print(sender.tag)
        case 106:
            print(sender.tag)
        case 107:
            print(sender.tag)
        case 108:
            print(sender.tag)
        case 109:
            print(sender.tag)
        case 110:
            print(sender.tag)
        case 111:
            print(sender.tag)
            let res = WXApiRequestHandler.jumpToBizPay()
            print(res)
            
        default:
            break
        }
        
    }
    
    // MARK: - Lazy

}
// MARK: - WXApiManagerDelegate
extension ViewController: WXApiManagerDelegate {
    func managerDidRecvGetMessageReq(request: GetMessageFromWXReq) {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        let strTitle = "微信请求APP提供内容"
        let strMsg = "apenID:\(request.openID)"
        print("\(#function)---\(strTitle)---\(strMsg)")
    }
    
    func managerDidRecvShowMessageReq(request: ShowMessageFromWXReq) {
        let msg = request.message
        
        // 显示微信传过来的内容
        let obj = msg.mediaObject
        
        let strTitle = "微信请求APP显示内容"
        let strMsg = "openID: \(request.openID), 标题：\(msg.title) \n内容：\(msg.description) \n附带信息：\(obj.extInfo) \n缩略图:\(msg.thumbData.length) bytes\n附加消息:\(msg.messageExt)\n"
        print("\(#function)---\(strTitle)---\(strMsg)")
        
    }
    
    func managerDidRecvLaunchFromWXReq(request: LaunchFromWXReq) {
        let msg = request.message
        
        // 从微信启动APP
        let strTitle = "从微信启动"
        let strMsg = "openID: \(request.openID), messageExt:\(msg.messageExt)"
        print("\(#function)---\(strTitle)---\(strMsg)")
    }
    
    func managerDidRecvMessageResponse(response: SendMessageToWXResp) {
        let strTitle = "发送媒体消息结果"
        let strMsg = "errcode:\(response.errCode)"
        print("\(#function)---\(strTitle)---\(strMsg)")
    }
    
    func managerDidRecvAddCardResponse(response: AddCardToWXCardPackageResp) {
        var cardStr = ""
        for cardItem: WXCardItem in response.cardAry as! [WXCardItem] {
            cardStr = "cardid:\(cardItem.cardId) cardext:\(cardItem.extMsg) cardstate:\(cardItem.cardState)\n"
        }
        
        print("\(#function)---\(cardStr)")
    }
    
    func managerDidRecvAuthResponse(response: SendAuthResp) {
        let strTitle = "Auth结果"
        let strMsg = "code:\(response.code),state:\(response.state),errcode:\(response.errCode)"
        print("\(#function)---\(strTitle)---\(strMsg)")
    }
}

