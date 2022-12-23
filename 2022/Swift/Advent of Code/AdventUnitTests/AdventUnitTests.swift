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
    
    func testDay12() throws {
        let day = Day12(input: """
            Sabqponm
            abcryxxl
            accszExk
            acctuvwj
            abdefghi
            """)
        XCTAssertEqual(day.part1(), "31", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "29", "Part 2 Failed")
    }

    func testDay13() throws {
        let day = Day13(input: """
            [1,1,3,1,1]
            [1,1,5,1,1]

            [[1],[2,3,4]]
            [[1],4]

            [9]
            [[8,7,6]]

            [[4,4],4,4]
            [[4,4],4,4,4]

            [7,7,7,7]
            [7,7,7]

            []
            [3]

            [[[]]]
            [[]]

            [1,[2,[3,[4,[5,6,7]]]],8,9]
            [1,[2,[3,[4,[5,6,0]]]],8,9]
            """)
        XCTAssertEqual(day.part1(), "13", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "140", "Part 2 Failed")
    }

    func testDay14() throws {
        let day = Day14(input: """
            498,4 -> 498,6 -> 496,6
            503,4 -> 502,4 -> 502,9 -> 494,9
            """)
        XCTAssertEqual(day.part1(), "24", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "93", "Part 2 Failed")
    }

    func testDay15() throws {
        let day = Day15(input: """
            Sensor at x=2, y=18: closest beacon is at x=-2, y=15
            Sensor at x=9, y=16: closest beacon is at x=10, y=16
            Sensor at x=13, y=2: closest beacon is at x=15, y=3
            Sensor at x=12, y=14: closest beacon is at x=10, y=16
            Sensor at x=10, y=20: closest beacon is at x=10, y=16
            Sensor at x=14, y=17: closest beacon is at x=10, y=16
            Sensor at x=8, y=7: closest beacon is at x=2, y=10
            Sensor at x=2, y=0: closest beacon is at x=2, y=10
            Sensor at x=0, y=11: closest beacon is at x=2, y=10
            Sensor at x=20, y=14: closest beacon is at x=25, y=17
            Sensor at x=17, y=20: closest beacon is at x=21, y=22
            Sensor at x=16, y=7: closest beacon is at x=15, y=3
            Sensor at x=14, y=3: closest beacon is at x=15, y=3
            Sensor at x=20, y=1: closest beacon is at x=15, y=3
            """)
        XCTAssertEqual(day.numberOfPositionsThatCannotContainABeacon(inRow: 10), 26, "Part 1 Failed")
        XCTAssertEqual(day.tuningFrequencyOfDistressBeaconHavingSearchBounds(lower: 0, upper: 20), 56000011, "Part 2 Failed")
    }

    func testDay16() throws {
        let day = Day16(input: """
            Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
            Valve BB has flow rate=13; tunnels lead to valves CC, AA
            Valve CC has flow rate=2; tunnels lead to valves DD, BB
            Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
            Valve EE has flow rate=3; tunnels lead to valves FF, DD
            Valve FF has flow rate=0; tunnels lead to valves EE, GG
            Valve GG has flow rate=0; tunnels lead to valves FF, HH
            Valve HH has flow rate=22; tunnel leads to valve GG
            Valve II has flow rate=0; tunnels lead to valves AA, JJ
            Valve JJ has flow rate=21; tunnel leads to valve II
            """)
        XCTAssertEqual(day.part1(), "1651", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay17() throws {
        let day = Day17(input: """
            >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
            """)
        XCTAssertEqual(day.part1(), "3068", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "1514285714288", "Part 2 Failed")
    }

    func testDay18() throws {
        let day = Day18(input: """
            2,2,2
            1,2,2
            3,2,2
            2,1,2
            2,3,2
            2,2,1
            2,2,3
            2,2,4
            2,2,6
            1,2,5
            3,2,5
            2,1,5
            2,3,5
            """)
        XCTAssertEqual(day.part1(), "64", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "58", "Part 2 Failed")
    }

    func testDay19() throws {
        let day = Day19(input: """
            Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
            Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
            """)
        XCTAssertEqual(day.part1(), "33", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

    func testDay20() throws {
        let day = Day20(input: """
            1
            2
            -3
            3
            -2
            0
            4
            """)
        XCTAssertEqual(day.part1(), "3", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "1623178306", "Part 2 Failed")
    }

//    func testDay21() throws {
//        let day = Day21(input: """
//            """)
//        XCTAssertEqual(day.part1(), "Not Implemented", "Part 1 Failed")
//        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
//    }

    func testDay22() throws {
        let day = Day22(input: """
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
""")
        XCTAssertEqual(day.part1(), "6032", "Part 1 Failed")
        XCTAssertEqual(day.part2(), "Not Implemented", "Part 2 Failed")
    }

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
