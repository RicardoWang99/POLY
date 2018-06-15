//
//  AppDelegate.swift
//  Poly
//
//  Created by 王西平 on 2018/4/16.
//  Copyright © 2018 王西平. All rights reserved.
//

import UIKit
import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Pause camera
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Pause camera
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Resume camera
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Pause camera if not already
    }
    
    
}
