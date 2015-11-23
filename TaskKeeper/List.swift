//
//  List.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/21/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import UIKit

class List: NSObject, NSCoding {
  
  // MARK: - General -
  var name = ""
  
  init(name: String) {
    self.name = name
    super.init()
  }
  
  //MARK: - Coding Delegate -
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(name, forKey: "Name")
  }
  
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObjectForKey("Name") as! String
    super.init()
  }
  
}
