//
//  AdventUnitTests.swift
//  AdventUnitTests
//
//  Created by Christopher Rumpf on 12/01/21.
//

import XCTest

class AdventUnitTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testDay1() throws {
    let input = """
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    """
    let day = Day1(input: input)
    
    XCTAssertEqual(day.part1(), "7", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "5", "Part 2 Failed")
  }
  
}
