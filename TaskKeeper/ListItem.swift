//
//  ListItem.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/12/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import Foundation
import UIKit

class ListItem: NSObject, NSCoding {
  
  // MARK: - General -
  var text = ""
  var checked = false
  var dueDate = NSDate()
  var shouldRemind = false
  var itemID: Int
  var application = UIApplication.sharedApplication()
  
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
  
  // MARK: - Local Notification -
  func scheduleLocalNotification() {
    let currentDate = NSDate()
    if let notification = currentItemNotifiction() {
      print("Found existing notification: \(notification)")
      application.cancelLocalNotification(notification)
    }
    if shouldRemind && dueDate.compare(currentDate) != .OrderedAscending {
      let localNotification = UILocalNotification()
      localNotification.fireDate = dueDate
      localNotification.timeZone = NSTimeZone.defaultTimeZone()
      localNotification.alertBody = text
      localNotification.soundName = UILocalNotificationDefaultSoundName
      localNotification.userInfo = ["ItemID" : itemID]
      application.scheduleLocalNotification(localNotification)
      print("Scheduled Notification: \(localNotification)\nItemID: \(itemID)")
    }
  }
  
  func currentItemNotifiction() -> UILocalNotification? {
    let allNotifications = application.scheduledLocalNotifications!
    for notification in allNotifications {
      if let tempItemID = notification.userInfo?["ItemID"] as? Int where tempItemID == itemID {
          return notification
      }
    }
    return nil
  }
  
  deinit {
    if let notification = currentItemNotifiction() {
      print("Removing notification: \(notification)")
      application.cancelLocalNotification(notification)
    }
  }
  
}
