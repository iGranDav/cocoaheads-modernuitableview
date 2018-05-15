//
//  RealmConfig.swift
//  DemoTableView
//
//  Copyright © 2018 Harpp. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmConfig {

  static func setup() {
    var configuration = Realm.Configuration.defaultConfiguration

    #if DEBUG
    configuration.deleteRealmIfMigrationNeeded = true
    #endif

    configuration.schemaVersion = 1
    configuration.migrationBlock = { (migration, oldVersion) in
      //           App          | Realm  |
      //         version        | schema |
      // -----------------------|--------|
      // DemoTableView    1.0.0 |      1 |
      //
    }

    Realm.Configuration.defaultConfiguration = configuration

    guard let realm = try? Realm() else { fatalError("Unable to setup Realm.") }
    if let fileURL = realm.configuration.fileURL {
      log.info("realm file URL: \(fileURL.absoluteString)")
    }

  }
}
