//
//  IconPickerViewController.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/28/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import UIKit

// MARK: - Protocol -
protocol IconPickerViewControllerDelegate: class {
  
  func iconPickerViewController(picker: IconPickerViewController,
    didPickIconNamed iconName: String)
  
}

class IconPickerViewController: UITableViewController {
  
  // MARK: - General -
  weak var delegate: IconPickerViewControllerDelegate?
  let cellIdentifier = "IconCell"
  let iconList = [
    "Tasks",
    "Appointments",
    "Ingredients",
    "Shopping",
    "Folder",
    "Chores",
    "Birthdays",
    "Photos",
    "Bills",
    "Groceries"]
  
  // MARK - TableView DataSource -
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   return iconList.count
  }
  
  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
        forIndexPath: indexPath)
      let iconName = iconList[indexPath.row]
      setupCell(cell, forIconNamed: iconName)
    return cell
  }
  
  // MARK: - TableView Delegate -
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let delegate = delegate {
      let iconName = iconList[indexPath.row]
      delegate.iconPickerViewController(self, didPickIconNamed: iconName)
    }
  }
  
  // MARK: - Setup Cell - 
  func setupCell(cell: UITableViewCell, forIconNamed iconName: String ) {
    cell.textLabel!.text = iconName
    cell.imageView!.image = UIImage(named: iconName)
  }
  
}
