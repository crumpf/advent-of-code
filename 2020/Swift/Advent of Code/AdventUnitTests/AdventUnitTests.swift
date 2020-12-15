//
//  AdventUnitTests.swift
//  AdventUnitTests
//
//  Created by Christopher Rumpf on 12/11/20.
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
    1721
    979
    366
    299
    675
    1456
    """
    let day = Day1(input: input)
    
    XCTAssertEqual(day.part1(), "514579", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "241861950", "Part 2 Failed")
  }
  
  func testDay2() throws {
    let input = """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """
    let day = Day2(input: input)

    XCTAssertEqual(day.part1(), "2", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "1", "Part 2 Failed")
  }
  
  func testDay3() throws {
    let input = """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """
    let day = Day3(input: input)

    XCTAssertEqual(day.part1(), "7", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "336", "Part 2 Failed")
  }
  
  func testDay4() throws {
    let input = """
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm

    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929

    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm

    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
    """
    var day = Day4(input: input)
    
    XCTAssertEqual(day.part1(), "2", "Part 1 Failed")

    let invalidInput = """
    eyr:1972 cid:100
    hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

    iyr:2019
    hcl:#602927 eyr:1967 hgt:170cm
    ecl:grn pid:012533040 byr:1946

    hcl:dab227 iyr:2012
    ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

    hgt:59cm ecl:zzz
    eyr:2038 hcl:74454a iyr:2023
    pid:3556412378 byr:2007
    """
    day = Day4(input: invalidInput)
    
    XCTAssertEqual(day.part2(), "0", "Part 2 Failed: All passports in input should be invalid")

    let validInput = """
    pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
    hcl:#623a2f

    eyr:2029 ecl:blu cid:129 byr:1989
    iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

    hcl:#888785
    hgt:164cm byr:2001 iyr:2015 cid:88
    pid:545766238 ecl:hzl
    eyr:2022

    iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
    """
    day = Day4(input: validInput)
    
    XCTAssertEqual(day.part2(), "4", "Part 2 Failed: All passports in input should be valid")
  }
  
  func testDay5() throws {
    let input = """
    FBFBBFFRLR
    BFFFBBFRRR
    FFFBBBFRRR
    BBFFBBFRLL
    """
    let day = Day5(input: input)
    
    XCTAssertEqual(day.part1(), "820", "Part 1 Failed")

    let redux = Day5Redux(input: input)
    
    XCTAssertEqual(redux.part1(), "820", "Part 1 Redux Failed")
  }
  
  func testDay6() throws {
    let input = """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """
    let day = Day6(input: input)
    
    XCTAssertEqual(day.part1(), "11", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "6", "Part 2 Failed")
  }
  
  func testDay7() throws {
    let input = """
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """
    let day = Day7(input: input)
    
    XCTAssertEqual(day.part1(), "4", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "32", "Part 2 Failed")
  }
  
  func testDay8() throws {
    let input = """
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    """
    let day = Day8(input: input)
    
    XCTAssertEqual(day.part1(), "5", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "8", "Part 2 Failed")
  }
  
  func testDay9() throws {
    let input = """
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    """
    let day = Day9(input: input)
    day.preambleSize = 5
    
    XCTAssertEqual(day.part1(), "127", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "62", "Part 2 Failed")
  }
  
  func testDay10() throws {
    let input1 = """
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    """

    let input2 = """
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
    """
    
    let dayWithInput1 = Day10(input: input1)
    let dayWithInput2 = Day10(input: input2)
    
    XCTAssertEqual(dayWithInput1.part1(), "35", "Part 1 Failed")
    XCTAssertEqual(dayWithInput2.part1(), "220", "Part 1 Failed")
    XCTAssertEqual(dayWithInput1.part2(), "8", "Part 2 Failed")
    XCTAssertEqual(dayWithInput2.part2(), "19208", "Part 2 Failed")
  }
  
  func testDay11() throws {
    let input = """
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """
    let day = Day11(input: input)
    
    XCTAssertEqual(day.part1(), "37", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "26", "Part 2 Failed")
  }
  
  func testDay12() throws {
    let input = """
    F10
    N3
    F7
    R90
    F11
    """
    let day = Day12(input: input)
    
    XCTAssertEqual(day.part1(), "25", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "286", "Part 2 Failed")
  }
  
  func testDay14() throws {
    let input1 = """
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    """
    let dayWithInput1 = Day14(input: input1)
    
    XCTAssertEqual(dayWithInput1.part1(), "165", "Part 1 Failed")
    
    
    let input2 = """
    mask = 000000000000000000000000000000X1001X
    mem[42] = 100
    mask = 00000000000000000000000000000000X0XX
    mem[26] = 1
    """
    let dayWithInput2 = Day14(input: input2)
    XCTAssertEqual(dayWithInput2.part2(), "208", "Part 2 Failed")
  }
  
  func testDay15() throws {
    var day = Day15(input: "0,3,6")
    XCTAssertEqual(day.part1(), "436", "Part 1 Failed")
    
    day = Day15(input: "1,3,2")
    XCTAssertEqual(day.part1(), "1")
    
    day = Day15(input: "2,1,3")
    XCTAssertEqual(day.part1(), "10")
    
    day = Day15(input: "1,2,3")
    XCTAssertEqual(day.part1(), "27")
    
    day = Day15(input: "2,3,1")
    XCTAssertEqual(day.part1(), "78")
    
    day = Day15(input: "3,2,1")
    XCTAssertEqual(day.part1(), "438")
    
    day = Day15(input: "3,1,2")
    XCTAssertEqual(day.part1(), "1836")
  }
}
