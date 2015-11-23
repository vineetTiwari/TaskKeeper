//
//  AllListsViewController.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/20/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
  
  // MARK: - General -
  let font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
  let ShowSegue = "ShowList"
  let AddSegue = "AddList"
  var lists: [List]
  let listDetailNavController = "ListDetailNavController"
  
  required init?(coder aDecoder: NSCoder) {
    lists = [List]()
    super.init(coder: aDecoder)
    var list = List(name: "Birthdays")
    lists.append(list)
    list = List(name: "To Do")
    lists.append(list)
  }
  
  // MARK: - TableView DataSource -
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return lists.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = cellForTableView(tableView)
    let list = lists[indexPath.row]
    cell.textLabel!.font = font
    cell.textLabel!.text = list.name
    cell.accessoryType = .DetailButton
    return cell
  }
  
  func cellForTableView(tableView: UITableView) -> UITableViewCell {
    let ListCell = "AllListsCell"
    if let cell = tableView.dequeueReusableCellWithIdentifier(ListCell) {
      return cell
    } else {
      return UITableViewCell(style: .Default, reuseIdentifier: ListCell)
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let list = lists[indexPath.row]
    performSegueWithIdentifier(ShowSegue, sender: list)
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    lists.removeAtIndex(indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }
  
  // MARK: - TableView Delegate -
  override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    let navigationController = storyboard!.instantiateViewControllerWithIdentifier(listDetailNavController) as! UINavigationController
    let controller = navigationController.topViewController as! ListDetailViewController
    controller.delegate = self
    let list = lists[indexPath.row]
    controller.listToEdit = list
    presentViewController(navigationController, animated: true, completion: nil)
  }
  
  // MARK: - Navigation -
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == ShowSegue) {
      let controller = segue.destinationViewController as! ListViewController
      controller.list = sender as! List
    } else if (segue.identifier == AddSegue) {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! ListDetailViewController
      controller.delegate = self
      controller.listToEdit = nil
    }
  }
  
  // MARK: - ListDetailViewController Delegate -
  func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func listDetailViewController(controller: ListDetailViewController, didFinishAddingList list: List) {
    let newRowIndex = lists.count
    lists.append(list)
    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
    let indexPaths = [indexPath]
    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func listDetailViewController(controller: ListDetailViewController, didFinishEditingList list: List) {
    if let index = lists.indexOf(list) {
      let indexPath = NSIndexPath(forRow: index, inSection: 0)
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        cell.textLabel!.text = list.name as String
      }
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
}
