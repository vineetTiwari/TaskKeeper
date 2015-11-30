//
//  ListViewController.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/12/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, ListItemDetailViewControllerDelegate {
  
  // MARK: - General -
  let ItemCell = "ListItemCell"
  let AddSegue = "AddItem"
  let EditSegue = "EditItem"
  var list: List!
  var items = [ListItem]()
    
  // MARK: - ViewController LifeCycle -
  override func viewDidLoad() {
    super.viewDidLoad()
    if (list != nil)  {
      title = list.name
    } else {
      title = "Task List"
    }
  }
  
  // MARK: - TableView DataSource -
  override func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return list.items.count
  }
  
  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier(ItemCell,
        forIndexPath: indexPath)
      let item = list.items[indexPath.row]
      configureTextForCell(cell, withListItem: item)
      configureCheckmarkForCell(cell, withListItem: item)
      return cell
  }
  
  override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        let item = list.items[indexPath.row]
        item.toggelCompletionStatus()
        configureCheckmarkForCell(cell, withListItem: item)
      }
//      tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func tableView(tableView: UITableView,
    commitEditingStyle editingStyle: UITableViewCellEditingStyle,
    forRowAtIndexPath indexPath: NSIndexPath) {
      list.items.removeAtIndex(indexPath.row)
      let indexPaths = [indexPath]
      tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }
  
  // MARK: - Setup Cell -
  func configureTextForCell(cell: UITableViewCell, withListItem item:ListItem) {
    let label = cell.viewWithTag(10101) as! UILabel
    label.text = item.text
  }
  
  func configureCheckmarkForCell(cell: UITableViewCell, withListItem item: ListItem) {
    let circleImageView = cell.viewWithTag(10102) as! UIImageView
    if item.checked {
      circleImageView.highlighted = true
    } else {
      circleImageView.highlighted = false
    }
  }
  
  // MARK: - Navigation -
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == AddSegue {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! ListItemDetailViewController
      controller.delegate = self
      controller.itemToEdit = nil
    } else if segue.identifier == EditSegue {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! ListItemDetailViewController
      controller.delegate = self
      if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
        controller.itemToEdit = list.items[indexPath.row]
      }
    }
  }
  
  // MARK: - ListItemDetailViewController Delegate -
  func listItemDetailViewControllerDidCancel(controller: ListItemDetailViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func listItemDetailViewController(controller: ListItemDetailViewController, didFinishAddingItem item: ListItem) {
    let newRowIndex = list.items.count
    list.items.append(item)
    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
    let indexPaths = [indexPath]
    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func listItemDetailViewController(controller: ListItemDetailViewController, didFinishEditingItem item: ListItem) {
    if let index = list.items.indexOf(item) {
      let indexPath = NSIndexPath(forRow: index, inSection: 0)
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        self.configureTextForCell(cell, withListItem: item)
      }
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}
