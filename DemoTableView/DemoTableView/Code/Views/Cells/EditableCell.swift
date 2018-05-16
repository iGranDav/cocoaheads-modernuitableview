//
//  EditableCell.swift
//  DemoTableView
//
//  Created by David Bonnet on 16/05/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import Reusable

class EditableCell: UITableViewCell, NibReusable {

  @IBOutlet weak var textfield: UITextField!

  override func awakeFromNib() {
    super.awakeFromNib()

    textfield.delegate = self
  }

}

extension EditableCell: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textfield.resignFirstResponder()
    return true
  }

}
