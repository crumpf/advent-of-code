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

    func testDay01() throws {
        let day = Day01(input: """
            1abc2
            pqr3stu8vwx
            a1b2c3d4e5f
            treb7uchet
            """)
        XCTAssertEqual(day.part1(), "142", "Part 1 Failed")
        
        let dayForPart2 = Day01(input: """
            two1nine
            eightwothree
            abcone2threexyz
            xtwone3four
            4nineeightseven2
            zoneight234
            7pqrstsixteen
            """)
        XCTAssertEqual(dayForPart2.part2(), "281", "Part 2 Failed")
    }
    
    func testDay02() throws {
        let day = Day02(input: """
            Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
            Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
            Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
            Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
            Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
            """)
        XCTAssertEqual(day.part1(), "8", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }
    
    func testDay03() throws {
        let day = Day03(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }
    
    func testDay04() throws {
        let day = Day04(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay05() throws {
        let day = Day05(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay06() throws {
        let day = Day06(input: "")
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }
 
    func testDay07() throws {
        let day = Day07(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }
    
    func testDay08() throws {
        let day = Day08(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay09() throws {
        let day = Day09(input: """
            """)
        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
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
