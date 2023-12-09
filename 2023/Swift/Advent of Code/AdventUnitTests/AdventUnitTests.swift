//
//  AdventUnitTests.swift
//  AdventUnitTests
//
//  Created by Christopher Rumpf on 12/3/23.
//

import XCTest

final class AdventUnitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func exampleInput(havingPath path: String) -> String {
        let url = Bundle(for: AdventUnitTests.self)
            .url(forResource: path, withExtension: nil)!
        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            abort()
        }
    }

    func exampleInput(forDay day: Int, fileName: String = "example") -> String {
        exampleInput(havingPath: "inputs/day/\(day)/\(fileName)")
    }

    func testDay01() throws {
        let day = Day01(input: exampleInput(forDay: 1))
        XCTAssertEqual(day.part1(), "142", "Part 1 Failed")
        
        let dayForPart2 = Day01(input: exampleInput(havingPath: "inputs/day/1/example2"))
        XCTAssertEqual(dayForPart2.part2(), "281", "Part 2 Failed")
    }
    
    func testDay02() throws {
        let day = Day02(input: exampleInput(forDay: 2))
        XCTAssertEqual(day.part1(), "8", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "2286", "Part 2 Failed")
    }
    
    func testDay03() throws {
        let day = Day03(input: exampleInput(forDay: 3))
        XCTAssertEqual(day.part1(), "4361", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "467835", "Part 2 Failed")
    }
    
    func testDay04() throws {
        let day = Day04(input: exampleInput(forDay: 4))
        XCTAssertEqual(day.part1(), "13", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "30", "Part 2 Failed")
    }

    func testDay05() throws {
        let day = Day05(input: exampleInput(forDay: 5))
        XCTAssertEqual(day.part1(), "35", "Part 1 Failed")
        XCTAssertEqual(day.part2Optimized(), "46", "Part 2 Failed")
        XCTAssertEqual(day.part2(), "46", "Part 2 Failed")
    }

    func testDay06() throws {
        let day = Day06(input: exampleInput(forDay: 6))
        XCTAssertEqual(day.part1(), "288", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "71503", "Part 2 Failed")
    }
 
    func testDay07() throws {
        let day = Day07(input: exampleInput(forDay: 7))
        XCTAssertEqual(day.part1(), "6440", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "5905", "Part 2 Failed")
    }
    
    func testDay08() throws {
        let day = Day08(input: exampleInput(forDay: 8))
        XCTAssertEqual(day.part1(), "6", "Part 1 Failed")
        let dayForPart2 = Day08(input: exampleInput(havingPath: "inputs/day/8/example2"))
        XCTAssertEqual(dayForPart2.part2(), "6", "Part 2 Failed")
    }

    func testDay09() throws {
        let day = Day09(input: exampleInput(forDay: 9))
        XCTAssertEqual(day.part1(), "114", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "2", "Part 2 Failed")
    }
    
    func testDay10() throws {
        let day = Day10(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }
    
    func testDay11() throws {
        let day = Day11(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }
    
    func testDay12() throws {
        let day = Day12(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay13() throws {
        let day = Day13(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay14() throws {
        let day = Day14(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay15() throws {
        let day = Day15(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay16() throws {
        let day = Day16(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay17() throws {
        let day = Day17(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay18() throws {
        let day = Day18(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay19() throws {
        let day = Day19(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay20() throws {
        let day = Day20(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay21() throws {
        let day = Day21(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay22() throws {
        let day = Day22(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay23() throws {
        let day = Day23(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay24() throws {
        let day = Day24(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }
    
    func testDay25() throws {
        let day = Day25(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }
    
}
