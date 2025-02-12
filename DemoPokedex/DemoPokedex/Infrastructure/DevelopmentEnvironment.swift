//
//  DevelopmentEnvironment.swift
//  DemoPokedex
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

enum DevelopmentEnvironment {
    
    static let current: DevelopmentEnvironment = DevelopmentEnvironment.local
    
    case local
    case dev
    /// No need for other environments for now
//    case staging
//    case production
}
