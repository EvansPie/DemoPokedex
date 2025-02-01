//
//  StringTests.swift
//  DemoPokedexCoreKit
//
//  Created by Evangelos Pittas on 1/2/25.
//

import XCTest
@testable import DemoPokedexCoreKit

final class StringExtensionTests: XCTestCase {

    func testFirstLetterCapitalizedBasicInput() {
        let input = "hello world"
        let expectedOutput = "Hello World"
        XCTAssertEqual(input.firstLetterOfEachWordCapitalized(), expectedOutput)
    }

    func testFirstLetterCapitalizedEmptyString() {
        let input = ""
        let expectedOutput = ""
        XCTAssertEqual(input.firstLetterOfEachWordCapitalized(), expectedOutput)
    }

    func testFirstLetterCapitalizedSingleWord() {
        let input = "swift"
        let expectedOutput = "Swift"
        XCTAssertEqual(input.firstLetterOfEachWordCapitalized(), expectedOutput)
    }

    func testFirstLetterCapitalizedAlreadyCapitalizedWords() {
        let input = "Hello World"
        let expectedOutput = "Hello World"
        XCTAssertEqual(input.firstLetterOfEachWordCapitalized(), expectedOutput)
    }

    func testFirstLetterCapitalizedMixedCaseWords() {
        let input = "hELLo wORLD"
        let expectedOutput = "Hello World"
        XCTAssertEqual(input.firstLetterOfEachWordCapitalized(), expectedOutput)
    }

    func testFirstLetterCapitalizedLeadingTrailingWhitespace() {
        let input = "   swift is awesome   "
        let expectedOutput = "Swift Is Awesome"
        XCTAssertEqual(input.trimmingCharacters(in: .whitespacesAndNewlines).firstLetterOfEachWordCapitalized(), expectedOutput)
    }

    func testFirstLetterCapitalizedMultipleSpacesBetweenWords() {
        let input = "swift   is   awesome"
        let expectedOutput = "Swift Is Awesome"
        XCTAssertEqual(input.firstLetterOfEachWordCapitalized(), expectedOutput)
    }
}
