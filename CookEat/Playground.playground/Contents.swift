//: Playground - noun: a place where people can play

import UIKit
import SwiftSoup

do {
  let html = try String(contentsOf: URL(string: "http://www.marmiton.org/recettes/recette_gateau-de-crepes-facon-cheesecake-a-la-confiture-de-chataigne-a-la-vanille_349510.aspx") ?? URL(fileURLWithPath: ""))
  let document = try SwiftSoup.parse(html)

  // this will look for every <script type="*ld+json"> (<script type="application/ld+json"> in our case)
  let elements = try document.select("script[type$=ld+json]")

  // first parsed is commonly about the content itself
  let jsonLD: [DataNode] = elements.first()?.dataNodes() ?? []

} catch {
  print(error)
}
