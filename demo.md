
Present the project structure, build & run as empty.

Then start with the state

```
/// Current controller state
enum State {
  case empty
  case data(Results<Task>)
  case error(Error)
}

private var state: State = .empty {
  didSet {
    updateState()
  }
}

```

```
private lazy var placeholderView: PlaceholderView = { return PlaceholderView.loadFromNib() }()
```

```
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
```

Then build & run

in viewDidLoad / refresh

```
let tasks = Realm.ex.safeInstance().objects(Task.self).sorted(byKeyPath: #keyPath(Task.dateCreated),
                                                                  ascending: false)
state = tasks.isEmpty ? .empty : .data(tasks)
```

```
tableView.register(cellType: TaskCell.self)
```

DataSource

```
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard case .data(let tasks) = state else { return 0 }

    return tasks.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    guard case .data(let tasks) = state else { fatalError("Cannot fill any cell without data") }

    let cell: TaskCell = tableView.dequeueReusableCell(for: indexPath)

    let task = tasks[indexPath.row]
    cell.infoLabel.text = task.name

    return cell
  }
```

UITableViewDelegate

```
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
```

Then build & run

Add task

```
let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                    target: self,
                                    action: #selector(insertNewObject(_:)))
navigationItem.rightBarButtonItem = addButton
```

```
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

      //create the task

    }))

    self.present(alert, animated: true, completion: nil)
  }
```

```
do {
  try Task.add(name: name)
} catch {
  self.state = .error(error)
}
```

```
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
```

```
private var tasksToken: NotificationToken?
```

```
deinit {
  tasksToken?.invalidate()
  tasksToken = nil
}
```

Enrich the cell

```
  let currentFont = cell.infoLabel.font ?? UIFont.preferredFont(forTextStyle: .body)
  let striketroughStyle: NSUnderlineStyle = task.completed ? .styleThick : .styleNone
  let text = NSMutableAttributedString(string: task.name ?? "",
                                         attributes: [.strikethroughStyle: striketroughStyle.rawValue])

  cell.completedButton.isSelected = task.completed
  cell.completedButton.addTarget(self, action: #selector(toggleTaskState(_:)), for: .touchUpInside)
  cell.infoLabel.attributedText = text
```

```
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
```

Then build & run | demo the add / remove etc... cool !

```
cell.textfield.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
cell.textfield.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingDidEnd)
```

```
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
```

Build & run demo the update

Add date now

```
tableView.register(cellType: TextCell.self)
tableView.register(cellType: DatePickerCell.self)
```

```
case text(title: String?, details: String?)
case `switch`(text: String, isOn: Bool)
case date(title: String, date: Date)
case datePicker(date: Date)
```

```
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
```

```
    case .text(let title, let details):
      return textCell(in: tableView, at: indexPath, text: title, details: details)

    case .switch(let text, let isOn):
      let `switch` = UISwitch(frame: .zero)
      `switch`.isOn = isOn
      `switch`.addTarget(self, action: #selector(toggleSwitch(_:)), for: .valueChanged)

      return textCell(in: tableView, at: indexPath, text: text, details: nil, accessoryView: `switch`)

    case .date(let title, let date):
      let details = date.string(dateStyle: .short, timeStyle: .short, in: nil)

      return textCell(in: tableView, at: indexPath, text: title, details: details)

    case .datePicker(let date):
      let cell: DatePickerCell = tableView.dequeueReusableCell(for: indexPath)
      cell.datePicker.date = date
      cell.datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
      return cell
```

```
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
```

```
    let row = sections[indexPath.section].rows[indexPath.row]

    switch row {
    case .date:
      toggleDatePicker(onSection: indexPath.section)
    default:
      break
    }
```

```
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
```

```
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
```

```
    if let dueDate = task.dueDate, !task.completed {
      text.append(NSAttributedString(
        string: "\n\(dueDate.colloquialSinceNow() ?? "")",
        attributes: [.foregroundColor: UIColor.gray,
                     .font: currentFont.withSize(currentFont.pointSize - 2)])
      )
    }
```

Build & run demo the update

```
tableView.register(cellType: NotesCell.self)
```

```
case notes(text: String?)
case delete
```

```
  //notes
  sections.append(Section(title: L10n.taskNotesTitle, rows: [.notes(text: task.notes)] ))

  //delete
  sections.append(Section(title: nil, rows: [.delete] ))
```

```
    case .notes(let text):
      let cell: NotesCell = tableView.dequeueReusableCell(for: indexPath)
      cell.textview.text = text
      cell.textview.delegate = self
      return cell

    case .delete:
      let cell = textCell(in: tableView, at: indexPath, text: L10n.taskDelete, details: nil)
      cell.textLabel?.textColor = UIColor.red
      return cell
```

```
case .delete:
  try? task?.delete()
  navigationController?.navigationController?.popViewController(animated: true)
```

```
extension TaskDetailViewController: UITextViewDelegate {

  func textViewDidEndEditing(_ textView: UITextView) {

    let realm = Realm.ex.safeInstance()
    try? realm.write {
      task?.notes = textView.text
    }
  }
}
```

```
if let notes = task.notes, !notes.isEmpty {

  text.append(NSAttributedString(
        string: "\n\(notes)",
        attributes: [.foregroundColor: UIColor.lightGray,
                     .font: currentFont.withSize(currentFont.pointSize - 3)])
      )
  }
```

Then demo it and demo the label number of line on tap
