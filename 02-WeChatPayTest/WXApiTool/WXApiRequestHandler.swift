//
//  WXApiRequestHandler.swift
//  02-WeChatPayTest
//
//  Created by zhaoyou on 16/8/9.
//  Copyright © 2016年 zhaoyou. All rights reserved.
//

import UIKit

class WXApiRequestHandler: NSObject {

    class func sendText(text: String, scene: WXScene) -> Bool {
        let req = SendMessageToWXReq.requestWithText(text, message: nil, bText: true, scene: scene)
        
        return WXApi.sendReq(req)
    }
    
    class func sendImageData(imageData: NSData, tagName: String, messageExt: String, action: String, thumbImage: UIImage, scene: WXScene) -> Bool {
        let ext = WXImageObject()
        ext.imageData = imageData
        
        let message = WXMediaMessage.messageWithTitle(nil, desctiptions: nil, mediaObject: ext, messageExt: messageExt, action: action, thumbImage: thumbImage, tagName: tagName)
        
        let req = SendMessageToWXReq.requestWithText(nil, message: message, bText: false, scene: scene)
        
        return WXApi.sendReq(req)
    }
    
    class func sendLinkURL(urlString: String, tagName: String, title: String, desctiptions: String, thumbImage: UIImage, scene: WXScene) -> Bool {
        let ext = WXWebpageObject()
        ext.webpageUrl = urlString
        
        let message = WXMediaMessage.messageWithTitle(title, desctiptions: desctiptions, mediaObject: ext, messageExt: nil, action: nil, thumbImage: thumbImage, tagName: tagName)
        
        let req = SendMessageToWXReq.requestWithText(nil, message: message, bText: false, scene: scene)
        
        return WXApi.sendReq(req)
    }
    
    class func sendMusicURL(musicURL: String, dataURL: String, title: String, descriptions: String, thumbImage: UIImage, scene: WXScene) -> Bool {
        let ext = WXMusicObject()
        ext.musicUrl = musicURL
        ext.musicDataUrl = dataURL
        
        let message = WXMediaMessage.messageWithTitle(title, desctiptions: descriptions, mediaObject: ext, messageExt: nil, action: nil, thumbImage: thumbImage, tagName: nil)
        
        let req = SendMessageToWXReq.requestWithText(nil, message: message, bText: false, scene: scene)
        
        return WXApi.sendReq(req)
    }
    
    class func sendVideoURL(videoURL: String, title: String, descriptions: String, thumbImage: UIImage, scene: WXScene) -> Bool {
        let message = WXMediaMessage()
        message.title = title
        message.description = descriptions
        message.setThumbImage(thumbImage)
        
        let ext = WXVideoObject()
        ext.videoUrl = videoURL
        
        message.mediaObject = ext
        
        let req = SendMessageToWXReq.requestWithText(nil, message: message, bText: false, scene: scene)
        
        return WXApi.sendReq(req)
    }
    
    class func sendEmotionData(emotionData: NSData, thumbImage: UIImage, scene: WXScene) -> Bool {
        let message = WXMediaMessage()
        message.setThumbImage(thumbImage)
        
        let ext = WXEmoticonObject()
        ext.emoticonData = emotionData
        
        message.mediaObject = ext
        
        let req = SendMessageToWXReq.requestWithText(nil, message: message, bText: false, scene: scene)
        
        return WXApi.sendReq(req)
    }
    
    class func sendFileData(fileData: NSData, extensions: String, title: String, descriptions: String, thumbImage: UIImage, scene: WXScene) -> Bool {
        let message = WXMediaMessage()
        message.title = title
        message.description = descriptions
        message.setThumbImage(thumbImage)
        
        let ext = WXFileObject()
        ext.fileExtension = "pdf"
        ext.fileData = fileData
        
        message.mediaObject = ext
        
        let req = SendMessageToWXReq.requestWithText(nil, message: message, bText: false, scene: scene)
        
        return WXApi.sendReq(req)
    }
    
