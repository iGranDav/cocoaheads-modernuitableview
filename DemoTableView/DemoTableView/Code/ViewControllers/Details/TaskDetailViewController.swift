//
//  RecipeDetailViewController.swift
//  DemoTableView
//
//  Copyright © 2018 Harpp. All rights reserved.
//

import UIKit
import DemoTableViewCore
import Kingfisher
import RealmSwift

class TaskDetailViewController: UITableViewController {

  // MARK: - Structure

  private struct Section {
    var title: String?
    var rows: [Row]
  }

  private enum Row {
    case text(title: String?, details: String?)
    case editable(text: String?, placeholder: String?)
//    case `switch`(text: String, on: Bool)
//    case datePicker(date: Date)
//    case notes(text: String)
  }

  // MARK: - Members

  private lazy var photoImageView: UIImageView = {
    return UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 120))
  }()

  var task: Task? {
    didSet {
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

    tableView.register(cellType: TextCell.self)
    tableView.register(cellType: EditableCell.self)

    configureView()
  }

  private func configureView() {

    guard let task = task else {
      return
    }

    title = task.name

    if let image = task.image, let url = URL(string: image) {
      photoImageView.kf.setImage(with: url)
      tableView.tableHeaderView = photoImageView
    }

    var sections = [Section]()

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

  @objc
  private func editingChanged(_ sender: UITextField) {

    let center = tableView.convert(sender.center, from: sender.superview)
    guard let idx = tableView.indexPathForRow(at: center) else { return }

    let row = sections[idx.section].rows[idx.row]
    guard case .editable = row else { return }

    let realm = Realm.ex.safeInstance()
    try? realm.write {
      task?.name = sender.text
    }
  }

  @objc
  private func didEndEditing(_ sender: UITextField) {

    let center = tableView.convert(sender.center, from: sender.superview)
    guard let idx = tableView.indexPathForRow(at: center) else { return }

    let row = sections[idx.section].rows[idx.row]
    guard case .editable = row else { return }

    title = sender.text
  }

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
    case .text(let title, let details):
      let cell: TextCell = tableView.dequeueReusableCell(for: indexPath)
      cell.textLabel?.text = title
      cell.detailTextLabel?.text = details
      return cell
    case .editable(let text, let placeholder):
      let cell: EditableCell = tableView.dequeueReusableCell(for: indexPath)
      cell.textfield.placeholder = placeholder
      cell.textfield.text = text
      cell.textfield.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
      cell.textfield.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingDidEnd)
      return cell
//    case .switch(let text, let on):
//      <#code#>
//    case .datePicker(let date):
//      <#code#>
//    case .notes(let text):
//      <#code#>
    }

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
