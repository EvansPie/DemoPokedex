//
//  CustomError.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

/// All `CustomError` errors will have a `code`, a `description` (and `localizedDescription),
/// and optionally a `recoverySuggestion` to show to the user (i.e. we could do something like if there
/// is a `recoverySuggestion` show an alert to the user, otherwise fail silently)
///
public protocol CustomError: Error, CustomStringConvertible {
    var code: String { get }
    var recoverySuggestion: String? { get }
}
