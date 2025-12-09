import Algorithms

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var batteryBanks: [String] {
    data.split(separator: "\n").map(String.init)
  }

  func part1() -> Any {
    let joltages = batteryBanks.map {
      let batteries = Array($0)
      var mostSigIdx = 0
      for (idx, power) in batteries.dropLast().enumerated() {
        if power > batteries[mostSigIdx] {
          mostSigIdx = idx
        }
      }
      var leastSigIdx = mostSigIdx + 1
      for idx in leastSigIdx..<batteries.count {
        if batteries[idx] > batteries[leastSigIdx] {
          leastSigIdx = idx
        }
      }
      return Int("\(batteries[mostSigIdx])\(batteries[leastSigIdx])")!
    }

    return joltages.reduce(0, +)
  }

  func part2() -> Any {
    0
  }
}
