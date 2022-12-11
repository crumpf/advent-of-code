//
//  AdventUnitTests.swift
//  AdventUnitTests
//
//  Created by Christopher Rumpf on 12/9/22.
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
            1000
            2000
            3000

            4000

            5000
            6000

            7000
            8000
            9000

            10000
            """)
        XCTAssertEqual(day.part1(), "24000", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "45000", "Part 2 Failed")
    }
    
    func testDay02() throws {
        let day = Day02(input: """
            A Y
            B X
            C Z
            """)
        XCTAssertEqual(day.part1(), "15", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "12", "Part 2 Failed")
    }
    
    func testDay02Alternative() throws {
        let day = Day02Alternative(input: """
            A Y
            B X
            C Z
            """)
        XCTAssertEqual(day.part1(), "15", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "12", "Part 2 Failed")
    }
    
    func testDay03() throws {
        let day = Day03(input: """
            vJrwpWtwJgWrhcsFMMfFFhFp
            jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
            PmmdzqPrVvPwwTWBwg
            wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
            ttgJtRGJQctTZtZT
            CrZsJsPPZsGzwwsLwLmpwMDw
            """)
        XCTAssertEqual(day.part1(), "157", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "70", "Part 2 Failed")
    }
    
    func testDay04() throws {
        let day = Day04(input: """
            2-4,6-8
            2-3,4-5
            5-7,7-9
            2-8,3-7
            6-6,4-6
            2-6,4-8
            """)
        XCTAssertEqual(day.part1(), "2", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "4", "Part 2 Failed")
    }

    func testDay05() throws {
        let day = Day05(input: """
                [D]
            [N] [C]
            [Z] [M] [P]
             1   2   3

            move 1 from 2 to 1
            move 3 from 1 to 3
            move 2 from 2 to 1
            move 1 from 1 to 2
            """)
        XCTAssertEqual(day.part1(), "CMZ", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "MCD", "Part 2 Failed")
    }

    func testDay06() throws {
        let day = Day06(input: "mjqjpqmgbljsphdztnvjfqwrcgsmlb")
        XCTAssertEqual(day.part1(), "7", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "19", "Part 2 Failed")
    }
 
    func testDay07() throws {
        let day = Day07(input: """
            $ cd /
            $ ls
            dir a
            14848514 b.txt
            8504156 c.dat
            dir d
            $ cd a
            $ ls
            dir e
            29116 f
            2557 g
            62596 h.lst
            $ cd e
            $ ls
            584 i
            $ cd ..
            $ cd ..
            $ cd d
            $ ls
            4060174 j
            8033020 d.log
            5626152 d.ext
            7214296 k
            """)
        XCTAssertEqual(day.part1(), "95437", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "24933642", "Part 2 Failed")
    }
    
    func testDay08() throws {
        let day = Day08(input: """
            30373
            25512
            65332
            33549
            35390
            """)
        XCTAssertEqual(day.part1(), "21", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "8", "Part 2 Failed")
    }

    func testDay09() throws {
        let day = Day09(input: """
            R 5
            U 8
            L 8
            D 3
            R 17
            D 10
            L 25
            U 20
            """)
        XCTAssertEqual(day.part1(), "88", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "36", "Part 2 Failed")
    }
    
    func testDay10() throws {
        let day = Day10(input: """
            addx 15
            addx -11
            addx 6
            addx -3
            addx 5
            addx -1
            addx -8
            addx 13
            addx 4
            noop
            addx -1
            addx 5
            addx -1
            addx 5
            addx -1
            addx 5
            addx -1
            addx 5
            addx -1
            addx -35
            addx 1
            addx 24
            addx -19
            addx 1
            addx 16
            addx -11
            noop
            noop
            addx 21
            addx -15
            noop
            noop
            addx -3
            addx 9
            addx 1
            addx -3
            addx 8
            addx 1
            addx 5
            noop
            noop
            noop
            noop
            noop
            addx -36
            noop
            addx 1
            addx 7
            noop
            noop
            noop
            addx 2
            addx 6
            noop
            noop
            noop
            noop
            noop
            addx 1
            noop
            noop
            addx 7
            addx 1
            noop
            addx -13
            addx 13
            addx 7
            noop
            addx 1
            addx -33
            noop
            noop
            noop
            addx 2
            noop
            noop
            noop
            addx 8
            noop
            addx -1
            addx 2
            addx 1
            noop
            addx 17
            addx -9
            addx 1
            addx 1
            addx -3
            addx 11
            noop
            noop
            addx 1
            noop
            addx 1
            noop
            noop
            addx -13
            addx -19
            addx 1
            addx 3
            addx 26
            addx -30
            addx 12
            addx -1
            addx 3
            addx 1
            noop
            noop
            noop
            addx -9
            addx 18
            addx 1
            addx 2
            noop
            noop
            addx 9
            noop
            noop
            noop
            addx -1
            addx 2
            addx -37
            addx 1
            addx 3
            noop
            addx 15
            addx -21
            addx 22
            addx -6
            addx 1
            noop
            addx 2
            addx 1
            noop
            addx -10
            noop
            noop
            addx 20
            addx 1
            addx 2
            addx 2
            addx -6
            addx -11
            noop
            noop
            noop
            """)
        XCTAssertEqual(day.part1(), "13140", "Part 1 Failed")
        XCTAssertEqual(
            day.part2(),
            """
            ##..##..##..##..##..##..##..##..##..##..
            ###...###...###...###...###...###...###.
            ####....####....####....####....####....
            #####.....#####.....#####.....#####.....
            ######......######......######......####
            #######.......#######.......#######.....
            """,
            "Part 2 Failed")
    }
    
    func testDay11() throws {
        let day = Day11(input: """
            Monkey 0:
              Starting items: 79, 98
              Operation: new = old * 19
              Test: divisible by 23
                If true: throw to monkey 2
                If false: throw to monkey 3

            Monkey 1:
              Starting items: 54, 65, 75, 74
              Operation: new = old + 6
              Test: divisible by 19
                If true: throw to monkey 2
                If false: throw to monkey 0

            Monkey 2:
              Starting items: 79, 60, 97
              Operation: new = old * old
              Test: divisible by 13
                If true: throw to monkey 1
                If false: throw to monkey 3

            Monkey 3:
              Starting items: 74
              Operation: new = old + 3
              Test: divisible by 17
                If true: throw to monkey 0
                If false: throw to monkey 1
            """)
        XCTAssertEqual(day.part1(), "10605", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "2713310158", "Part 2 Failed")
    }
    
//    func testDay12() throws {
//        let day = Day12(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }
//
//    func testDay13() throws {
//        let day = Day13(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }
//
//    func testDay14() throws {
//        let day = Day14(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }
//
//    func testDay15() throws {
//        let day = Day15(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }
//
//    func testDay16() throws {
//        let day = Day16(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }
//
//    func testDay17() throws {
//        let day = Day17(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }
//
//    func testDay18() throws {
//        let day = Day18(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }
//
//    func testDay19() throws {
//        let day = Day19(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }
//
//    func testDay20() throws {
//        let day = Day20(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }
//
//    func testDay21() throws {
//        let day = Day21(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }
//
//    func testDay22() throws {
//        let day = Day22(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }
//
//    func testDay23() throws {
//        let day = Day23(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }
//
//    func testDay24() throws {
//        let day = Day24(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }
    
}
