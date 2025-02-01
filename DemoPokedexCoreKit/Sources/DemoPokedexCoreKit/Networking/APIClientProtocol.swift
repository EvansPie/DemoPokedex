//
//  Untitled.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

/// `APIClientProtocol` assumes that we might need both ways (`callbacks` or `async/await`) in our app
public protocol APIClientProtocol {
        
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
