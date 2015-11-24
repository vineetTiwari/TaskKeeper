//
//  DataModel.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/23/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import Foundation

class DataModel {
  
  // MARK: - General -
  var lists = [List]()
  let defaults = NSUserDefaults.standardUserDefaults()
  let listKey = "selectedListIndex"
  let firstTime = "firstTime"
  
  var listIndex: Int {
    get {
      return defaults.integerForKey(listKey)
    }
    set {
      defaults.setInteger(newValue, forKey: listKey)
      defaults.synchronize()
    }
  }
  
  init() {
    loadLists()
    regesterDefaults()
    handleFirstTime()
  }
  
  // MARK: - Key/Value Archiving -
  func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    return paths[0]
  }
  
  func dataFilePath() -> String {
    return (documentsDirectory() as NSString).stringByAppendingPathComponent("TasKeeper.plist")
  }
  
  func saveLists() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    archiver.encodeObject(lists, forKey: "Lists")
    archiver.finishEncoding()
    data.writeToFile(dataFilePath(), atomically: true)
  }
  
  func loadLists() {
    let path = dataFilePath()
    if NSFileManager.defaultManager().fileExistsAtPath(path) {
      if let data = NSData(contentsOfFile: path) {
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        lists = unarchiver.decodeObjectForKey("Lists") as! [List]
        unarchiver.finishDecoding()
      }
    }
  }
  
  // MARK: - Setup UserDefault -
  func regesterDefaults() {
    let registerationDictionary = [ listKey: -1,
                                  firstTime: true ]
    defaults.registerDefaults(registerationDictionary)
  }
  
  // MARK: - Error Hangling -
  func handleFirstTime() {
    let isFirstTime = defaults.boolForKey(firstTime)
    if isFirstTime {
      let defaultList = List(name: "List")
      lists.append(defaultList)
      listIndex = 0
      defaults.setBool(false, forKey: firstTime)
      defaults.synchronize()
    }
  }
}
