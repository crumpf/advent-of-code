import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day12Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE

    """

  @Test func testPart1() async throws {
    let challenge = Day12(data: testData)
    #expect(String(describing: challenge.part1()) == "1930")
  }

  @Test func testPart2() async throws {
    let simpleRegion = Day12(data: """
      AAAA
      BBCD
      BBCC
      EEEC
      
      """)
    #expect(String(describing: simpleRegion.part2()) == "80")

    let xoRegion = Day12(data: """
      OOOOO
      OXOXO
      OOOOO
      OXOXO
      OOOOO
      
      """)
    #expect(String(describing: xoRegion.part2()) == "436")

    let eShapeRegion = Day12(data: """
      EEEEE
      EXXXX
      EEEEE
      EXXXX
      EEEEE
      
      """)
    #expect(String(describing: eShapeRegion.part2()) == "236")

    let abRegion = Day12(data: """
      AAAAAA
      AAABBA
      AAABBA
      ABBAAA
      ABBAAA
      AAAAAA
      
      """)
    #expect(String(describing: abRegion.part2()) == "368")

    let challenge = Day12(data: testData)
    #expect(String(describing: challenge.part2()) == "1206")
  }
}
