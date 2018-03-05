// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable identifier_name line_length type_body_length
enum L10n {
  /// CookEat
  static let appname = L10n.tr("Localizable", "appname")
  /// Cancel
  static let commonCancel = L10n.tr("Localizable", "common.cancel")
  /// Ok
  static let commonOk = L10n.tr("Localizable", "common.ok")
  /// Your recipes
  static let listingTitle = L10n.tr("Localizable", "listing.title")
}
// swiftlint:enable identifier_name line_length type_body_length

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
