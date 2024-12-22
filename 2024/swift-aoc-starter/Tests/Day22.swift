import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day22Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    1
    10
    100
    2024

    """

  @Test func testPart1() async throws {
    let challenge = Day22(data: testData)
    #expect(String(describing: challenge.part1()) == "37327623")
  }

  @Test func testPart2() async throws {
    let challenge = Day22(data: testData)
    #expect(String(describing: challenge.part2()) == "0")
  }

  @Test func testMixAndPrune() async throws {
    let challenge = Day22(data: testData)
    #expect(challenge.mix(15, into: 42) == 37)
    #expect(challenge.prune(100000000) == 16113920)
  }
}
