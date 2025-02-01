//
//  NetworkError.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

public enum NetworkError: CustomError {
    
    case invalidURL(url: String)
    case invalidURLResponse(url: String)
    case noInternetConnection // ✨ Map to NSURLError (-1009   NSURLErrorNotConnectedToInternet)
    case timeout(url: String)
    case noData(url: String)
    
    public var code: String {
        switch self {
        case .invalidURL:
            return "network-invalid-url"
        case .invalidURLResponse:
            return "network-invalid-url-response"
        case .noInternetConnection:
            return "network-no-internet"
        case .timeout:
            return "network-timeout"
        case .noData:
            return "network-no-data"
        }
    }
    
    public var description: String {
        switch self {
        case .invalidURL(let url):
            return "[\(code)] The URL \(url) is not valid."
        case .invalidURLResponse(let url):
            return "[\(code)] The URL \(url) received an invalid http URL response."
        case .noInternetConnection:
            return "[\(code)] There isn't an active Internet connection."
        case .timeout(let url):
            return "[\(code)] The request on \(url) timed out."
        case .noData(let url):
            return "[\(code)] The request on \(url) didn't return any data."
        }
    }
    
    /// There isn't much that the user could do in all cases, except the "no internet connection" case where they
    /// might have airplane mode (or any generic issue with their connection)
    public var recoverySuggestion: String? {
        switch self {
        case .timeout:
            return "Please check your Internet connection."
        default:
            return nil
        }
    }
}
