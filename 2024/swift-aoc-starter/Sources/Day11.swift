import Algorithms

struct Day11: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var stones: [Int] {
    data.split(separator: "\n").first!.split(separator: .whitespace).map { Int($0)! }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    stones.map { countAfterBlinking(atStone: $0, times: 25) }.reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    0
  }

  func countAfterBlinking(atStone stone: Int, times: Int, blinksSoFar: Int = 0) -> Int {
    guard blinksSoFar < times else { return 1 }

    if stone == 0 {
      return countAfterBlinking(atStone: 1, times: times, blinksSoFar: blinksSoFar + 1)
    }

    let stoneString = "\(stone)"
    if stoneString.count.isMultiple(of: 2) {
      let half = stoneString.count / 2
      return countAfterBlinking(atStone: Int(stoneString.dropLast(half))!, times: times, blinksSoFar: blinksSoFar + 1)
        + countAfterBlinking(atStone: Int(stoneString.dropFirst(half))!, times: times, blinksSoFar: blinksSoFar + 1)
    }

    return countAfterBlinking(atStone: stone * 2024, times: times, blinksSoFar: blinksSoFar + 1)
  }
}
