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
    stones.map {
      var c = [ObservedStone: Int]()
      return countAfterObserving(stone: ObservedStone(number: $0, blinks: 0), times: 75, countMap: &c)
    }
    .reduce(0, +)
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

  func countAfterObserving(stone: ObservedStone, times: Int, countMap: inout [ObservedStone: Int]) -> Int {
    guard stone.blinks < times else { return 1 }

    if let count = countMap[stone] {
      return count
    }

    return stone.blink().map {
      if let count = countMap[$0] {
        return count
      }
      let count = countAfterObserving(stone: $0, times: times, countMap: &countMap)
      countMap[$0] = count
      return count
    }
    .reduce(0, +)
  }

  struct ObservedStone: Hashable {
    let number: Int
    let blinks: Int

    func blink() -> [ObservedStone] {
      if number == 0 {
        return [ObservedStone(number: 1, blinks: blinks + 1)]
      }
      let stoneString = "\(number)"
      if stoneString.count.isMultiple(of: 2) {
        let half = stoneString.count / 2
        return [ObservedStone(number: Int(stoneString.dropLast(half))!, blinks: blinks + 1),
                ObservedStone(number: Int(stoneString.dropFirst(half))!, blinks: blinks + 1)]
      }
      return [ObservedStone(number: number * 2024, blinks: blinks + 1)]
    }
  }
}
