//
//  TaskCell.swift
//  DemoTableView
//
//  Created by David Bonnet on 16/05/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import Reusable

final class TaskCell: UITableViewCell, NibReusable {

  @IBOutlet weak var completedButton: UIButton!
  @IBOutlet weak var infoLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()

    selectionStyle = .gray
  }
}
