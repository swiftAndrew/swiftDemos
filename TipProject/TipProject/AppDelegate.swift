//
//  AppDelegate.swift
//  TipProject
//
//  Created by Andrew on 16/3/13.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var backgroundTask:UIBackgroundTaskIdentifier!=nil
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("====\(__FUNCTION__)===")
        
//        let session:AVAudioSession=AVAudioSession.sharedInstance();
//        try? session.setActive(true);
//        
//        //支持后台播放
//        try? session.setCategory(AVAudioSessionCategoryPlayback);
        
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        print("====\(__FUNCTION__)===")
        
        
        //下面这些代码保证手机进入后台后仍能执行 NSTimer
     
        //如果已存在后台任务，先将其设为完成
        if self.backgroundTask != nil {
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
        
        //让后台程序继续执行
        self.backgroundTask=application.beginBackgroundTaskWithExpirationHandler({ () -> Void in
            
            //如果没有调用endBackgroundTask,时间耗尽时应用程序被终止
            application.endBackgroundTask(self.backgroundTask);
            self.backgroundTask=UIBackgroundTaskInvalid;
        })
        
     
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    


}

