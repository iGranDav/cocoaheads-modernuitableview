//
//  Task+RW.swift
//  DemoTableView
//
//  Created by David Bonnet on 05/03/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import Foundation
import RealmSwift
import Extra

public extension Task {

  public static func all() -> Results<Task> {
    let realm = Realm.ex.safeInstance()
    return realm.objects(Task.self)
  }

  public static func add(name: String) throws {

    let task = Task()
    task.name = name

    let realm = Realm.ex.safeInstance()
    try realm.write {
      realm.add(task)
    }

  }

  public static func add(_ task: Task) throws {

    let realm = Realm.ex.safeInstance()
    try realm.write {
      realm.add(task, update: true)
    }

  }

  public func delete() throws {

    let realm = Realm.ex.safeInstance()
    try realm.write {
      realm.delete(self)
    }
  }

}
