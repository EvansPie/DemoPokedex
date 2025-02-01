//
//  GenericError.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

public struct GenericError: CustomError {
    
    public let code: String
    public let description: String
    public let recoverySuggestion: String?
    
    public init(code: String, description: String, recoverySuggestion: String? = nil) {
        self.code = code
        self.description = description
        self.recoverySuggestion = recoverySuggestion
    }
}
