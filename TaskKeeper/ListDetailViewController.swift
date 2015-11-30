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
  
  func listDetailViewController(controller: ListDetailViewController,
    didFinishAddingList list: List)
  
  func listDetailViewController(controller: ListDetailViewController,
    didFinishEditingList list: List)
  
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
  
  // MARK: - General -
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  @IBOutlet weak var iconImageView: UIImageView!
  
  weak var delegate: ListDetailViewControllerDelegate?
  var listToEdit: List?
  let ShowSegue = "ShowIcons"
  var iconName: String!
  
  // MARK: - ViewController LifeCycle -
  override func viewDidLoad() {
    super.viewDidLoad()
    if let list = listToEdit {
      title = "Edit List"
      textField.text = list.name
      iconName = list.iconName
      doneButton.enabled = true
      iconImageView?.image = UIImage(named: iconName)
    } else {
      iconImageView?.image = UIImage(named: "Tasks")
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  // MARK - TableView Delegate -
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    if indexPath.section == 1 {
      return indexPath
    } else {
      return nil
    }
  }
  
  // MARK: - Actions -
  @IBAction func cancelTouched() {
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  @IBAction func doneTouched() {
    if let list = listToEdit {
      list.name = textField.text!
      list.iconName = iconName
      delegate?.listDetailViewController(self, didFinishEditingList: list)
    } else {
      let list = List(name: textField.text!, iconName: iconName)
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
  
  // MARK: - Navigation -
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == ShowSegue {
      let controller = segue.destinationViewController as! IconPickerViewController
      controller.delegate = self
    }
  }
  
  // MARK: - IconPickerViewController Delegate -
  func iconPickerViewController(picker: IconPickerViewController,
    didPickIconNamed iconName: String) {
      iconImageView.image = UIImage(named: iconName)
      self.iconName = iconName
      navigationController?.popViewControllerAnimated(true)
  }
  
}
