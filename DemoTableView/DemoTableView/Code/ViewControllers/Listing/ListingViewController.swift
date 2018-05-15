//
//  ListingViewController.swift
//  DemoTableView
//
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import RealmSwift
import Extra
import SwiftDate
import DemoTableViewCore

class ListingViewController: UITableViewController {

  // MARK: - Members

  var tasks = Realm.ex.safeInstance().objects(Task.self).sorted(byKeyPath: #keyPath(Task.dateModified))
  private var tasksToken: NotificationToken?

  // MARK: - Setup

  override func viewDidLoad() {
    super.viewDidLoad()
    title = L10n.listingTitle
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.leftBarButtonItem = editButtonItem

    let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                    target: self,
                                    action: #selector(insertNewObject(_:)))
    navigationItem.rightBarButtonItem = addButton

    tasksToken = tasks.observe { changes in

      switch changes {
      case .initial:
        self.tableView.reloadData()
      case .update(_, let deletions, let insertions, let modifications):
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: deletions.compactMap { IndexPath(row: $0, section: 0) }, with: .automatic)
        self.tableView.insertRows(at: insertions.compactMap { IndexPath(row: $0, section: 0) }, with: .automatic)
        self.tableView.reloadRows(at: modifications.compactMap { IndexPath(row: $0, section: 0) }, with: .automatic)
        self.tableView.endUpdates()
      case .error(let error):
        log.error("An error occured during update: \(error)")
      }
    }

  }

  deinit {
    tasksToken?.invalidate()
    tasksToken = nil
  }

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
    super.viewWillAppear(animated)
  }

  @objc
  func insertNewObject(_ sender: Any) {

  }

}

// MARK: - UITableViewDataSource
extension ListingViewController {

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

    let recipe = tasks[indexPath.row]
    let date = DateInRegion(absoluteDate: recipe.dateCreated)

    cell.textLabel?.text = recipe.name ?? "no name yet"
    cell.detailTextLabel?.text = date.colloquialSinceNow()

    if let image = recipe.image, let url = URL(string: image) {
      cell.imageView?.kf.setImage(with: url)
    }

    return cell
  }
}

// MARK: - UITableViewDelegate
extension ListingViewController {

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let task = tasks[indexPath.row]

    let details = TaskDetailViewController.make(task: task)
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
      let task = tasks[indexPath.row]
      try? task.delete()
    }
  }
}
