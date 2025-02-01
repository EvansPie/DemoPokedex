//
//  APIEndpoint.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

public protocol APIEndpoint {
    
    var baseURL: URL { get }
    var apiVersion: String? { get}
    var path: String? { get }
    var method: APIMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: String]? { get }
    var body: Data? { get }
}

public enum APIMethod: String {
    
    case get = "GET"
    case post = "POST"
}
