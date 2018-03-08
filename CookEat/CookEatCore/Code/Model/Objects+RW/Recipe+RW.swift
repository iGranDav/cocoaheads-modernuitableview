//
//  Recipe+RW.swift
//  CookEat
//
//  Created by David Bonnet on 05/03/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import Foundation
import RealmSwift
import Extra

public extension Recipe {

  public static func all() -> Results<Recipe> {
    let realm = Realm.ex.safeInstance()
    return realm.objects(Recipe.self)
  }

  public static func add(from url: URL, name: String) throws {

    let recipe = Recipe()
    recipe.url = url.absoluteString
    recipe.name = name

    let realm = Realm.ex.safeInstance()
    try realm.write {
      realm.add(recipe)
    }

  }

  public func delete() throws {

    let realm = Realm.ex.safeInstance()
    try realm.write {
      realm.delete(self)
    }
  }

}
