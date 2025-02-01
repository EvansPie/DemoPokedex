//
//  FileManager.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import Foundation

public extension FileManager {
    
    static func getBundledFileData(of bundledFilename: String) throws -> Data {
        let components = bundledFilename.split(separator: ".").map({ String($0) })
        if components.count != 2 {
            throw GenericError(code: "invalid-filename", description: "Bundled filenames should always have a name and an extension (e.g. filename.json)")
        }
        
        let filename = components[0]
        let ext = components[1]
        
        guard let localURL = Bundle.main.url(forResource: filename, withExtension: ext) else {
            throw GenericError(code: "invalid-filename-url", description: "Failed to find file '\(bundledFilename)' in the Bundle")
        }
        
        return try Data(contentsOf: localURL)
    }
}
