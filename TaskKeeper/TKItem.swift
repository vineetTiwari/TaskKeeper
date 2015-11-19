//
//  TKItem.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/12/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import Foundation

class TKItem: NSObject {
  var text = ""
  var checked = false
  
  func toggelCompilationStatus() {
    checked = !checked
  }
}
