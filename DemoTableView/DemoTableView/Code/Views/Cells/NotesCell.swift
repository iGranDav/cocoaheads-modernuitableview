//
//  NotesCell.swift
//  DemoTableView
//
//  Created by David Bonnet on 16/05/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import Reusable

final class NotesCell: UITableViewCell, NibReusable {

  @IBOutlet weak var textview: UITextView!

  override func awakeFromNib() {
    super.awakeFromNib()

    let toolbar = UIToolbar(frame: .zero)
    toolbar.items = [
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finishEditing(_:)))
    ]
    toolbar.sizeToFit()

    textview.inputAccessoryView = toolbar
  }

  @objc
  private func finishEditing(_ sender: UIBarButtonItem) {
    textview.resignFirstResponder()
  }
}
