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
  
  func testDay3() throws {
    let input = """
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
      """
    let day = Day3(input: input)
    XCTAssertEqual(day.part1(), "198", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "230", "Part 2 Failed")
  }
  
  func testDay4() throws {
    let input = """
      7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

      22 13 17 11  0
       8  2 23  4 24
      21  9 14 16  7
       6 10  3 18  5
       1 12 20 15 19

       3 15  0  2 22
       9 18 13 17  5
      19  8  7 25 23
      20 11 10 24  4
      14 21 16 12  6

      14 21 17 24  4
      10 16 15  9 19
      18  8 23 26 20
      22 11 13  6  5
       2  0 12  3  7
      """
    let day = Day4(input: input)
    XCTAssertEqual(day.part1(), "4512", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "1924", "Part 2 Failed")
  }
  
  func testDay5() throws {
    let input = """
      0,9 -> 5,9
      8,0 -> 0,8
      9,4 -> 3,4
      2,2 -> 2,1
      7,0 -> 7,4
      6,4 -> 2,0
      0,9 -> 2,9
      3,4 -> 1,4
      0,0 -> 8,8
      5,5 -> 8,2
      
      """
    let day = Day5(input: input)
    XCTAssertEqual(day.part1(), "5", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "12", "Part 2 Failed")
  }
  
  func testDay6() throws {
    let input = """
      3,4,3,1,2
      
      """
    let day = Day6(input: input)
    XCTAssertEqual(day.part1(), "5934", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "26984457539", "Part 2 Failed")
  }
  
  func testDay7() throws {
    let input = """
      16,1,2,0,4,2,7,1,2,14
      
      """
    let day = Day7(input: input)
    XCTAssertEqual(day.part1(), "2 (37 fuel)", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "5 (168 fuel)", "Part 2 Failed")
  }
  
  func testDay8() throws {
    let input = """
      be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
      edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
      fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
      fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
      aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
      fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
      dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
      bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
      egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
      gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce

      """
    let day = Day8(input: input)
    XCTAssertEqual(day.part1(), "26", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "61229", "Part 2 Failed")
  }
  
  func testDay9() throws {
    let input = """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """
    let day = Day9(input: input)
    XCTAssertEqual(day.part1(), "15", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "1134", "Part 2 Failed")
  }
  
  func testDay10() throws {
    let input = """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """
    let day = Day10(input: input)
    XCTAssertEqual(day.part1(), "26397", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "288957", "Part 2 Failed")
  }
    
  func testDay11() throws {
    let input = """
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    """
    let day = Day11(input: input)
    XCTAssertEqual(day.part1(), "1656", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "195", "Part 2 Failed")
  }
  
  func testDay12() throws {
//    let input = """
//    start-A
//    start-b
//    A-c
//    A-b
//    b-d
//    A-end
//    b-end
//    """
    let input = """
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    """
    let day = Day12(input: input)
    XCTAssertEqual(day.part1(), "19", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "103", "Part 2 Failed")
  }

  func testDay13() throws {
    let input = """
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
    
    """
    let day = Day13(input: input)
    XCTAssertEqual(day.part1(), "17", "Part 1 Failed")
    XCTAssertEqual(day.part2(), """
    #####
    #...#
    #...#
    #...#
    #####
    
    """, "Part 2 Failed")
  }
  
  func testDay14() throws {
    let input = """
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    
    """
    let day = Day14(input: input)
    XCTAssertEqual(day.part1(), "1588", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "2188189693529", "Part 2 Failed")
  }

  func testDay15() throws {
    let input = """
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
    
    """
    let day = Day15(input: input)
    XCTAssertEqual(day.part1(), "40", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "315", "Part 2 Failed")
  }
  
  func testDay16() throws {
    var day = Day16(input: "D2FE28")
    var msg = day.makeBinaryMessage()
    var pkt = msg.readPacket()!
    XCTAssertEqual(pkt.header.version, 6)
    XCTAssertEqual(pkt.header.type.rawValue, 4)
    XCTAssertEqual(pkt.literalValue, 2021)
    
    
    day = Day16(input: "38006F45291200")
    msg = day.makeBinaryMessage()
    pkt = msg.readPacket()!
    XCTAssertEqual(pkt.header.version, 1)
    XCTAssertEqual(pkt.header.type.rawValue, 6)
    XCTAssertEqual(pkt.subPackets.count, 2)
    
    
    day = Day16.init(input: "EE00D40C823060")
    msg = day.makeBinaryMessage()
    pkt = msg.readPacket()!
    XCTAssertEqual(pkt.header.version, 7)
    XCTAssertEqual(pkt.header.type.rawValue, 3)
    XCTAssertEqual(pkt.subPackets.count, 3)
  }

  func testDay17() throws {
    let day = Day17(input: "target area: x=20..30, y=-10..-5")
    XCTAssertEqual(day.part1(), "45", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "112", "Part 2 Failed")
  }
  
  func testDay18() throws {
    var input = """
    [1,2]
    [[1,2],3]
    [9,[8,7]]
    [[1,9],[8,5]]
    [[[[1,2],[3,4]],[[5,6],[7,8]]],9]
    [[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
    [[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]
    
    """
    var day = Day18(input: input)
    var snailfishNumbers = day.makeSnailfishNumbers()
    XCTAssertEqual(input, snailfishNumbers.reduce(into: "") { $0.append("\($1)\n") })
    
    input = """
    [[[[[9,8],1],2],3],4]
    [7,[6,[5,[4,[3,2]]]]]
    [[6,[5,[4,[3,2]]]],1]
    [[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]
    [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]
    [[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]
    
    """
    day = Day18(input: input)
    snailfishNumbers = day.makeSnailfishNumbers()
    let firstAtDepth4 = """
    [9,8]
    [3,2]
    [3,2]
    [7,3]
    [3,2]
    [4,3]
    
    """
    let foundNesteds = snailfishNumbers.reduce(into: "") { partial, sfn in
      var foundString = "none\n"
      if let found = sfn.firstNestedInsideFourPairs() {
        foundString = "\(found)\n"
      }
      partial.append(foundString)
    }
    XCTAssertEqual(firstAtDepth4, foundNesteds)
    
    let singleExplode = """
    [[[[0,9],2],3],4]
    [7,[6,[5,[7,0]]]]
    [[6,[5,[7,0]]],3]
    [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]
    [[3,[2,[8,0]]],[9,[5,[7,0]]]]
    [[[[0,7],4],[7,[[8,4],9]]],[1,1]]
    
    """
    snailfishNumbers.compactMap { $0.firstNestedInsideFourPairs() }
      .forEach { $0.explode() }
    XCTAssertEqual(singleExplode, snailfishNumbers.reduce(into: "") { $0.append("\($1)\n") })
    
    /*
     [[[[4,3],4],4],[7,[[8,4],9]]] + [1,1]:

     after addition: [[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]
     after explode:  [[[[0,7],4],[7,[[8,4],9]]],[1,1]]
     after explode:  [[[[0,7],4],[15,[0,13]]],[1,1]]
     after split:    [[[[0,7],4],[[7,8],[0,13]]],[1,1]]
     after split:    [[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]
     after explode:  [[[[0,7],4],[[7,8],[6,0]]],[8,1]]
     */
    input = """
    [[[[4,3],4],4],[7,[[8,4],9]]]
    [1,1]

    """
    day = Day18(input: input)
    snailfishNumbers = day.makeSnailfishNumbers()
    let a = snailfishNumbers[0] + snailfishNumbers[1]
    XCTAssertEqual("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]", "\(a)")
    a.reduce()
    XCTAssertEqual("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]", "\(a)")
    
    input = """
    [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
    [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
    [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
    [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
    [7,[5,[[3,8],[1,4]]]]
    [[2,[2,2]],[8,[8,1]]]
    [2,9]
    [1,[[[9,3],9],[[9,0],[0,7]]]]
    [[[5,[7,4]],7],1]
    [[[[4,2],2],6],[8,7]]
    
    """
    day = Day18(input: input)
    let sum = day.addListOfSnailfishNumbers(day.makeSnailfishNumbers())
    XCTAssertEqual("\(sum)", "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")
    
    XCTAssertEqual(day.part1(), "3488", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "", "Part 2 Failed")
  }
}
