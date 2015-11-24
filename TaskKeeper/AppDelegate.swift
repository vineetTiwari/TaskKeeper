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

  var window: UIWindow?
  let dataModel = DataModel()
  
  //Mark: - App LifeCycle -
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
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
  
  // MARK: - Saving Data -
  func saveData() {
    dataModel.saveLists()
  }
  
  func loadData() {
    dataModel.loadLists()
  }
  
}

