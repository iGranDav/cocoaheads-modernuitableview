//
//  RecipeDetailViewController.swift
//  DemoTableView
//
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import DemoTableViewCore
import RealmSwift
import SwiftDate

final class TaskDetailViewController: UITableViewController {

  // MARK: - Structure

  private struct Section {
    var title: String?
    var rows: [Row]
  }

  private enum Row {
    case editable(text: String?, placeholder: String?)
  }

  // MARK: - Members

  var task: Task? {
    didSet {
      title = task?.name

      if isViewLoaded {
        configureView()
      }
    }
  }

  private var sections: [Section] = []

  // MARK: - Setup

  static func make(task: Task) -> TaskDetailViewController {
    let detailsVC = StoryboardScene.Listing.taskDetailViewController.instantiate()
    detailsVC.task = task

    return detailsVC
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftItemsSupplementBackButton = true
    navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem

    tableView.register(cellType: EditableCell.self)

    configureView()
  }

  private func configureView() {

    guard let task = task else {
      return
    }

    var sections = [Section]()

    //name
    sections.append(Section(title: L10n.taskNameTitle,
                            rows:
      [
        .editable(text: task.name, placeholder: L10n.taskNamePlaceholder)
      ])
    )

    self.sections = sections
    self.tableView.reloadData()
  }

  // MARK: - Actions

}

// MARK: - UITableViewDataSource
extension TaskDetailViewController {

  override func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].rows.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let row = sections[indexPath.section].rows[indexPath.row]

    switch row {
    case .editable(let text, let placeholder):
      let cell: EditableCell = tableView.dequeueReusableCell(for: indexPath)
      cell.textfield.placeholder = placeholder
      cell.textfield.text = text
      return cell

    }

  }

  private func textCell(in tableView: UITableView,
                        at indexPath: IndexPath,
                        text: String?,
                        details: String?,
                        accessoryView: UIView? = nil) -> TextCell {

    let cell: TextCell = tableView.dequeueReusableCell(for: indexPath)
    cell.textLabel?.text = text
    cell.textLabel?.textColor = UIColor.black
    cell.detailTextLabel?.text = details
    cell.accessoryView = accessoryView
    return cell
  }

}

// MARK: - UITableViewDelegate
extension TaskDetailViewController {

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].title
  }

}
