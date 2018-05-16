//
//  DatePickerCell.swift
//  DemoTableView
//
//  Created by David Bonnet on 16/05/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import Reusable

class DatePickerCell: UITableViewCell, NibReusable {

  @IBOutlet weak var datePicker: UIDatePicker!

  override func awakeFromNib() {
    super.awakeFromNib()

  }

}
