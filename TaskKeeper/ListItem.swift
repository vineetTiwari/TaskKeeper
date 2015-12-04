//
//  ListItem.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/12/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import Foundation

class ListItem: NSObject, NSCoding {
  
  // MARK: - General -
  var text = ""
  var checked = false
  var dueDate = NSDate()
  var shouldRemind = false
  var itemID: Int
  
  func toggelCompletionStatus() {
    checked = !checked
  }
  
  override init() {
    itemID = DataModel.nextItemID()
    super.init()
  }
  
  // MARK: - Coding Delegate -
  required init?(coder aDecoder: NSCoder) {
    text = aDecoder.decodeObjectForKey("Text") as! String
    checked = aDecoder.decodeBoolForKey("Checked")
    dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
    itemID = aDecoder.decodeIntegerForKey("ItemID")
    shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
    super.init()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(text, forKey: "Text")
    aCoder.encodeBool(checked, forKey: "Checked")
    aCoder.encodeObject(dueDate, forKey: "DueDate")
    aCoder.encodeInteger(itemID, forKey: "ItemID")
    aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
  }
  
}
