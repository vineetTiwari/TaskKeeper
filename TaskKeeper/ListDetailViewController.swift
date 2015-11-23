//
//  ListDetailViewController.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/21/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import UIKit

// MARK: - Protocol -
protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(controller: ListDetailViewController)
  func listDetailViewController(controller: ListDetailViewController, didFinishAddingList list: List)
  func listDetailViewController(controller: ListDetailViewController, didFinishEditingList list: List)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
  
  // MARK: - General -
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  
  weak var delegate: ListDetailViewControllerDelegate?
  var listToEdit: List?
  
  // MARK: - ViewController LifeCycle -
  override func viewDidLoad() {
    super.viewDidLoad()
    if let list = listToEdit {
      title = "Edit List"
      textField.text = list.name
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
  @IBAction func cancelTouched() {
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  @IBAction func doneTouched() {
    if let list = listToEdit {
      list.name = textField.text!
      delegate?.listDetailViewController(self, didFinishEditingList: list)
    } else {
      let list = List(name: textField.text!)
      delegate?.listDetailViewController(self, didFinishAddingList: list)
    }
  }
  
  // MARK: - TextField Delegate -
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let oldText: NSString = textField.text!
    let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
    doneButton.enabled = (newText.length > 0)
    return true
  }
  
}
