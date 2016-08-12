//
//  WXApiManager.swift
//  02-WeChatPayTest
//
//  Created by zds on 16/8/3.
//  Copyright © 2016年 zhaoyou. All rights reserved.
//

import UIKit
//import 

@objc protocol WXApiManagerDelegate: NSObjectProtocol {
    optional func managerDidRecvGetMessageReq(request: GetMessageFromWXReq)
    optional func managerDidRecvShowMessageReq(request: ShowMessageFromWXReq)
    optional func managerDidRecvLaunchFromWXReq(request: LaunchFromWXReq)
    optional func managerDidRecvMessageResponse(response: SendMessageToWXResp)
    optional func managerDidRecvAuthResponse(response: SendAuthResp)
    optional func managerDidRecvAddCardResponse(response: AddCardToWXCardPackageResp)
}

class WXApiManager: NSObject, WXApiDelegate {

    weak var myDelegate: WXApiManagerDelegate?
    
    //MARK: - 单利
    static let tools:WXApiManager = {
        let tool = WXApiManager()
        
        return tool
    }()
    /// 获取单例的方法
    class func shareInstance() -> WXApiManager {
        return tools
    }
    
    //MARK: - WXApiDelegate
    /// 如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
    func onResp(resp: BaseResp!) {
        if resp.isKindOfClass(SendMessageToWXResp) {
            if myDelegate != nil && myDelegate!.respondsToSelector(#selector(WXApiManagerDelegate.managerDidRecvMessageResponse(_:))) {
                let messageResp = resp as! SendMessageToWXResp
                myDelegate?.managerDidRecvMessageResponse?(messageResp)
            }
        } else if resp.isKindOfClass(SendAuthResp) {
            if myDelegate != nil && myDelegate!.respondsToSelector(#selector(WXApiManagerDelegate.managerDidRecvAuthResponse(_:))) {
                let authResp = resp as! SendAuthResp
                myDelegate?.managerDidRecvAuthResponse?(authResp)
            }
        } else if resp.isKindOfClass(AddCardToWXCardPackageResp) {
            if myDelegate != nil && myDelegate!.respondsToSelector(#selector(WXApiManagerDelegate.managerDidRecvAddCardResponse(_:))) {
                let addCardResp = resp as! AddCardToWXCardPackageResp
                myDelegate?.managerDidRecvAddCardResponse?(addCardResp)
            }
        } else if resp.isKindOfClass(PayResp) {
            // 支付返回结果，实际支付结果需要去微信服务器端查询
            var strMsg = "支付结果"
            
            switch resp.errCode {
            case WXSuccess.rawValue:
                strMsg = "支付结果：成功！"
                print("\(strMsg)支付成功－PaySuccess，retcode = \(resp.errCode)")
            default:
                strMsg = "支付结果：失败！retcode = \(resp.errCode), retstr = \(resp.errStr)"
                print("\(strMsg)错误，retcode = \(resp.errCode), retstr = \(resp.errStr)")
            }
            
        }
    }
    
    /// onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    func onReq(req: BaseReq!) {
        if req.isKindOfClass(GetMessageFromWXReq) {
            if myDelegate != nil && myDelegate!.respondsToSelector(#selector(WXApiManagerDelegate.managerDidRecvGetMessageReq(_:))) {
                let getMessageReq = req as! GetMessageFromWXReq
                myDelegate?.managerDidRecvGetMessageReq?(getMessageReq)
            } else if req.isKindOfClass(ShowMessageFromWXReq) {
                if myDelegate != nil && myDelegate!.respondsToSelector(#selector(WXApiManagerDelegate.managerDidRecvShowMessageReq(_:))) {
                    let showMessageReq = req as! ShowMessageFromWXReq
                    myDelegate?.managerDidRecvShowMessageReq?(showMessageReq)
                }
            } else if req.isKindOfClass(LaunchFromWXReq) {
                if myDelegate != nil && myDelegate!.respondsToSelector(#selector(WXApiManagerDelegate.managerDidRecvLaunchFromWXReq(_:))) {
                    let launchReq = req as! LaunchFromWXReq
                    myDelegate?.managerDidRecvLaunchFromWXReq?(launchReq)
                }
            }
        }
    }
    
}
