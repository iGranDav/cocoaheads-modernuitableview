//
//  Config.swift
//  DemoTableView
//
//  Created by David Bonnet on 05/03/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import Foundation

public struct Config {

  public static func setup() {
    LogsConfig.setupConsole()
    RealmConfig.setup()
  }
}
