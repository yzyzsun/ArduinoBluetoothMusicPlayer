//
//  AppDelegate.swift
//  ArduinoBluetoothMusicPlayer
//
//  Created by yzyzsun on 2015-08-28.
//  Copyright (c) 2015 yzyzsun. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func applicationWillTerminate(application: UIApplication) {
        BLEManager.sharedInstance.clearPeripheral()
    }

}
