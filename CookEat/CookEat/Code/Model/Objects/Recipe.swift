//
//  Recipe.swift
//  CookEat
//
//  Created by David Bonnet on 05/03/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import Foundation
import RealmSwift

final class Recipe: Object {

  @objc dynamic var identifier: String = UUID().uuidString
  @objc dynamic var name: String?
  @objc dynamic var url: String = ""

  @objc dynamic var dateCreated = Date()
  @objc dynamic var dateModified = Date()
}
