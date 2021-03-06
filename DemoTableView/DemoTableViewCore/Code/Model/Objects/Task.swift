//
//  Task.swift
//  DemoTableView
//
//  Created by David Bonnet on 05/03/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import Foundation
import RealmSwift

public final class Task: Object {

  @objc public dynamic var identifier: String = UUID().uuidString
  @objc public dynamic var name: String?
  @objc public dynamic var notes: String?
  @objc public dynamic var image: String?
  @objc public dynamic var dueDate: Date?
  @objc public dynamic var completed: Bool = false

  @objc public dynamic var dateCreated = Date()
  @objc public dynamic var dateModified = Date()

  @objc
  override public static func primaryKey() -> String? {
    return "identifier"
  }
}
