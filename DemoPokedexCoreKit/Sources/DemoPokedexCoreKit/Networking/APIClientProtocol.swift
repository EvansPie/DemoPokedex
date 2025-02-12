//
//  Untitled.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

/// `APIClientProtocol` assumes that we might need both ways (`callbacks` or `async/await`) in our app
/// Conform it to `Sendable` since it's going to be passed as an input
public protocol APIClientProtocol: Sendable {
        
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    )
    
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type
    ) async throws -> T
}
