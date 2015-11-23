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
  
  weak var delegate: ListItemDetailViewControllerDelegate?
  var itemToEdit: ListItem?
  
  // MARK: - ViewController LifeCycle -
  override func viewDidLoad() {
    super.viewDidLoad()
    if let item = itemToEdit {
      title = "Edit Item"
      textField.text = item.text
      doneButton.enabled = true
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  // MARK - TableView DataSource -
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    return nil
  }
  
  // MARK: - Actions -
  @IBAction func doneTouched() {
    if let item = itemToEdit {
      item.text = textField.text!
      delegate?.listItemDetailViewController(self, didFinishEditingItem: item)
    } else {
      let item = ListItem()
      item.text = textField.text!
      item.checked = false
      delegate?.listItemDetailViewController(self, didFinishAddingItem: item)
    }
  }
  
  @IBAction func cancelTouched() {
    delegate?.listItemDetailViewControllerDidCancel(self)
  }
  
  // MARK: - UITextField Delegate -
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let oldText: NSString = textField.text!
    let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
    doneButton.enabled = (newText.length > 0)
    return true
  }
  
}
