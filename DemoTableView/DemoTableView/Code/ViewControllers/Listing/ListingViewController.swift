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

  /// Current controller state
  enum State {
    case empty
    case data(Results<Task>)
    case error(Error)
  }

  // MARK: - Members

  private lazy var placeholderView: PlaceholderView = { return PlaceholderView.loadFromNib() }()
  private var state: State = .empty {
    didSet {
      updateState()
    }
  }

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

    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: #selector(reloadData), for: .allEvents)

    tableView.register(cellType: TaskCell.self)

    let tasks = Realm.ex.safeInstance().objects(Task.self).sorted(byKeyPath: #keyPath(Task.dateCreated),
                                                                  ascending: false)
    state = tasks.isEmpty ? .empty : .data(tasks)
    tasksToken = tasks.observe { changes in

      switch changes {
      case .initial(let values):
        self.state = values.isEmpty ? .empty : .data(values)
        self.tableView.reloadData()

      case .update(let values, let deletions, let insertions, let modifications):
        self.state = values.isEmpty ? .empty : .data(values)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: deletions.compactMap { IndexPath(row: $0, section: 0) }, with: .automatic)
        self.tableView.insertRows(at: insertions.compactMap { IndexPath(row: $0, section: 0) }, with: .automatic)
        self.tableView.reloadRows(at: modifications.compactMap { IndexPath(row: $0, section: 0) }, with: .automatic)
        self.tableView.endUpdates()

      case .error(let error):
        log.error("An error occured during update: \(error)")
        self.state = .error(error)
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

  // MARK: - Actions

  @objc
  func insertNewObject(_ sender: Any) {

    let alert = UIAlertController(title: L10n.taskAddTitle,
                                  message: nil,
                                  preferredStyle: .alert)
    alert.addTextField { textField in
      textField.placeholder = L10n.taskNamePlaceholder
    }
    alert.addAction(UIAlertAction(title: L10n.commonCancel, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: L10n.commonAdd, style: .default, handler: { _ in

      let name = alert.textFields?.first?.text ?? ""

      do {
        try Task.add(name: name)
      } catch {
        self.state = .error(error)
      }

    }))

    self.present(alert, animated: true, completion: nil)
  }

  @objc
  private func reloadData() {

    if refreshControl?.isRefreshing == false {
      refreshControl?.beginRefreshing()
    }

    let tasks = Realm.ex.safeInstance().objects(Task.self).sorted(byKeyPath: #keyPath(Task.dateModified))
    state = tasks.isEmpty ? .empty : .data(tasks)

    refreshControl?.endRefreshing()
  }

  /// Update listing state
  private func updateState() {

    var plState: PlaceholderView.State?

    switch state {
    case .empty:
      plState = PlaceholderView.State(emotion: "🦃",
                                      title: L10n.listingEmptyTitle,
                                      details: L10n.listingEmptyDescription)
    case .data:
      break
    case .error(let error):
      plState = PlaceholderView.State(emotion: "😣",
                                      title: L10n.listingErrorTitle,
                                      details: error.localizedDescription)
    }

    if let plState = plState {
      placeholderView.state = plState
      placeholderView.frame = tableView.bounds
      tableView.tableHeaderView = placeholderView
      tableView.isScrollEnabled = false
    } else {
      tableView.tableHeaderView = nil
      tableView.isScrollEnabled = true
    }

  }

  @objc
  private func toggleTaskState(_ sender: UIButton) {

    guard case .data(let tasks) = state else { return }

    let center = tableView.convert(sender.center, from: sender.superview)
    guard let idx = tableView.indexPathForRow(at: center) else { return }

    let task = tasks[idx.row]

    do {
      let realm = Realm.ex.safeInstance()
      try realm.write {
        task.completed = !sender.isSelected
      }
    } catch {
      state = .error(error)
    }

  }

}

// MARK: - UITableViewDataSource
extension ListingViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard case .data(let tasks) = state else { return 0 }

    return tasks.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    guard case .data(let tasks) = state else { fatalError("Cannot fill any cell without data") }

    let cell: TaskCell = tableView.dequeueReusableCell(for: indexPath)

    let task = tasks[indexPath.row]

    let currentFont = cell.infoLabel.font ?? UIFont.preferredFont(forTextStyle: .body)
    let striketroughStyle: NSUnderlineStyle = task.completed ? .styleThick : .styleNone
    let text = NSMutableAttributedString(string: task.name ?? "",
                                         attributes: [.strikethroughStyle: striketroughStyle.rawValue])

    if let dueDate = task.dueDate, !task.completed {
      text.append(NSAttributedString(
        string: "\n\(dueDate.colloquialSinceNow() ?? "")",
        attributes: [.foregroundColor: UIColor.gray,
                     .font: currentFont.withSize(currentFont.pointSize - 2)])
      )
    }

    if let notes = task.notes, !notes.isEmpty {

      text.append(NSAttributedString(
        string: "\n\(notes)",
        attributes: [.foregroundColor: UIColor.lightGray,
                     .font: currentFont.withSize(currentFont.pointSize - 3)])
      )
    }

    cell.completedButton.isSelected = task.completed
    cell.completedButton.addTarget(self, action: #selector(toggleTaskState(_:)), for: .touchUpInside)
    cell.infoLabel.attributedText = text

    return cell
  }
}

// MARK: - UITableViewDelegate
extension ListingViewController {

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard case .data(let tasks) = state else { return }

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

    guard case .data(let tasks) = state else { return }

    if editingStyle == .delete {
      let task = tasks[indexPath.row]
      try? task.delete()
    }
  }
}
