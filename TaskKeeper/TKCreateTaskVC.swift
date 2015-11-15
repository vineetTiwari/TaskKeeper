//
//  TKCreateTaskVC.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/14/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import UIKit

class TKCreateTaskVC: UITableViewController {
  
  @IBAction func doneButtonTouched(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func cancelButtonTouched(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}
