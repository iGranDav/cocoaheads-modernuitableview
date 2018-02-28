//: Playground - noun: a place where people can play

import UIKit
import SwiftSoup

var str = "Hello, playground"

do {
    let html = try String(contentsOf: URL(string: "http://www.marmiton.org/recettes/recette_gateau-de-crepes-facon-cheesecake-a-la-confiture-de-chataigne-a-la-vanille_349510.aspx") ?? URL(fileURLWithPath: ""))
    let doc: Document = try SwiftSoup.parse(html)
} catch {
    print(error)
}
