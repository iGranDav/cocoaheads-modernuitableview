//
//  RecipeDetailViewController.swift
//  DemoTableView
//
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import DemoTableViewCore
import Kingfisher

class TaskDetailViewController: UIViewController {

  // MARK: - Members

  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var detailDescriptionLabel: UILabel!

  var task: Task? {
    didSet {
      if isViewLoaded {
        configureView()
      }
    }
  }

  // MARK: - Setup

  static func make(task: Task) -> TaskDetailViewController {
    let detailsVC = StoryboardScene.Listing.recipeDetailViewController.instantiate()
    detailsVC.task = task

    return detailsVC
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftItemsSupplementBackButton = true
    navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem

    configureView()
  }

  func configureView() {

    guard let task = task else {
      return
    }

    detailDescriptionLabel.text = "\(task.name ?? "")"

    if let image = task.image, let url = URL(string: image) {
      photoImageView.kf.setImage(with: url)
    }
  }

}
