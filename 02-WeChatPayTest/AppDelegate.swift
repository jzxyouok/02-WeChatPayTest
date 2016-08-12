//
//  AppDelegate.swift
//  02-WeChatPayTest
//
//  Created by zhaoyou on 16/8/2.
//  Copyright © 2016年 zhaoyou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - LifeCycle
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let vc = ViewController()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        
        // 注册微信appkey，注意和info中的urlscheme一致
        WXApi.registerApp("wxb4ba3c02aa476ea1", withDescription: "WeChatPayDemo")
        
        window?.makeKeyAndVisible()
        return true
    }

    // MARK: - 处理跳转回来的结果，如微信分享、微信支付、支付宝支付等等
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: WXApiManager.shareInstance())
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WXApi.handleOpenURL(url, delegate: WXApiManager.shareInstance())
    }


}

