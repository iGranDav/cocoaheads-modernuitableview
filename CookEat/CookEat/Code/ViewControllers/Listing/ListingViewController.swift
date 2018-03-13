//
//  ListingViewController.swift
//  CookEat
//
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import RealmSwift
import Extra
import SwiftDate
import CookEatCore

class ListingViewController: UITableViewController {

  // MARK: - Members

  var recipes = Realm.ex.safeInstance().objects(Recipe.self).sorted(byKeyPath: #keyPath(Recipe.dateModified))
  private var recipesToken: NotificationToken?

  // MARK: - Setup

  override func viewDidLoad() {
    super.viewDidLoad()
    title = L10n.listingTitle
    navigationItem.leftBarButtonItem = editButtonItem

    let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                    target: self,
                                    action: #selector(insertNewObject(_:)))
    navigationItem.rightBarButtonItem = addButton

    recipesToken = recipes.observe { changes in

      switch changes {
      case .initial:
        self.tableView.reloadData()
      case .update(_, let deletions, let insertions, let modifications):
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: deletions.flatMap { IndexPath(row: $0, section: 0) }, with: .automatic)
        self.tableView.insertRows(at: insertions.flatMap { IndexPath(row: $0, section: 0) }, with: .automatic)
        self.tableView.reloadRows(at: modifications.flatMap { IndexPath(row: $0, section: 0) }, with: .automatic)
        self.tableView.endUpdates()
      case .error(let error):
        log.error("An error occured during update: \(error)")
      }
    }

  }

  deinit {
    recipesToken?.invalidate()
    recipesToken = nil
  }

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
    super.viewWillAppear(animated)
  }

  @objc
  func insertNewObject(_ sender: Any) {

    let alert = UIAlertController(title: "Ajout d'une recette",
                                  message: "Donnez-nous juste un lien vers la recette en ligne.",
                                  preferredStyle: .alert)
    alert.addTextField { textField in
      textField.placeholder = "Url"
    }
    alert.addAction(UIAlertAction(title: L10n.commonCancel, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Ajouter", style: .default, handler: { _ in

      let url = alert.textFields?.first?.text ?? ""

      if let validUrl = URL(string: url) {
        do {
          try RecipeWorker.add(from: validUrl)
        } catch {
          log.error("Impossible to create recipe: \(error)")
        }
      } else {
        let alertInvalid = UIAlertController(title: "URL invalide",
                                             message: "Veuillez entrer une URL valide",
                                             preferredStyle: .alert)
        alertInvalid.addAction(UIAlertAction(title: L10n.commonOk, style: .default, handler: nil))
        self.present(alertInvalid, animated: true, completion: nil)
      }
    }))

    self.present(alert, animated: true, completion: nil)
  }

}

// MARK: - UITableViewDataSource
extension ListingViewController {

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recipes.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

    let recipe = recipes[indexPath.row]
    let date = DateInRegion(absoluteDate: recipe.dateCreated)

    cell.textLabel?.text = recipe.name ?? "no name yet"
    cell.detailTextLabel?.text = date.colloquialSinceNow()
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ListingViewController {

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let recipe = recipes[indexPath.row]

    let details = RecipeDetailViewController.make(recipe: recipe)
    let navVC = UINavigationController(rootViewController: details)

    splitViewController?.showDetailViewController(navVC, sender: self)
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCellEditingStyle,
                          forRowAt indexPath: IndexPath) {

    if editingStyle == .delete {
      let recipe = recipes[indexPath.row]
      try? recipe.delete()
    }
  }
}
