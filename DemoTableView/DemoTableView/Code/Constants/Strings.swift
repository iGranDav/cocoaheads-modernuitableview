// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable identifier_name line_length type_body_length
enum L10n {
  /// DemoTableView
  static let appname = L10n.tr("Localizable", "appname")
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
  /// Something happened 😣
  static let listingErrorTitle = L10n.tr("Localizable", "listing.error.title")
}
// swiftlint:enable identifier_name line_length type_body_length

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
