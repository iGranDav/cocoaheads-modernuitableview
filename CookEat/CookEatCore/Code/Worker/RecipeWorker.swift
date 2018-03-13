//
//  RecipeWorker.swift
//  CookEatCore
//
//  Created by David Bonnet on 13/03/2018.
//  Copyright © 2018 Harpp. All rights reserved.
//

import Foundation
import SwiftSoup
import Unbox

enum RecipeWorkerError: Error, CustomDebugStringConvertible {
  case noJSONLD(url: URL)
  case decodingJSONLD(url: URL, jsonLD: String)

  var debugDescription: String {
    switch self {
    case .noJSONLD(let url):
      return "No JSON+LD found for url \(url)"
    case .decodingJSONLD(let url, let jsonLD):
      return "Impossible to decode JSON+LD for url \(url):\n\(jsonLD)\n"
    }
  }
}

public final class RecipeWorker {

  /// Adds a recipe from an URL
  /// - note: Will parse contents of this URL synchronously.
  ///         execute it in a background thread
  ///
  /// - parameter url: the website content URL to add
  ///
  /// - throws: parsing or download errors
  public static func add(from url: URL) throws {

    let html = try String(contentsOf: url)
    let document = try SwiftSoup.parse(html)

    // this will look for every <script type="*ld+json"> (<script type="application/ld+json"> in our case)
    let elements = try document.select("script[type$=ld+json]")
                               .filter({ $0.data().contains("\"@type\":\"Recipe\"") })

    // first parsed is commonly about the content itself
    guard let jsonLD = elements.first?.data().unescaped else {
      log.warning("No JSON+LD found for url: \(url)")
      throw RecipeWorkerError.noJSONLD(url: url)
    }

    guard let data = jsonLD.data(using: .utf8) else {
      log.warning("Unable to decode JSON+LD data using utf8 for url: \(url)")
      throw RecipeWorkerError.decodingJSONLD(url: url, jsonLD: jsonLD)
    }

    var recipeData: RecipeJSON = try unbox(data: data)
    if recipeData.url == nil {
      recipeData.url = url.absoluteString
    }

    try Recipe.add(recipeData.recipe)
  }
}

struct RecipeJSON: Decodable, Unboxable {
  var name: String?
  var url: String?
  var image: String?

  init(unboxer: Unboxer) throws {
    name = unboxer.unbox(key: "name")
    url = unboxer.unbox(key: "url")
    image = unboxer.unbox(key: "image")
    if image == nil {
      image = unboxer.unbox(keyPath: "image.url")
    }
  }

  var recipe: Recipe {

    let recipe = Recipe()
    recipe.url = url ?? ""
    recipe.image = image
    recipe.name = name

    return recipe
  }
}

extension String {
  var unescaped: String {
    let entities = ["\0", "\t", "\n", "\r", "\"", "\'", "\\"]
    var current = self
    for entity in entities {
      let descriptionCharacters = entity.debugDescription.dropFirst().dropLast()
      let description = String(descriptionCharacters)
      current = current.replacingOccurrences(of: description, with: entity)
    }
    return current
  }
}
