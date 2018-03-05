//
//  Config.swift
//  CookEat
//
//  Created by David Bonnet on 05/03/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import Foundation

struct Config {

  static let sharedContainerIdentifier: String = {
    guard let identifier = Bundle.main.bundleIdentifier else {
      fatalError("You must define a bundle identifier in the Info.plist file")
    }
    return "group.\(identifier)"
  }()
}
