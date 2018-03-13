//
//  Recipe.swift
//  CookEat
//
//  Created by David Bonnet on 05/03/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import Foundation
import RealmSwift

public final class Recipe: Object {

  @objc public dynamic var identifier: String = UUID().uuidString
  @objc public dynamic var name: String?
  @objc public dynamic var url: String = ""
  @objc public dynamic var image: String?

  @objc public dynamic var dateCreated = Date()
  @objc public dynamic var dateModified = Date()

  @objc
  override public static func primaryKey() -> String? {
    return "identifier"
  }
}
