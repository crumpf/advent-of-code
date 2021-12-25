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
    [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
    [[[5,[2,8]],4],[5,[[9,9],0]]]
    [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
    [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
    [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
    [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
    [[[[5,4],[7,7]],8],[[8,3],8]]
    [[9,3],[[9,9],[6,[4,9]]]]
    [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
    [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
    
    """
    day = Day18(input: input)
    let sum = day.addListOfSnailfishNumbers(day.makeSnailfishNumbers())
    XCTAssertEqual("\(sum)", "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]")
    
    XCTAssertEqual(day.part1(), "4140", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "3993", "Part 2 Failed")
  }
  
  func testDay19() throws {
    let day = Day19(input: "")
    XCTAssertEqual(day.part1(), "", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "", "Part 2 Failed")
  }
  
  func testDay20() throws {
    let input = """
    ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

    #..#.
    #....
    ##..#
    ..#..
    ..###
    
    """
    let day = Day20(input: input)
    XCTAssertEqual(day.part1(), "35", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "3351", "Part 2 Failed")
  }
  
  func testDay21() throws {
    let input = """
    Player 1 starting position: 4
    Player 2 starting position: 8
    
    """
    let day = Day21(input: input)
    XCTAssertEqual(day.part1(), "739785", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "444356092776315", "Part 2 Failed")
  }
  
  func testDay22() throws {
//    let input = """
//    on x=-20..26,y=-36..17,z=-47..7
//    on x=-20..33,y=-21..23,z=-26..28
//    on x=-22..28,y=-29..23,z=-38..16
//    on x=-46..7,y=-6..46,z=-50..-1
//    on x=-49..1,y=-3..46,z=-24..28
//    on x=2..47,y=-22..22,z=-23..27
//    on x=-27..23,y=-28..26,z=-21..29
//    on x=-39..5,y=-6..47,z=-3..44
//    on x=-30..21,y=-8..43,z=-13..34
//    on x=-22..26,y=-27..20,z=-29..19
//    off x=-48..-32,y=26..41,z=-47..-37
//    on x=-12..35,y=6..50,z=-50..-2
//    off x=-48..-32,y=-32..-16,z=-15..-5
//    on x=-18..26,y=-33..15,z=-7..46
//    off x=-40..-22,y=-38..-28,z=23..41
//    on x=-16..35,y=-41..10,z=-47..6
//    off x=-32..-23,y=11..30,z=-14..3
//    on x=-49..-5,y=-3..45,z=-29..18
//    off x=18..30,y=-20..-8,z=-3..13
//    on x=-41..9,y=-7..43,z=-33..15
//    on x=-54112..-39298,y=-85059..-49293,z=-27449..7877
//    on x=967..23432,y=45373..81175,z=27513..53682
//
//    """
    let input = """
    on x=-5..47,y=-31..22,z=-19..33
    on x=-44..5,y=-27..21,z=-14..35
    on x=-49..-1,y=-11..42,z=-10..38
    on x=-20..34,y=-40..6,z=-44..1
    off x=26..39,y=40..50,z=-2..11
    on x=-41..5,y=-41..6,z=-36..8
    off x=-43..-33,y=-45..-28,z=7..25
    on x=-33..15,y=-32..19,z=-34..11
    off x=35..47,y=-46..-34,z=-11..5
    on x=-14..36,y=-6..44,z=-16..29
    on x=-57795..-6158,y=29564..72030,z=20435..90618
    on x=36731..105352,y=-21140..28532,z=16094..90401
    on x=30999..107136,y=-53464..15513,z=8553..71215
    on x=13528..83982,y=-99403..-27377,z=-24141..23996
    on x=-72682..-12347,y=18159..111354,z=7391..80950
    on x=-1060..80757,y=-65301..-20884,z=-103788..-16709
    on x=-83015..-9461,y=-72160..-8347,z=-81239..-26856
    on x=-52752..22273,y=-49450..9096,z=54442..119054
    on x=-29982..40483,y=-108474..-28371,z=-24328..38471
    on x=-4958..62750,y=40422..118853,z=-7672..65583
    on x=55694..108686,y=-43367..46958,z=-26781..48729
    on x=-98497..-18186,y=-63569..3412,z=1232..88485
    on x=-726..56291,y=-62629..13224,z=18033..85226
    on x=-110886..-34664,y=-81338..-8658,z=8914..63723
    on x=-55829..24974,y=-16897..54165,z=-121762..-28058
    on x=-65152..-11147,y=22489..91432,z=-58782..1780
    on x=-120100..-32970,y=-46592..27473,z=-11695..61039
    on x=-18631..37533,y=-124565..-50804,z=-35667..28308
    on x=-57817..18248,y=49321..117703,z=5745..55881
    on x=14781..98692,y=-1341..70827,z=15753..70151
    on x=-34419..55919,y=-19626..40991,z=39015..114138
    on x=-60785..11593,y=-56135..2999,z=-95368..-26915
    on x=-32178..58085,y=17647..101866,z=-91405..-8878
    on x=-53655..12091,y=50097..105568,z=-75335..-4862
    on x=-111166..-40997,y=-71714..2688,z=5609..50954
    on x=-16602..70118,y=-98693..-44401,z=5197..76897
    on x=16383..101554,y=4615..83635,z=-44907..18747
    off x=-95822..-15171,y=-19987..48940,z=10804..104439
    on x=-89813..-14614,y=16069..88491,z=-3297..45228
    on x=41075..99376,y=-20427..49978,z=-52012..13762
    on x=-21330..50085,y=-17944..62733,z=-112280..-30197
    on x=-16478..35915,y=36008..118594,z=-7885..47086
    off x=-98156..-27851,y=-49952..43171,z=-99005..-8456
    off x=2032..69770,y=-71013..4824,z=7471..94418
    on x=43670..120875,y=-42068..12382,z=-24787..38892
    off x=37514..111226,y=-45862..25743,z=-16714..54663
    off x=25699..97951,y=-30668..59918,z=-15349..69697
    off x=-44271..17935,y=-9516..60759,z=49131..112598
    on x=-61695..-5813,y=40978..94975,z=8655..80240
    off x=-101086..-9439,y=-7088..67543,z=33935..83858
    off x=18020..114017,y=-48931..32606,z=21474..89843
    off x=-77139..10506,y=-89994..-18797,z=-80..59318
    off x=8476..79288,y=-75520..11602,z=-96624..-24783
    on x=-47488..-1262,y=24338..100707,z=16292..72967
    off x=-84341..13987,y=2429..92914,z=-90671..-1318
    off x=-37810..49457,y=-71013..-7894,z=-105357..-13188
    off x=-27365..46395,y=31009..98017,z=15428..76570
    off x=-70369..-16548,y=22648..78696,z=-1892..86821
    on x=-53470..21291,y=-120233..-33476,z=-44150..38147
    off x=-93533..-4276,y=-16170..68771,z=-104985..-24507
    
    """
    let day = Day22(input: input)
//    XCTAssertEqual(day.part1(), "590784", "Part 1 Failed")
    XCTAssertEqual(day.part1(), "474140", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "2758514936282235", "Part 2 Failed")
  }
  
  func testDay23() throws {
    let input = """
    #############
    #...........#
    ###B#C#B#D###
      #A#D#C#A#
      #########
    """
    let day = Day23(input: input)
    XCTAssertEqual(day.part1(), "", "Part 1 Failed")
    XCTAssertEqual(day.part2(), "", "Part 2 Failed")
  }
  
  func testDay24() throws {
    let larger3X = """
    inp z
    inp x
    mul z 3
    eql z x
    """
    var alu = Day24.ALU(program: larger3X.lines(), input: Day24.ALUInput(value: "34"))
    alu.run()
    XCTAssertEqual(alu.register["z"]!, 0)
    alu = Day24.ALU(program: larger3X.lines(), input: Day24.ALUInput(value: "39"))
    alu.run()
    XCTAssertEqual(alu.register["z"]!, 1)
    
    let binary = """
    inp w
    add z w
    mod z 2
    div w 2
    add y w
    mod y 2
    div w 2
    add x w
    mod x 2
    div w 2
    mod w 2
    """
    alu = Day24.ALU(program: binary.lines(), input: Day24.ALUInput(value: "9"))
    alu.run()
    var res = "\(alu.register["w"]!)\(alu.register["x"]!)\(alu.register["y"]!)\(alu.register["z"]!)"
    XCTAssertEqual(res, "1001")
    alu = Day24.ALU(program: binary.lines(), input: Day24.ALUInput(value: "7"))
    alu.run()
    res = "\(alu.register["w"]!)\(alu.register["x"]!)\(alu.register["y"]!)\(alu.register["z"]!)"
    XCTAssertEqual(res, "0111")
  }
  
}
