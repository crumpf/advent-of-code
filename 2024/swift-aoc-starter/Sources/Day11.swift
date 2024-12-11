import Algorithms

struct Day11: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var stones: [Stone] {
    data.split(separator: "\n").first!.split(separator: .whitespace).map { Stone(number: Int($0)!, blinks: 0) }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var lookup = [Stone: Int]()
    return stones.map {
      countAfterObserving(stone: $0, times: 25, stoneCountLookup: &lookup)
    }
    .reduce(0, +)
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var lookup = [Stone: Int]()
    return stones.map {
      countAfterObserving(stone: $0, times: 75, stoneCountLookup: &lookup)
    }
    .reduce(0, +)
  }

  func countAfterObserving(stone: Stone, times: Int, stoneCountLookup: inout [Stone: Int]) -> Int {
    guard stone.blinks < times else { return 1 }

    if let count = stoneCountLookup[stone] {
      return count
    }

    return stone.blink().map {
      let count = countAfterObserving(stone: $0, times: times, stoneCountLookup: &stoneCountLookup)
      stoneCountLookup[$0] = count
      return count
    }
    .reduce(0, +)
  }

  struct Stone: Hashable {
    let number: Int
    let blinks: Int

    func blink() -> [Stone] {
      if number == 0 {
        return [Stone(number: 1, blinks: blinks + 1)]
      }
      let stoneString = "\(number)"
      if stoneString.count.isMultiple(of: 2) {
        let half = stoneString.count / 2
        return [Stone(number: Int(stoneString.dropLast(half))!, blinks: blinks + 1),
                Stone(number: Int(stoneString.dropFirst(half))!, blinks: blinks + 1)]
      }
      return [Stone(number: number * 2024, blinks: blinks + 1)]
    }
  }
}
