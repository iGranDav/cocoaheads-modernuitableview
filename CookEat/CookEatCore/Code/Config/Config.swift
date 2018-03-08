//
//  Config.swift
//  CookEat
//
//  Created by David Bonnet on 05/03/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import Foundation

public struct Config {

  static let sharedContainerIdentifier: String = "group.io.harpp.CookEat"

  public static func setup() {
    LogsConfig.setupConsole()
    RealmConfig.setup()
  }
}
