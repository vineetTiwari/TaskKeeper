//
//  AppDelegate.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/12/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // MARK: - General -
  var window: UIWindow?
  let dataModel = DataModel()
  
  // Mark: - UIApplication Delegate -
  func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      let navigationController = window!.rootViewController as! UINavigationController
      let controller = navigationController.viewControllers[0] as! AllListsViewController
      controller.dataModel = dataModel
      return true
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    saveData()
  }
  
  func applicationWillTerminate(application: UIApplication) {
    saveData()
  }
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    print("Local Notification Received\(notification)")
  }
  
  // MARK: - Data Persistance -
  func saveData() {
    dataModel.saveLists()
  }
  
}

