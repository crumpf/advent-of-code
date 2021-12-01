//
//  StringSubscriptsTests.swift
//  AdventUnitTests
//
//  Created by Christopher Rumpf on 12/18/20.
//

import XCTest

class StringSubscriptsTests: XCTestCase {
  
  func testOffset() throws {
    let s = "Swift"
    let c = s[1]
    XCTAssertEqual(c, "w")
  }
  
  func testRange() throws {
    let s = "Swift"
    let substr = s[1..<3]
    XCTAssertEqual(substr, "wi")
  }
  
  func testClosedRange() throws {
    let s = "Swift"
    let subseq = s[1...3]
    XCTAssertEqual(subseq, "wif")
  }
  
  func testPartialRangeUpTo() throws {
    let s = "Swift"
    let substr = s[..<3]
    XCTAssertEqual(substr, "Swi")
  }
  
  func testPartialRangeThrough() throws {
    let s = "Swift"
    let substr = s[...3]
    XCTAssertEqual(substr, "Swif")
  }
  
  func testPartialRangeFrom() throws {
    let s = "Swift"
    let substr = s[2...]
    XCTAssertEqual(substr, "ift")
  }
  
}
