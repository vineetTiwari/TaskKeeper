//
//  ListItemDetailViewController.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/14/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import UIKit

// MARK: - Protpcol -
protocol ListItemDetailViewControllerDelegate : class {
  
  func listItemDetailViewControllerDidCancel(controller: ListItemDetailViewController)
  
  func listItemDetailViewController(controller: ListItemDetailViewController, didFinishAddingItem item: ListItem)
  
  func listItemDetailViewController(controller: ListItemDetailViewController, didFinishEditingItem item: ListItem)
  
}

class ListItemDetailViewController: UITableViewController, UITextFieldDelegate {
  
  // MARK: - General -
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  @IBOutlet weak var shouldRemind: UISwitch!
  @IBOutlet weak var dueDateLabel: UILabel!
  @IBOutlet weak var datePicketCell: UITableViewCell!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  var itemToEdit: ListItem?
  var dueDate = NSDate()
  let currentDate = NSDate()
  var datePickerVisible = false
  var application = UIApplication.sharedApplication()
  
  weak var delegate: ListItemDetailViewControllerDelegate?
  
  // MARK: - ViewController LifeCycle -
  override func viewDidLoad() {
    super.viewDidLoad()
    datePicker.minimumDate = currentDate
    if let item = itemToEdit {
      setupCellWithItem(item)
    } else {
      datePicker.date = currentDate
    }
    updateDueDate()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  // MARK: - TableView DataSource -
  override func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      if section == 1 && datePickerVisible {
        return 3
      } else {
        return super.tableView(tableView,
          numberOfRowsInSection: section)
      }
  }
  
  override func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      if indexPath.section == 1 && indexPath.row == 2 {
        return datePicketCell
      } else {
        return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      }
  }
  
  override func tableView(tableView: UITableView,
    heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      if indexPath.section == 1 && indexPath.row == 2 {
        return 217
      } else {
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
      }
  }
  
  override func tableView(tableView: UITableView,
    willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
      if indexPath.section == 1 && indexPath.row == 1 {
        return indexPath
      } else {
        return nil
      }
  }
  
  override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      textField.resignFirstResponder()
      if indexPath.section == 1 && indexPath.row == 1 {
        if !datePickerVisible {
          showDatePicker()
        } else {
          hideDatePicker()
        }
      }
  }
  
  override func tableView(tableView: UITableView,
    var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
      if indexPath.section == 1 && indexPath.row == 2 {
        indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
      }
      return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
  }
  
  // MARK: - EditView Setup -
  func setupCellWithItem(item: ListItem) {
    title = "Edit Item"
    textField.text = item.text
    doneButton.enabled = true
    shouldRemind.on = item.shouldRemind
    dueDate = item.dueDate
  }
  
  // MARK: - Item For Delegate -
  func setupItemForDelegate(item: ListItem) {
    item.text = textField.text!
    item.shouldRemind = shouldRemind.on
    item.dueDate = dueDate
    item.scheduleLocalNotification()
  }
  
  // MARK: - Actions -
  @IBAction func doneTouched() {
    if let item = itemToEdit {
      setupItemForDelegate(item)
      delegate?.listItemDetailViewController(self, didFinishEditingItem: item)
    } else {
      let item = ListItem()
      setupItemForDelegate(item)
      item.checked = false
      delegate?.listItemDetailViewController(self, didFinishAddingItem: item)
    }
  }
  
  @IBAction func cancelTouched() {
    delegate?.listItemDetailViewControllerDidCancel(self)
  }
  
  @IBAction func dateChanged(datePicker: UIDatePicker) {
    dueDate = datePicker.date
    updateDueDate()
  }
  
  @IBAction func shouldRemindtoggled(reminderActivationSwitch: UISwitch) {
    textField.resignFirstResponder()
    if reminderActivationSwitch.on {
      let userNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
      application.registerUserNotificationSettings(userNotificationSettings)
    }
  }
  
  // MARK: - UITextField Delegate -
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let oldText: NSString = textField.text!
    let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
    doneButton.enabled = (newText.length > 0)
    return true
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    if datePickerVisible {
      hideDatePicker()
    }
  }
  
  // MARK: - DatePicker -
  func updateDueDate() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    dueDateLabel.text = formatter.stringFromDate(dueDate)
  }
  
  func showDatePicker() {
    datePickerVisible = true
    let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
    let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
    if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
      dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
    }
    tableView.beginUpdates()
    tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
    tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
    tableView.endUpdates()
    datePicker.setDate(dueDate, animated: false)
  }
  
  func hideDatePicker() {
    datePickerVisible = false
    let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
    let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
    if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
      dateCell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
    }
    tableView.beginUpdates()
    tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
    tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
    tableView.endUpdates()
  }
  
}
