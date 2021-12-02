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
    XCTAssertEqual(day.part2(windowSize: 3), "5", "Part 2 with windowSize param Failed")
  }
  
  func testDay2() throws {
    let input = """
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
      """
    let day = Day2(input: input)
    XCTAssertEqual(day.part1(), "150", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "900", "Part 2 Failed")
  }
  
}
