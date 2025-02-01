//
//  APIClient.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

public final class APIClient: APIClientProtocol, Sendable {
    
    private let session: URLSession
    
    /// Allow D.I. of the `URLSession`, even though the whole `APIClient` will be mocked
    /// for this challenge
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    ) {
        let urlStr = endpoint.baseURL.absoluteString + (endpoint.apiVersion ?? "") + (endpoint.path ?? "")
        guard var url = URL(string: urlStr) else {
            completion(.failure(NetworkError.invalidURL(url: urlStr)))
            return
        }
        
        // Add query parameters if present
        if let queryParameters = endpoint.queryParameters {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            url = components?.url ?? url
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body
        
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let strongSelf = self else {
                return
            }
            
            if let error = error {
                completion(.failure(APIError.requestFailed(error: error)))
                return
            }
            
            do {
                let response = try strongSelf.handleResponse(response, ofType: responseType, on: urlStr, data: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    public func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type
    ) async throws -> T {
        let urlStr = endpoint.baseURL.absoluteString + (endpoint.apiVersion ?? "") + (endpoint.path ?? "")
        guard var url = URL(string: urlStr) else {
            throw NetworkError.invalidURL(url: urlStr)
        }
        
        // Add query parameters if present
        if let queryParameters = endpoint.queryParameters {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            url = components?.url ?? url
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body
        
        // Perform the data task asynchronously
        let (data, response) = try await session.data(for: request)
        let decodedResponse = try handleResponse(response, ofType: responseType, on: urlStr, data: data)
        return decodedResponse
    }
    
    /// Common handling of the response, no matter which `request` function was used
    private func handleResponse<T: Decodable>(
        _ response: URLResponse?,
        ofType responseType: T.Type,
        on url: String,
        data: Data?
    ) throws -> T {
        guard let httpURLResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidURLResponse(url: url)
        }
        
        guard let data, data.isEmpty.not else {
            throw NetworkError.noData(url: url)
        }
        
        let statusCode = httpURLResponse.statusCode
        
        switch statusCode {
        case 200...299:
            // Successful response; do nothing and continue
            break
        case 401:
            throw APIError.unauthorized(url: url)
        case 403:
            throw APIError.forbidden(url: url)
        case 404:
            throw APIError.notFound(url: url)
        case 400...499:
            let serverError: ServerError? = (try? JSONDecoder().decode(ServerErrorResponse.self, from: data))?.error
            throw APIError.clientError(url: url, statusCode: statusCode, serverMessage: serverError?.message, serverRecoverySuggestion: serverError?.recoverySuggestion)
        case 500...599:
            let serverError: ServerError? = (try? JSONDecoder().decode(ServerErrorResponse.self, from: data))?.error
            throw APIError.serverError(url: url, statusCode: statusCode, serverMessage: serverError?.message, serverRecoverySuggestion: serverError?.recoverySuggestion)
        default:
            throw APIError.unknown("[\(statusCode)] \(url)")
        }
        
        let decodedResponse = try JSONDecoder().decode(responseType, from: data)
        return decodedResponse
    }
}
