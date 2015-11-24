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
  
  init() {
    loadLists()
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
  
}
