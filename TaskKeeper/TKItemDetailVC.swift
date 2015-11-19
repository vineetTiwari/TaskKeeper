//
//  TKItemDetailVC.swift
//  TaskKeeper
//
//  Created by Vineet Tiwari on 11/14/15.
//  Copyright © 2015 Vineet Tiwari. All rights reserved.
//

import UIKit

protocol TKItemDetailVCDelegate : class {
  func tKItemDetailVCDidCancel(controller: TKItemDetailVC)
  func tKItemDetailVC(controller: TKItemDetailVC, didFinishAddingItem item:TKItem)
  func tKitemDetailVC(controller: TKItemDetailVC, didFinishEditingItem item:TKItem)
}

class TKItemDetailVC: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneButton: UIBarButtonItem!
  
  weak var delegate: TKItemDetailVCDelegate?
  var itemToEdit: TKItem?
  
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
  
  // MARK: - Actions -
  
  @IBAction func doneTouched() {
    if let item = itemToEdit {
      item.text = textField.text!
      delegate?.tKitemDetailVC(self, didFinishEditingItem: item)
    } else {
      let item = TKItem()
      item.text = textField.text!
      item.checked = false
      delegate?.tKItemDetailVC(self, didFinishAddingItem: item)
    }
  }
  
  @IBAction func cancelTouched() {
    delegate?.tKItemDetailVCDidCancel(self)
  }
  
  // MARK: - UITextFieldDelegate -
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let oldText: NSString = textField.text!
    let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
    doneButton.enabled = (newText.length > 0)
    return true
  }
}
