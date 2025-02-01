//
//  ServerError.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

/// Assuming that the server send back errors like:
/// {
///     error: {
///         code: "error-code",
///         message: "API call failed",
///         recoverySuggestion: "Some advice so that the user can solve the use, e.g. login first"
///     }
/// }

struct ServerErrorResponse: Codable {
    let error: ServerError
}

struct ServerError: Codable, Error {
    let code: String
    let message: String?
    let recoverySuggestion: String?
}
