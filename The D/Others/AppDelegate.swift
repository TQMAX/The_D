//
//  AppDelegate.swift
//  The D
//
//  Created by FangRongJie on 2018/8/7.
//  Copyright © 2018年 TQMAX-Lemon. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CAAnimationDelegate {

    var window: UIWindow?
    var mask: CALayer?
    var imageView: UIImageView?
    
    lazy var reachability: NetworkReachabilityManager? = {
        return NetworkReachabilityManager(host: "https://shuapi.jiaston.com")
    }()

    var orientation: UIInterfaceOrientationMask = .portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configBase()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor(red:0.117, green:0.631, blue:0.949, alpha:1)
        window?.rootViewController = UTabBarController()
        window?.makeKeyAndVisible()
        //MARK: 修正齐刘海
        //        UHairPowder.instance.spread()
        
        
        let imageView = UIImageView(frame: window!.frame)
        imageView.image = UIImage(named: "op-logo")
        imageView.contentMode = .center
//        imageView.backgroundColor = UIColor(red:0.117, green:0.631, blue:0.949, alpha:1)
        window?.addSubview(imageView)
        
        self.mask = CALayer()
        self.mask!.contents = UIImage(named: "op-logo")?.cgImage
        self.mask!.contentsGravity = CALayerContentsGravity.resizeAspect
        self.mask!.bounds = CGRect(x: 0, y: 0, width: 100, height: 81)
        self.mask!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mask!.position = CGPoint(x: imageView.frame.size.width / 2, y: imageView.frame.size.height / 2)
//        imageView.layer.mask = mask
        self.imageView = imageView
        self.imageView?.layer.mask = mask
        
        animateMask()
        
//        self.window!.backgroundColor = UIColor(red:0.117, green:0.631, blue:0.949, alpha:1)
//        self.window!.makeKeyAndVisible()
//        UIApplication.sharedApplication.statusBarHidden = true

        return true
    }
    
    func configBase() {
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        let defaults = UserDefaults.standard
        if defaults.value(forKey: String.sexTypeKey) == nil {
            defaults.set(1, forKey: String.sexTypeKey)
            defaults.synchronize()
        }
        
        reachability?.listener = { status in
            switch status {
//            case .reachable(.wwan):
//                UNoticeBar(config: UNoticeBarConfig(title: "主人,检测到您正在使用移动数据")).show(duration: 2)
            default: break
            }
        }
        reachability?.startListening()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientation
    }
    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        return true
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func animateMask() {
        
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
        keyFrameAnimation.duration = 1.3
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 0.5
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut), CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)]
        let initalBounds = NSValue(cgRect: mask!.bounds)
        let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 90, height: 87))
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 1600, height: 1300))
        keyFrameAnimation.values = [initalBounds, secondBounds, finalBounds]
        keyFrameAnimation.keyTimes = [0, 0.3, 1]
        self.mask!.add(keyFrameAnimation, forKey: "bounds")
        
        UIView.animate(withDuration: 2, animations: {
            self.imageView?.alpha = 0
        }) { (finished)in
            self.imageView?.removeFromSuperview()
        }
        
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        self.imageView!.layer.mask = nil
        
    }
}

extension UIApplication {
    class func changeOrientationTo(landscapeRight: Bool) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if landscapeRight == true {
            delegate.orientation = .landscapeRight
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        } else {
            delegate.orientation = .portrait
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
}
