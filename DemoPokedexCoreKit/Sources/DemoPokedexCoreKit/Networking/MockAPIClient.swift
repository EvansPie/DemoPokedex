//
//  Untitled.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

public class MockAPIClient: APIClientProtocol, @unchecked Sendable {
    
    let data: Data?
    let error: Error?
    let networkDelay: TimeInterval
    
    public init(data: Data?, error: Error?, networkDelay: TimeInterval = 0.2) {
        self.data = data
        self.error = error
        self.networkDelay = networkDelay
    }
    
    public func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type
    ) async throws -> T {
        try await Task.sleep(nanoseconds: UInt64(networkDelay * 1_000_000_000))
        
        if let error {
            throw error
            
        } else if let data {
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                return decodedResponse
            } catch {
                throw error
            }
        } else {
            fatalError("Provide at least one of `data` or `error`")
        }
    }
    
    public func request<T: Decodable & Sendable>(
        endpoint: any APIEndpoint,
        responseType: T.Type,
        completion: @escaping @Sendable (Result<T, any Error>) -> Void
    ) {
        if (data == nil && error == nil) {
            fatalError("Provide at least one of `data` or `error`")
        }
        
        if let error {
            Timer.scheduledTimer(withTimeInterval: networkDelay, repeats: false) { _ in
                completion(.failure(error))
            }
            
        } else if let data {
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                Timer.scheduledTimer(withTimeInterval: networkDelay, repeats: false) { _ in
                    completion(.success(decodedResponse))
                }
            } catch {
                Timer.scheduledTimer(withTimeInterval: networkDelay, repeats: false) { _ in
                    completion(.failure(error))
                }
            }
        }
        
    }
}
