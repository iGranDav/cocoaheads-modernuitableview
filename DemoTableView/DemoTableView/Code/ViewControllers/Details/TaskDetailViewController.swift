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
import SwiftDate

final class TaskDetailViewController: UITableViewController {

  // MARK: - Structure

  private struct Section {
    var title: String?
    var rows: [Row]
  }

  private enum Row {
    case text(title: String?, details: String?)
    case editable(text: String?, placeholder: String?)
    case `switch`(text: String, isOn: Bool)
    case date(title: String, date: Date)
    case datePicker(date: Date)
    case notes(text: String?)
  }

  // MARK: - Members

  private lazy var photoImageView: UIImageView = {
    return UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 120))
  }()

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

    tableView.register(cellType: TextCell.self)
    tableView.register(cellType: EditableCell.self)
    tableView.register(cellType: DatePickerCell.self)
    tableView.register(cellType: NotesCell.self)

    configureView()
  }

  private func configureView() {

    guard let task = task else {
      return
    }

    if let image = task.image, let url = URL(string: image) {
      photoImageView.kf.setImage(with: url)
      tableView.tableHeaderView = photoImageView
    }

    var sections = [Section]()

    //name
    sections.append(Section(title: L10n.taskNameTitle,
                            rows:
      [
        .editable(text: task.name, placeholder: L10n.taskNamePlaceholder)
      ])
    )

    //date
    var dateSection = Section(title: L10n.taskDateTitle,
                              rows:
      [
        .switch(text: L10n.taskDateAsk, isOn: task.dueDate != nil)
      ])

    if let dueDate = task.dueDate {
      dateSection.rows.append(Row.date(title: L10n.taskDateAlarm, date: dueDate))
    }

    sections.append(dateSection)

    //notes
    sections.append(Section(title: L10n.taskNotesTitle, rows: [.notes(text: task.notes)] ))

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

  @objc
  private func toggleSwitch(_ sender: UISwitch) {

    let center = tableView.convert(sender.center, from: sender.superview)
    guard let idx = tableView.indexPathForRow(at: center) else { return }

    var section = sections[idx.section]

    if sender.isOn {
      section.rows.append(Row.date(title: L10n.taskDateAlarm, date: task?.dueDate ?? Date() ))
    } else {
      section.rows.removeLast(section.rows.count - 1)
    }

    if let row = section.rows.first, case .switch(let text, _) = row {
      section.rows[0] = .switch(text: text, isOn: sender.isOn)
    }
    sections[idx.section] = section

    tableView.reloadSections(IndexSet(integer: idx.section), with: .automatic)
  }

  private func toggleDatePicker(onSection sectionIdx: Int) {

    guard sectionIdx < sections.count else { return }

    tableView.beginUpdates()

    var section = sections[sectionIdx]
    if let row = section.rows.last, case .datePicker = row {
      tableView.deleteRows(at: [IndexPath(row: section.rows.count - 1, section: sectionIdx)],
                           with: .automatic)
      section.rows.removeLast()
    } else {
      section.rows.append(Row.datePicker(date: task?.dueDate ?? Date()))
      tableView.insertRows(at: [IndexPath(row: section.rows.count - 1, section: sectionIdx)],
                           with: .automatic)
    }

    sections[sectionIdx] = section
    tableView.endUpdates()
  }

  @objc
  private func datePickerChanged(_ sender: UIDatePicker) {

    let center = tableView.convert(sender.center, from: sender.superview)
    guard let idx = tableView.indexPathForRow(at: center) else { return }

    var section = sections[idx.section]
    section.rows[1] = Row.date(title: L10n.taskDateAlarm, date: sender.date)
    sections[idx.section] = section
    tableView.reloadRows(at: [IndexPath(row: 1, section: idx.section)], with: .none)

    let realm = Realm.ex.safeInstance()
    try? realm.write {
      task?.dueDate = sender.date
    }

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
      cell.accessoryView = nil
      return cell

    case .editable(let text, let placeholder):
      let cell: EditableCell = tableView.dequeueReusableCell(for: indexPath)
      cell.textfield.placeholder = placeholder
      cell.textfield.text = text
      cell.textfield.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
      cell.textfield.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingDidEnd)
      return cell

    case .switch(let text, let isOn):
      let cell: TextCell = tableView.dequeueReusableCell(for: indexPath)
      cell.textLabel?.text = text
      cell.detailTextLabel?.text = nil

      let `switch` = UISwitch(frame: .zero)
      `switch`.isOn = isOn
      `switch`.addTarget(self, action: #selector(toggleSwitch(_:)), for: .valueChanged)

      cell.accessoryView = `switch`
      return cell

    case .date(let title, let date):
      let details = date.string(dateStyle: .short, timeStyle: .short, in: nil)

      let cell: TextCell = tableView.dequeueReusableCell(for: indexPath)
      cell.textLabel?.text = title
      cell.detailTextLabel?.text = details
      cell.accessoryView = nil
      return cell

    case .datePicker(let date):
      let cell: DatePickerCell = tableView.dequeueReusableCell(for: indexPath)
      cell.datePicker.date = date
      cell.datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
      return cell

    case .notes(let text):
      let cell: NotesCell = tableView.dequeueReusableCell(for: indexPath)
      cell.textview.text = text
      cell.textview.delegate = self
      return cell
    }

  }
}

// MARK: - UITableViewDelegate
extension TaskDetailViewController {

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let row = sections[indexPath.section].rows[indexPath.row]

    switch row {
    case .date:
        toggleDatePicker(onSection: indexPath.section)
    default:
      break
    }

    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].title
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

    let row = sections[indexPath.section].rows[indexPath.row]

    switch row {
    case .datePicker:
      return 200
    default:
      return 50
    }

  }
}

extension TaskDetailViewController: UITextViewDelegate {

  func textViewDidEndEditing(_ textView: UITextView) {

    let realm = Realm.ex.safeInstance()
    try? realm.write {
      task?.notes = textView.text
    }
  }
}
