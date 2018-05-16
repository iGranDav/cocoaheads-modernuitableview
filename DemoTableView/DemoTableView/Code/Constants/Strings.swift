// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable identifier_name line_length type_body_length
enum L10n {
  /// DemoTableView
  static let appname = L10n.tr("Localizable", "appname")
  /// Add
  static let commonAdd = L10n.tr("Localizable", "common.add")
  /// Cancel
  static let commonCancel = L10n.tr("Localizable", "common.cancel")
  /// Ok
  static let commonOk = L10n.tr("Localizable", "common.ok")
  /// Your tasks
  static let listingTitle = L10n.tr("Localizable", "listing.title")
  /// Here is a turkey
  static let listingEmptyDescription = L10n.tr("Localizable", "listing.empty.description")
  /// Congratulations!
  static let listingEmptyTitle = L10n.tr("Localizable", "listing.empty.title")
  /// Something happened
  static let listingErrorTitle = L10n.tr("Localizable", "listing.error.title")
  /// Delete this task
  static let taskDelete = L10n.tr("Localizable", "task.delete")
  /// Add a task
  static let taskAddTitle = L10n.tr("Localizable", "task.add.title")
  /// Alarm
  static let taskDateAlarm = L10n.tr("Localizable", "task.date.alarm")
  /// Please notify me
  static let taskDateAsk = L10n.tr("Localizable", "task.date.ask")
  /// just now
  static let taskDateNow = L10n.tr("Localizable", "task.date.now")
  /// Due date
  static let taskDateTitle = L10n.tr("Localizable", "task.date.title")
  /// Thing to do
  static let taskNamePlaceholder = L10n.tr("Localizable", "task.name.placeholder")
  /// Name
  static let taskNameTitle = L10n.tr("Localizable", "task.name.title")
  /// Notes
  static let taskNotesTitle = L10n.tr("Localizable", "task.notes.title")
}
// swiftlint:enable identifier_name line_length type_body_length

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