    class func sendAppContentData(data: NSData, info: String, url: String, title: String, descriptions: String, messageExt: String, action: String, thumbImage: UIImage, scene: WXScene) -> Bool {
        let ext = WXAppExtendObject()
        ext.extInfo = info
        ext.url = url
        ext.fileData = data
        
        let message = WXMediaMessage.messageWithTitle(title, desctiptions: descriptions, mediaObject: ext, messageExt: messageExt, action: action, thumbImage: thumbImage, tagName: nil)
        
        let req = SendMessageToWXReq.requestWithText(nil, message: message, bText: false, scene: scene)
        
        return WXApi.sendReq(req)
    }
    
    class func addCardsToCardPackage(cardItems: [AnyObject]) -> Bool {
        let req = AddCardToWXCardPackageReq()
        req.cardAry = cardItems
        return WXApi.sendReq(req)
    }
    
    class func sendAuthRequestScope(scope: String, state: String, openID: String, viewController: UIViewController) -> Bool {
        let req = SendAuthReq()
        req.scope = scope
        req.state = state
        req.openID = openID
        
        return WXApi.sendAuthReq(req, viewController: viewController, delegate: WXApiManager.shareInstance())
    }
    
    class func jumpToBizWebviewWithAppID(appID: String, descriptions: String, thosrname: String, extMsg: String) -> Bool {
        WXApi.registerApp(appID, withDescription: descriptions)
        let req = JumpToBizWebviewReq()
        req.tousrname = thosrname
        req.extMsg = extMsg
        req.webType = Int32(WXMPWebviewType_Ad.rawValue)
        return WXApi.sendReq(req)
    }
    
    class func jumpToBizPay() -> String {
        //============================================================
        // V3&V4支付流程实现
        // 注意:参数配置请查看服务器端Demo
        // 更新时间：2015年11月20日
        //============================================================
        let urlString = "http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios"
        
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        let response = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        if response != nil {
            var dict: [String: AnyObject]?
            dict = try! NSJSONSerialization.JSONObjectWithData(response!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
            
            print("\(response),\(urlString),\(dict)")
//            print("微信支付返回结果---\(dict)")
            if dict != nil {
//                let retcode = dict!["retcode"]
//                if retcode?.intValue == 0 {
                    let stamp = dict!["timestamp"]
                    
                    // 调用微信支付
                    let req = PayReq()
                    req.partnerId = dict!["partnerid"] as! String
                    req.prepayId = dict!["prepayid"] as! String
                    req.nonceStr = dict!["noncestr"] as! String
                    req.timeStamp = UInt32((stamp?.intValue)!)
                    req.package = dict!["package"] as! String
                    req.sign = dict!["sign"] as! String
                    WXApi.sendReq(req)
                    
                    // 日志输出
                    print("appid=\(dict!["appid"])\npartid=\(req.partnerId)\nprepayid=\(req.partnerId)\nnoncestr=\(req.nonceStr)\ntimestamp=\(req.timeStamp)\npackage=\(req.package)\nsign=\(req.sign)")
                    return ""
//                } else {
//                    return dict!["retmsg"] as? String ?? "解析成字典失败"
//                }
                
            } else {
                return "服务器返回错误，未获取到json对象"
            }
            
        } else {
            return "服务器返回错误"
        }
        
    }
    
}

// MARK: - Helper
extension SendMessageToWXReq {
    class func requestWithText(text: String?, message: WXMediaMessage?, bText: Bool, scene: WXScene) -> SendMessageToWXReq {
        let req = SendMessageToWXReq()
        req.bText = bText
        req.scene = Int32(scene.rawValue)
        if bText {
            req.text = text
        } else {
            req.message = message
        }
        return req
    }
}

extension WXMediaMessage {
    class func messageWithTitle(title: String?, desctiptions: String?, mediaObject: AnyObject, messageExt: String?, action: String?, thumbImage: UIImage, tagName: String?) -> WXMediaMessage {
        let message = WXMediaMessage()
        message.title = title
        message.description = desctiptions
        message.mediaObject = mediaObject
        message.messageExt = messageExt
        message.messageAction = action
        message.mediaTagName = tagName
        message.setThumbImage(thumbImage)
        return message
    }
}


