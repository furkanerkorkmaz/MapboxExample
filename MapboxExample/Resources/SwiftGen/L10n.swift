// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Continue
  internal static let continueButtonTitle = L10n.tr("Localization", "continueButtonTitle")
  /// Error
  internal static let errorAlertTitle = L10n.tr("Localization", "errorAlertTitle")
  /// Invalid JSON
  internal static let invalidJSONError = L10n.tr("Localization", "invalidJSONError")
  /// Invalid request
  internal static let invalidRequest = L10n.tr("Localization", "invalidRequest")
  /// Error while getting location
  internal static let locationCantBeFetched = L10n.tr("Localization", "locationCantBeFetched")
  /// Please allow MapboxExample to use your location when using
  internal static let locationDisabledError = L10n.tr("Localization", "locationDisabledError")
  /// Maximum coordinates number is reached, please remove unused coordinates at first
  internal static let maxCoordinatesNumberReachedError = L10n.tr("Localization", "maxCoordinatesNumberReachedError")
  /// Save
  internal static let saveButtonTitle = L10n.tr("Localization", "saveButtonTitle")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
