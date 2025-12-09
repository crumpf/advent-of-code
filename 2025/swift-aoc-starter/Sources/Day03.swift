import Algorithms

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var batteryBanks: [String] {
    data.split(separator: "\n").map(String.init)
  }

  func part1() -> Any {
    let joltages = batteryBanks.map {
      largestJoltage(in: $0, size: 2)
    }
    return joltages.reduce(0, +)
  }

  func part2() -> Any {
    let joltages = batteryBanks.map {
      largestJoltage(in: $0, size: 12)
    }
    return joltages.reduce(0, +)
  }
  
  func largestJoltage(in bank: String, size: Int) -> Int {
    let batteries = Array(bank)
    var joltage = ""
    var nextLargestIndex = 0
    for digit in 0..<size {
      for i in nextLargestIndex...(batteries.count-(size - digit)) {
        if batteries[i] > batteries[nextLargestIndex] {
          nextLargestIndex = i
        }
      }
      joltage.append(batteries[nextLargestIndex])
      nextLargestIndex += 1
    }
    return Int(joltage)!
  }
  
}
