//
//  AppDelegate.swift
//  ConnectivityExample
//
//  Created by Ralf Ebert on 13/09/15.
//  Copyright © 2015 Example. All rights reserved.
//

import UIKit
import WatchConnectivity
import AudioToolbox

class ConnectivityHandler : NSObject, WCSessionDelegate {
    
    var session = WCSession.defaultSession()
    
    var messages = [String]() {
        // fire KVO-updates for Swift property
        willSet { willChangeValueForKey("messages") }
        didSet  { didChangeValueForKey("messages")  }
    }

    override init() {
        super.init()
        
        session.delegate = self
        session.activateSession()
        
        NSLog("%@", "WCSession.isSupported: \(WCSession.isSupported()), Paired Watch: \(session.paired), Watch App Installed: \(session.watchAppInstalled)")
    }
    
    // MARK: - WCSessionDelegate
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        NSLog("didReceiveMessage: %@", message)
        if message["request"] as? String == "date" {
            replyHandler(["date" : String(NSDate())])
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let msg = message["msg"]!
        self.messages.append("Message \(msg)")
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        let msg = applicationContext["msg"]!
        self.messages.append("AppContext \(msg)")
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        let msg = userInfo["msg"]!
        self.messages.append("UserInfo \(msg)")
    }

}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var connectivityHandler : ConnectivityHandler?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if WCSession.isSupported() {
            self.connectivityHandler = ConnectivityHandler()
        } else {
            NSLog("WCSession not supported (f.e. on iPad, iOS 8).")
        }

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

