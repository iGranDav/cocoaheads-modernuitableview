//
//  RealmConfig.swift
//  CookEat
//
//  Copyright © 2018 Harpp. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmConfig {

  static func setup() {
    var configuration = Realm.Configuration.defaultConfiguration

    configuration.schemaVersion = 1
    configuration.migrationBlock = { (migration, oldVersion) in
      //        App       | Realm  |
      //      version     | schema |
      // -----------------|--------|
      // CookEat    1.0.0 |      1 |
      //
    }

    var containerURL: URL

    guard let availableContainerURL = FileManager.default
      .containerURL(forSecurityApplicationGroupIdentifier: Config.sharedContainerIdentifier) else {
        fatalError("Unable to get container URL for app group: \(Config.sharedContainerIdentifier).")
    }
    containerURL = availableContainerURL

    let realmPath = containerURL.appendingPathComponent("db.realm")
    configuration.fileURL = realmPath
    Realm.Configuration.defaultConfiguration = configuration

    guard let realm = try? Realm() else { fatalError("Unable to setup Realm.") }
    if let fileURL = realm.configuration.fileURL {
      log.info("realm file URL: \(fileURL.absoluteString)")
    } else {
      log.info("realm path: \(realmPath)")
    }
  }
}
