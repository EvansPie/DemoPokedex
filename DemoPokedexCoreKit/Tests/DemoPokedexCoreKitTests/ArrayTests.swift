
//
//  ArrayTests.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import XCTest
@testable import DemoPokedexCoreKit

final class ArrayTests: XCTestCase {
    
    func testUniqueIntegers() {
        let numbers = [1, 2, 3, 1, 4, 2, 5]
        let uniqueNumbers = numbers.unique
        XCTAssertEqual(uniqueNumbers, [1, 2, 3, 4, 5], "The unique extension should return an array with only unique elements while preserving order.")
    }
    
    func testUniqueStrings() {
        let words = ["apple", "banana", "apple", "orange", "banana"]
        let uniqueWords = words.unique
        XCTAssertEqual(uniqueWords, ["apple", "banana", "orange"], "The unique extension should handle strings correctly.")
    }
    
    func testUniqueEmptyArray() {
        let emptyArray: [Int] = []
        let uniqueEmptyArray = emptyArray.unique
        XCTAssertEqual(uniqueEmptyArray, [], "The unique extension should return an empty array when the input array is empty.")
    }
    
    func testUniqueSingleElementArray() {
        let singleElementArray = [42]
        let uniqueArray = singleElementArray.unique
        XCTAssertEqual(uniqueArray, [42], "The unique extension should return the same single element array when there's only one element.")
    }
    
    func testUniqueAllUniqueElements() {
        let allUnique = [10, 20, 30, 40]
        let result = allUnique.unique
        XCTAssertEqual(result, allUnique, "The unique extension should not modify an array that already has all unique elements.")
    }
    
    func testUniqueCustomStructs() {
        struct CustomStruct: Hashable {
            let id: Int
            let name: String
        }
        
        let pokemons = [
            CustomStruct(id: 1, name: "Bulbasaur"),
            CustomStruct(id: 2, name: "Charmander"),
            CustomStruct(id: 1, name: "Bulbasaur"),
            CustomStruct(id: 3, name: "Squirtle")
        ]
        
        let uniquePokemons = pokemons.unique
        XCTAssertEqual(uniquePokemons.count, 3, "The unique extension should handle custom structs correctly.")
        XCTAssertEqual(uniquePokemons, [
            CustomStruct(id: 1, name: "Bulbasaur"),
            CustomStruct(id: 2, name: "Charmander"),
            CustomStruct(id: 3, name: "Squirtle")
        ])
    }
}
