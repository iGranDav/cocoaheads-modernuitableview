//
//  PlaceholderView.swift
//  DemoTableView
//
//  Created by David Bonnet on 15/05/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import Reusable

final class PlaceholderView: UIView, NibLoadable {

  struct State {
    var emotion: String
    var title: String
    var details: String?
  }

  @IBOutlet private weak var emojiLabel: UILabel!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!

  var state: State? {
    didSet {
      emojiLabel.text = state?.emotion
      titleLabel.text = state?.title
      descriptionLabel.text = state?.details
    }
  }

}
