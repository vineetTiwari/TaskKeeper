//
//  TKItem.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/12/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import Foundation

class TKItem: NSObject, NSCoding {
  var text = ""
  var checked = false
  
  func toggelCompilationStatus() {
    checked = !checked
  }
  
  override init() {
    super.init()
  }
  
  //MARK: - NSCoderDelegate -
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(text, forKey: "Text")
    aCoder.encodeBool(checked, forKey: "Checked")
  }

  required init?(coder aDecoder: NSCoder) {
    text = aDecoder.decodeObjectForKey("Text") as! String
    checked = aDecoder.decodeBoolForKey("Checked")
    super.init()
  }
}
