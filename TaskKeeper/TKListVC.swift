//
//  TKListVC.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/12/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import UIKit

class TKListVC: UITableViewController {
  
  let reuseIdentifier = "TKListCell"
  var items: [TKItem]
  
  required init?(coder aDecoder: NSCoder) {
    
    items = [TKItem]()
    
    let row0item = TKItem()
    row0item.text = "Walk the dog"
    row0item.isComplete = false
    items.append(row0item)
    
    let row1item = TKItem()
    row1item.text = "Brush my teeth"
    row1item.isComplete = false
    items.append(row1item)
    
    let row2item = TKItem()
    row2item.text = "Learn iOS development"
    row2item.isComplete = false
    items.append(row2item)
    
    let row3item = TKItem()
    row3item.text = "Football practice"
    row3item.isComplete = false
    items.append(row3item)
    
    let row4item = TKItem()
    row4item.text = "Eat ice cream"
    row4item.isComplete = false
    items.append(row4item)
    
    super.init(coder: aDecoder)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return items.count
  }
  
  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier,
        forIndexPath: indexPath)
      let item = items[indexPath.row]
      configureTextForCell(cell, withItem: item)
      configureCheckmarkForCell(cell, withItem: item)
      return cell
  }
  
  override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        let item = items[indexPath.row]
        item.toggelCompilationStatus()
        configureCheckmarkForCell(cell, withItem: item)
      }
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func configureCheckmarkForCell(cell: UITableViewCell, withItem item: TKItem) {
    if item.isComplete {
      cell.accessoryType = .Checkmark
      
    } else {
      cell.accessoryType = .None
    }
  }
  
  func configureTextForCell(cell: UITableViewCell, withItem item:TKItem) {
    let label = cell.viewWithTag(10101) as! UILabel
    label.text = item.text
  }
  
  override func tableView(tableView: UITableView,
    commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      items.removeAtIndex(indexPath.row)
      let indexPaths = [indexPath]
      tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }
}
