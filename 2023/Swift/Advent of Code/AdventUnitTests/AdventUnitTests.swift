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
        XCTAssertEqual(day.part2(), "2286", "Part 2 Failed")
    }
    
    func testDay03() throws {
        let day = Day03(input: """
            467..114..
            ...*......
            ..35..633.
            ......#...
            617*......
            .....+.58.
            ..592.....
            ......755.
            ...$.*....
            .664.598..
            """)
        XCTAssertEqual(day.part1(), "4361", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "467835", "Part 2 Failed")
    }
    
    func testDay04() throws {
        let day = Day04(input: """
            Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
            Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
            Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
            Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
            Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
            Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
            """)
        XCTAssertEqual(day.part1(), "13", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "30", "Part 2 Failed")
    }

    func testDay05() throws {
        let day = Day05(input: """
            seeds: 79 14 55 13

            seed-to-soil map:
            50 98 2
            52 50 48

            soil-to-fertilizer map:
            0 15 37
            37 52 2
            39 0 15

            fertilizer-to-water map:
            49 53 8
            0 11 42
            42 0 7
            57 7 4

            water-to-light map:
            88 18 7
            18 25 70

            light-to-temperature map:
            45 77 23
            81 45 19
            68 64 13

            temperature-to-humidity map:
            0 69 1
            1 0 69

            humidity-to-location map:
            60 56 37
            56 93 4
            """)
        XCTAssertEqual(day.part1(), "35", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "46", "Part 2 Failed")
        XCTAssertEqual(day.part2Optimized(), "46", "Part 2 Failed")
    }

    func testDay06() throws {
        let day = Day06(input: """
        Time:      7  15   30
        Distance:  9  40  200
        """)
        XCTAssertEqual(day.part1(), "288", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "71503", "Part 2 Failed")
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
