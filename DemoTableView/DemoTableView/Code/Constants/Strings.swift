// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
internal enum L10n {
  /// DemoTableView
  internal static let appname = L10n.tr("Localizable", "appname")
  /// Add
  internal static let commonAdd = L10n.tr("Localizable", "common.add")
  /// Cancel
  internal static let commonCancel = L10n.tr("Localizable", "common.cancel")
  /// Ok
  internal static let commonOk = L10n.tr("Localizable", "common.ok")
  /// Your tasks
  internal static let listingTitle = L10n.tr("Localizable", "listing.title")
  /// Here is a turkey
  internal static let listingEmptyDescription = L10n.tr("Localizable", "listing.empty.description")
  /// Congratulations!
  internal static let listingEmptyTitle = L10n.tr("Localizable", "listing.empty.title")
  /// Something happened
  internal static let listingErrorTitle = L10n.tr("Localizable", "listing.error.title")
  /// Delete this task
  internal static let taskDelete = L10n.tr("Localizable", "task.delete")
  /// Add a task
  internal static let taskAddTitle = L10n.tr("Localizable", "task.add.title")
  /// Alarm
  internal static let taskDateAlarm = L10n.tr("Localizable", "task.date.alarm")
  /// Please notify me
  internal static let taskDateAsk = L10n.tr("Localizable", "task.date.ask")
  /// just now
  internal static let taskDateNow = L10n.tr("Localizable", "task.date.now")
  /// Due date
  internal static let taskDateTitle = L10n.tr("Localizable", "task.date.title")
  /// Thing to do
  internal static let taskNamePlaceholder = L10n.tr("Localizable", "task.name.placeholder")
  /// Name
  internal static let taskNameTitle = L10n.tr("Localizable", "task.name.title")
  /// Notes
  internal static let taskNotesTitle = L10n.tr("Localizable", "task.notes.title")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
