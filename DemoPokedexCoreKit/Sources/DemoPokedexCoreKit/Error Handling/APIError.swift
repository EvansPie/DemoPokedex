//
//  APIError.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

enum APIError: CustomError {
    
    case requestFailed(error: Error?)
    case unauthorized(url: String)
    case forbidden(url: String)
    case notFound(url: String)
    case clientError(url: String, statusCode: Int, serverMessage: String?, serverRecoverySuggestion: String?)
    case serverError(url: String, statusCode: Int, serverMessage: String?, serverRecoverySuggestion: String?)
    case unknown(String?)
    
    var code: String {
        switch self {
        case .requestFailed:
            return "api-request-failed"
        case .unauthorized:
            return "api-unauthorized"
        case .forbidden:
            return "api-forbidden"
        case .notFound:
            return "api-not-found"
        case .clientError(_, let statusCode, _, _):
            return "api-client-error-\(statusCode)"
        case .serverError(_, let statusCode, _, _):
            return "api-server-error-\(statusCode)"
        case .unknown:
            return "api-unknown"
        }
    }
    
    var description: String {
        switch self {
        case .requestFailed(let err):
            return "[\(code)] The request failed with error: \(err?.localizedDescription ?? "Unknown error")"
        case .unauthorized(let url):
            return "[\(code)] Unauthorized request to \(url). Please check your credentials."
        case .forbidden(let url):
            return "[\(code)] Access to the requested resource (\(url)) is forbidden."
        case .notFound:
            return "[\(code)] The requested resource was not found."
        case .clientError(let url, let statusCode, let serverMessage, _):
            var msg = "[\(code)] Received status code \(statusCode) on \(url)"
            
            if serverMessage != nil {
                msg += "\nMessage: \(serverMessage!)"
            }
            return msg
        case .serverError(let url, let statusCode, let serverMessage, _):
            var msg = "[\(code)] Received status code \(statusCode) on \(url)"
            
            if let serverMessage {
                msg += "\nMessage: \(serverMessage)"
            }
            return msg
        case .unknown(let message):
            return "[\(code)] An unknown error occurred\(message != nil ? message! : "")"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .requestFailed(let err):
            return (err as NSError?)?.localizedRecoverySuggestion
        case .unauthorized:
            return "Please login first"
        case .forbidden:
            return nil
        case .notFound:
            return nil
        case .clientError(_, _, _, let serverRecoverySuggestion),
                .serverError(_, _, _, let serverRecoverySuggestion):
            return serverRecoverySuggestion
        case .unknown:
            return nil
        }
    }
}
