//
//  AppDelegate.swift
//  Wify
//
//  Created by caiyangzhenyu on 16/11/22.
//  Copyright © 2016年 caiyangzhenyu. All rights reserved.
//

import UIKit
import ReachabilitySwift
import SystemConfiguration.CaptiveNetwork
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var reachability:Reachability!
    var taskId:UIBackgroundTaskIdentifier!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AppDelegate.timing(_:)), userInfo: nil, repeats: true)
        if UserDefaults.standard.object(forKey: "records") == nil {
            let arr = NSArray.init()
            
            UserDefaults.standard.setValue(arr, forKey: "records")
        }
        
        
        reachability = Reachability.init()
        if reachability.isReachable {
            print("可用")
        }else {
            print("不可用")
        }
        if reachability.isReachableViaWiFi {
            print("网络类型:Wify")
            
//            let dic = NSMutableDictionary()
//            dic.setObject(getSSID(), forKey: "name" as NSCopying)
//            dic.setObject(nowDateFormatter(), forKey: "time" as NSCopying)
//            let arr = NSMutableArray.init(array: UserDefaults.standard.value(forKey: "records") as! NSArray)
//            if arr.count > 20 {
//                arr.removeObject(at: 0)
//            }
//             arr.add(dic)
//            UserDefaults.standard.setValue(arr, forKey: "records")
            
        }else if reachability.isReachableViaWWAN {
            print("网络类型:移动网络")
        }else {
            print("网络类型:无连接")
        }
        
//        推送
        let uns = UIUserNotificationSettings.init(types: UIUserNotificationType.alert.union(UIUserNotificationType.sound).union(UIUserNotificationType.badge), categories: nil)
        UIApplication.shared.registerUserNotificationSettings(uns)
        reachability.whenReachable = { reachability in
            print(reachability.currentReachabilityStatus)
            if reachability.currentReachabilityStatus == .reachableViaWiFi {
                let dic = NSMutableDictionary()
                dic.setObject(self.getSSID(), forKey: "name" as NSCopying)
                dic.setObject(self.nowDateFormatter(), forKey: "time" as NSCopying)
                let arr = NSMutableArray.init(array: UserDefaults.standard.value(forKey: "records") as! NSArray)
                if arr.count > 20 {
                    arr.removeObject(at: 0)
                }
                arr.add(dic)
                let noti = UILocalNotification.init()
                if #available(iOS 8.2, *) {
                    noti.alertTitle = self.getSSID()
                } else {
                    // Fallback on earlier versions
                }
                
                
                UserDefaults.standard.setValue(arr, forKey: "records")
                noti.alertBody = self.nowDateFormatter()
                noti.soundName = UILocalNotificationDefaultSoundName
                noti.applicationIconBadgeNumber = 1
                application.presentLocalNotificationNow(noti)
            }
        }
        do {
            try reachability.startNotifier()
        }catch {
            print("unable to start notifier")
        }

        return true
    }
    func getSSID() -> String {
        var currentSSID = ""
        if let interfaces:CFArray = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as Dictionary!
                    for dictData in interfaceData! {
                        if dictData.key as! String == "SSID" {
                            currentSSID = dictData.value as! String
                        }
                    }
                }
            }
        }
        return currentSSID
    }
    func nowDateFormatter()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let datestr = formatter.string(from: Date())
        
        return datestr
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
//    two method 
    func begin() {
        let app = UIApplication.shared
        taskId = app.beginBackgroundTask(expirationHandler: {
//            app.endBackgroundTask(self.taskId)
//            self.end()
        })

    }
    func end() {
        let app = UIApplication.shared
        app.endBackgroundTask(taskId)
        taskId = UIBackgroundTaskInvalid
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.begin()
//        self.end()
//        taskId = application.beginBackgroundTask(expirationHandler: {
//            application.endBackgroundTask(self.taskId)
//        })
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    var count = 0;
    func timing(_ time:Timer) {
        count += 1
//        if count % 500 == 0 {
//            let app = UIApplication.shared
//            app.endBackgroundTask(taskId)
//            taskId = app.beginBackgroundTask(expirationHandler: nil)
//        }
        print(count)
    }
   
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        NotificationCenter.default.post(name: NSNotification.Name.init("refresh"), object: nil)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

