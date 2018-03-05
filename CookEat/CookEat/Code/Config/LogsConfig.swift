//
//  LogsConfig.swift
//  CookEat
//
//  Copyright © 2018 Harpp. All rights reserved.
//

import Foundation
import SwiftyBeaver

let log = SwiftyBeaver.self

struct LogsConfig {
  static func setupConsole() {
    let console = ConsoleDestination()
    console.levelColor.verbose = "📓 "
    console.levelColor.debug = "📗 "
    console.levelColor.info = "📘 "
    console.levelColor.warning = "📒 "
    console.levelColor.error = "📕 "
    #if DEBUG
      console.minLevel = .verbose
    #else
      console.minLevel = .error
    #endif

    log.addDestination(console)
  }
}
