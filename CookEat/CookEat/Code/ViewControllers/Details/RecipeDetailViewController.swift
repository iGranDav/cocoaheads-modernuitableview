//
//  RecipeDetailViewController.swift
//  CookEat
//
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import CookEatCore

class RecipeDetailViewController: UIViewController {

  // MARK: - Members

  @IBOutlet weak var detailDescriptionLabel: UILabel!

  var recipe: Recipe? {
    didSet {
      if isViewLoaded {
        configureView()
      }
    }
  }

  // MARK: - Setup

  static func make(recipe: Recipe) -> RecipeDetailViewController {
    let vc = StoryboardScene.Listing.recipeDetailViewController.instantiate()
    vc.recipe = recipe

    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftItemsSupplementBackButton = true
    navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem

    configureView()
  }

  func configureView() {

    guard let recipe = recipe else {
      return
    }

    detailDescriptionLabel.text = "\(recipe.name ?? "")\n\n\(recipe.url)"
  }

}
