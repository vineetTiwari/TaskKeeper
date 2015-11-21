//
//  TKListVC.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/12/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import UIKit

class TKListVC: UITableViewController, TKItemDetailVCDelegate {
  
  let reuseIdentifier = "TKListCell"
  var items: [TKItem]
  
  required init?(coder aDecoder: NSCoder) {
    items = [TKItem]()
    super.init(coder: aDecoder)
    loadTKItems()
  }
  
  // MARK: - Table view data source -
  
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
      configureTextForCell(cell, withTKItem: item)
      configureCheckmarkForCell(cell, withTKItem: item)
      return cell
  }
  
  override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        let item = items[indexPath.row]
        item.toggelCompilationStatus()
        configureCheckmarkForCell(cell, withTKItem: item)
      }
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      saveTKItem()
  }
  
  override func tableView(tableView: UITableView,
    commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      items.removeAtIndex(indexPath.row)
      let indexPaths = [indexPath]
      tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
      saveTKItem()
  }
  
  func configureTextForCell(cell: UITableViewCell, withTKItem item:TKItem) {
    let label = cell.viewWithTag(10101) as! UILabel
    label.text = item.text
  }
  
  func configureCheckmarkForCell(cell: UITableViewCell, withTKItem item: TKItem) {
    let label = cell.viewWithTag(10102) as! UILabel
    
    if item.checked {
      label.text = "√"
    } else {
      label.text = ""
    }
  }
  
  // MARK: - TKCreateTaskVCDelegate -
  
  func tKItemDetailVC(controller: TKItemDetailVC, didFinishAddingItem item: TKItem) {
    let newRowIndex = items.count
    items.append(item)
    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
    let indexPaths = [indexPath]
    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    dismissViewControllerAnimated(true, completion: nil)
    saveTKItem()
  }
  
  func tKitemDetailVC(controller: TKItemDetailVC, didFinishEditingItem item: TKItem) {
    if let index = items.indexOf(item) {
      let indexPath = NSIndexPath(forRow: index, inSection: 0)
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        self.configureTextForCell(cell, withTKItem: item)
      }
    }
    dismissViewControllerAnimated(true, completion: nil)
    saveTKItem()
  }
  
  func tKItemDetailVCDidCancel(controller: TKItemDetailVC) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: - Segue -
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "AddItem" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! TKItemDetailVC
      controller.delegate = self
    } else if segue.identifier == "EditItem" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! TKItemDetailVC
      controller.delegate = self
      if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
        controller.itemToEdit = items[indexPath.row]
      }
    }
  }
  
  // MASK: - DataStorage -
  func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    
    return paths[0]
  }
  
  func dataFilePath() -> String {
    return (documentsDirectory() as NSString).stringByAppendingPathComponent("TasKeeper.plist")
  }
  
  func saveTKItem() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    archiver.encodeObject(items, forKey: "TKItems")
    archiver.finishEncoding()
    data.writeToFile(dataFilePath(), atomically: true)
  }
  
  func loadTKItems() {
    let path = dataFilePath()
    if NSFileManager.defaultManager().fileExistsAtPath(path) {
      if let data = NSData(contentsOfFile: path) {
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        items = unarchiver.decodeObjectForKey("TKItems") as! [TKItem]
        unarchiver.finishDecoding()
      }
    }
  }
  
}
